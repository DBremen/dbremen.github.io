---
author: dirkbremen
comments: true
date: 2015-09-28 07:22:42+00:00
layout: post
link: https://powershellone.wordpress.com/2015/09/28/create-an-integrated-wpf-based-ise-add-on-with-powershell/
slug: create-an-integrated-wpf-based-ise-add-on-with-powershell
title: Create an integrated (WPF based) ISE Add-On with PowerShell
wordpress_id: 593
categories:
- PowerShell
tags:
- ISE
- WPF
---

![38887680_ffd3c02233_m](https://powershellone.files.wordpress.com/2015/09/38887680_ffd3c02233_m.jpg)

The goal of this post is to show you how to create an ISE Add-On that integrates itself graphically in a similar way as the built-in Show-Command Add-On (using the VerticalAddOnTools pane) without having to use Visual Studio and writing the code in C#. As an example I will walk you through the steps to create an Add-On that will generate comment based help for functions. The end product will look like this:
![Add-ScriptHelp](https://powershellone.files.wordpress.com/2015/09/add-scripthelp1.png?w=660)

While there are quite some tutorials around on how to do this using Visual Studio and C# (e.g.: [here](http://social.technet.microsoft.com/wiki/contents/articles/26639.how-to-create-and-use-an-add-on-for-the-powershell-ise.aspx)) I wanted to be able to do the same using PowerShell only.
I can't take full credit for the approach since I've just modified what James Brundage came up with for his [ISEPack Add-On](http://powershellise.com/). The function that takes care of the creation of the Add-On is ConvertTo-ISEAddOn. The version I'm using is heavily based on the original version that comes with the ISEPackv2 but also with [ShowUI/ConvertTo-ISEAddOn](http://show-ui.com/ConvertTo-ISEAddOn/?Download=true&AsHtml=true). The main difference between the original and the modified version are additional...:



	
  * Option to compile the Add-On into a .dll for faster loading (The original version creates the Add-On on the fly)

	
  * Option to generate multiple Add-Ons and compile them into one .dll

	
  * In relation to the above I've also added options to specify the namespace and classname(s) used for the ISE Add-On(s)

	
  * Option to add a menu item for the Add-On(s) (this is for testing purpose more on that further down below)


ConverTo-IseAddOn can be used in two different "modes":

	
  1. To create one or more ISE Add-On(s) in memory (that's the way ISEPack is making use of it). :

[code language="powershell"]
ConvertTo-ISEAddOn -ScriptBlock $addScriptHelp -AddVertically -Visible -DisplayName "Add-ScriptHelp" -addMenu
[/code]

In this case the generated code block is compiled and loaded into memory via Add-Type this would require the code to be re-generated (via ConvertTo-ISEAddOn) on every start of the ISE. I'm using the functionality only for testing purpose while developing a new Add-On.

	
  2. To create on or more ISE-AddOn(s) and compile them into a .dll.

[code language="powershell"]
ConvertTo-ISEAddOn -ScriptBlock $addScriptHelp -NameSpace $namespace -DLLPath $dllPath -class $classes
[/code]

This option has the advantage that the code generation needs to happen only once and the usage of the Add-On(s) only requires the .dll to be loaded.


The source code for Convert-ISEAddOn is a bit too long to embed but you can get it from [Gist](https://gist.github.com/a6d72a3c25f6d3690888) if you want to follow along.
The actual functionality to create the WPF UI, grab the values and generate the comment based help is done in a bit more than 100 lines. In this case I'm using [ShowUI](http://show-ui.com/) to help me generating the WPF UI but this can of course also be done without (you can see some examples of this within some of the other functions that I've added to my own ISE Add-On [ISEUtils](https://github.com/DBremen/ISEUtils)). I've updated the function with some [AST parsing](http://blogs.technet.com/b/heyscriptingguy/archive/2012/09/26/learn-how-it-pros-can-use-the-powershell-ast.aspx) in order to get the parameter names automatically in case the cursor is placed inside a function while launching the AddOn::

[code language="powershell"]
$addScriptHelp ={
    #get the parameters of the enclosing function at the current cursor position if any
    $lineNumber = $psISE.CurrentPowerShellTab.Files.SelectedFile.Editor.CaretLine
    $code = $psISE.CurrentPowerShellTab.Files.SelectedFile.Editor.Text
    $Errors = $Tokens = $null
    $AST = [System.Management.Automation.Language.Parser]::ParseInput($Code, [ref]$Tokens, [ref]$Errors)
    $functions = $AST.FindAll({ $args[0].GetType().Name -like "*FunctionDefinition*Ast" }, $true ) 
    $enclosingFunctionParamNames = -1
    foreach ($function in $functions){
        if ($function.Extent.StartLineNumber -le $lineNumber -and $function.Extent.EndLineNumber -ge $lineNumber){
            if ($function.Body.ParamBlock){
                $enclosingFunctionParamNames = $function.Body.ParamBlock.Parameters.Name.VariablePath.UserPath
            }
            else{
                $enclosingFunctionParamNames = $function.Parameters.Name.VariablePath.UserPath
            }
            break
        }
    }
    $dynamicParams = $false
    if ($enclosingFunctionParamNames -ne -1){
        $dynamicParams = $true
    }
    New-StackPanel {
        New-TextBlock -FontSize 17 -Margin "24 2 0 3" -FontWeight Bold -Text "Synopsis"
        New-TextBox -Margin "7, 5, 7, 5" -Name "txtSynopsis"
        New-TextBlock -FontSize 17  -Margin "24 2 0 3" -FontWeight Bold -Text "Description"
        New-TextBox -Margin "7, 5, 7, 5" -Name "txtDescription"
        if ($dynamicParams){
            foreach ($paramName in $enclosingFunctionParamNames){
                New-TextBlock -FontSize 17 -Margin "24 2 0 3" -FontWeight Bold -Text "Parameter description: $paramName" 
                New-TextBox -Margin "7, 5, 7, 5" -Name ("txt$paramName" + 'Desc')
            }
        }
        else{
            New-TextBlock -FontSize 17 -Margin "24 2 0 3" -FontWeight Bold -Text "1. Param"
            New-TextBox -Margin "7, 5, 7, 5" -Name "txtFirstParamName"
            New-TextBlock -FontSize 17 -Margin "24 2 0 3" -FontWeight Bold -Text "1. Param Description" 
            New-TextBox -Margin "7, 5, 7, 5" -Name "txtFirstParamDesc"
            New-TextBlock -FontSize 17 -Margin "24 2 0 3" -FontWeight Bold -Text "2. Param"
            New-TextBox -Margin "7, 5, 7, 5" -Name "txtSecondParamName"
            New-TextBlock -FontSize 17 -Margin "24 2 0 3" -FontWeight Bold -Text "2. Param Description"
            New-TextBox -Margin "7, 5, 7, 5" -Name "txtSecondParamDesc"
        }
        New-TextBlock -FontSize 17 -Margin "24 2 0 3" -FontWeight Bold -Text "Link"
        New-TextBox -Margin "7, 5, 7, 5" -Name "txtLink"
        New-TextBlock -FontSize 17 -Margin "24 2 0 3" -FontWeight Bold -Text "1. Example"
        New-TextBox -Margin "7, 5, 7, 5" -Name "txtFirstExample"
        New-TextBlock -FontSize 17 -Margin "24 2 0 3" -FontWeight Bold -Text "2. Example"
        New-TextBox -Margin "7, 5, 7, 5" -Name "txtSecondExample"
        New-CheckBox -Margin "5, 5, 2, 0"  -Name "chkOutput" {
            New-StackPanel -Margin "3,-5,0,0" {
                New-TextBlock -Name "OutputText" -FontSize 16 -FontWeight Bold -Text "Copy to clipboard"
                New-TextBlock -FontSize 14 TextWrapping Wrap
            }
        }
        New-Button -HorizontalAlignment Stretch -Margin 7 {
            New-TextBlock -FontSize 17 -FontWeight Bold -Text "Add to ISE"
        } -On_Click{
            $txtSynopsis = ($this.Parent.Children | where {$_.Name -eq "txtSynopsis"}).Text 
            $txtDescription = ($this.Parent.Children | where {$_.Name -eq "txtDescription"}).Text
            if ($dynamicParams){
                foreach ($paramName in $enclosingFunctionParamNames){
                    Set-Variable ("txt$paramName" + 'Desc') -Value ($this.Parent.Children | 
                        where {$_.Name -eq ("txt$paramName" + 'Desc')}).Text
                }
            }
            else{
                $txtFirstParamName = ($this.Parent.Children | where {$_.Name -eq "txtFirstParamName"}).Text
                $txtFirstParamDesc = ($this.Parent.Children | where {$_.Name -eq "txtFirstParamDesc"}).Text
                $txtSecondParamName = ($this.Parent.Children | where {$_.Name -eq "txtSecondParamName"}).Text
                $txtSecondParamDesc = ($this.Parent.Children | where {$_.Name -eq "txtSecondParamDesc"}).Text
            }
            $txtLink = ($this.Parent.Children | where {$_.Name -eq "txtLink"}).Text 
            $txtFirstExample = ($this.Parent.Children | where {$_.Name -eq "txtFirstExample"}).Text 
            $txtSecondExample = ($this.Parent.Children | where {$_.Name -eq "txtSecondExample"}).Text 
            $chkOutput = ($this.Parent.Children | where {$_.Name -eq "chkOutput"}).isChecked
            $helptext=@"
    <#    
    .SYNOPSIS
        $txtSynopsis
    .DESCRIPTION
        $txtDescription
"@
            if ($dynamicParams){
                foreach ($paramName in $enclosingFunctionParamNames){
                    $txtParamDesc = Get-Variable -Name ("txt$paramName" + 'Desc') -ValueOnly
                    $helpText+="`n`t.PARAMETER $paramName`n`t`t$txtParamDesc"
                }
            }
            else{
                if ($txtFirstParamName) {
                    $helpText+="`n`t.PARAMETER $txtFirstParamName`n`t`t$txtFirstParamDesc"
                }
                if ($txtSecondParamName) {
                    $helpText+="`n`t.PARAMETER $txtSecondParamName`n`t`t$txtSecondParamDesc"
                }
            }

            if ($txtFirstExample) {
                $helpText+="`n`t.EXAMPLE`n`t`t$txtFirstExample"
            }
            if ($txtSecondExample) {
                $helpText+="`n`t.EXAMPLE`n`t`t$txtSecondExample"
            }
            if ($txtLink) {
                $helpText+="`n`t.LINK`n`t`t$txtLink"
            }
        $helpText+="`n" + @"
    .NOTES 
        CREATED:  $((Get-Date).ToShortDateString())
        AUTHOR      :  $env:USERNAME
	    Changelog:    
	        ----------------------------------------------------------------------------------                                           
	        Name          Date         Description        
	        ----------------------------------------------------------------------------------
	        ----------------------------------------------------------------------------------
  
"@.TrimEnd() + "`n`t#>"
            if ($chkOutput) {
                $helptext | clip
		    } 
            $psise.CurrentPowerShellTab.Files.SelectedFile.Editor.InsertText($helpText)  
        }
    }  
}
[/code]

For a test run we can use the first mode of ConvertTo-ISEAddOn:

[code language="powershell"]
ConvertTo-ISEAddOn -ScriptBlock $addScriptHelp -AddVertically -Visible -DisplayName "Add-ScriptHelp" -addMenu
[/code]

If you followed along this should successfully generate and load the Add-On (remember that this also requires the ShowUI module to be present). Just in case I've also uploaded the complete code so far (+ what follows) separately to [GitHub](https://raw.githubusercontent.com/DBremen/PowerShellScripts/master/functions/Add-ScriptHelpISEAddOn.ps1).
Since everything is working fine we can go ahead now and compile the Add-On into a .dll:

[code language="powershell"]
$dllPath = "$env:USERPROFILE\Desktop\AddScriptHelp.dll"
ConvertTo-ISEAddOn -ScriptBlock $addScriptHelp -NameSpace ISEUtils -DLLPath $dllPath -class AddScriptHelp
[/code]

To have the function constantly available in the ISE Add-On we need to add the following to your profile (you can read [here](http://www.computerperformance.co.uk/powershell/powershell_profile_ps1.htm) and [here](http://blogs.technet.com/b/heyscriptingguy/archive/2012/05/21/understanding-the-six-powershell-profiles.aspx) to see how to work with profiles). This will add an entry to the Add-ons menu and load the Add-On when the entry is clicked:

[code language="powershell"]
Add-Type -Path $dllPath
$addScriptHelp = {
    #check if the AddOn if loaded if yes unload and re-load it
    $currentNameIndex = -1
    $name = 'Add-ScriptHelp'
    $currentNames = $psISE.CurrentPowerShellTab.VerticalAddOnTools.Name
    if ($currentNames){
        $currentNameIndex = $currentNames.IndexOf($name)
        if ($currentNameIndex -ne -1){
            $psISE.CurrentPowerShellTab.VerticalAddOnTools.RemoveAt($currentNameIndex)
        }
    }
    $psISE.CurrentPowerShellTab.VerticalAddOnTools.Add($name,[ISEUtils.AddScriptHelp],$true)
    ($psISE.CurrentPowerShellTab.VerticalAddOnTools | where {$_.Name -eq $name}).IsVisible=$true
}
$psISE.CurrentPowerShellTab.AddOnsMenu.Submenus.Add('Add-ScriptHelp', $addScriptHelp, $null)
[/code]

As mentioned above this function and more is also part of my ISE Add-On [ISEUtils](https://github.com/DBremen/ISEUtils)

![shareThoughts](https://powershellone.files.wordpress.com/2015/10/sharethoughts.jpg)



* * *



Photo Credit: [Nomad Photography](https://www.flickr.com/photos/52701968@N00/38887680/) via [Compfight](http://compfight.com) [cc](https://creativecommons.org/licenses/by-nc-nd/2.0/)
