---
author: dirkbremen
comments: true
date: 2016-02-29 17:19:27+00:00
layout: post
link: https://powershellone.wordpress.com/2016/02/29/add-spell-checking-to-powershell-ise/
slug: add-spell-checking-to-powershell-ise
title: Add spell checking to PowerShell ISE
wordpress_id: 1060
categories:
- PowerShell
tags:
- ISE
---

![4126262859_88a806a90e_m](https://powershellone.files.wordpress.com/2016/02/4126262859_88a806a90e_m.jpg)

While the PowerShell ISE is obviously for writing PowerShell code rather than text, I usually have a fair amount of it in some of my scripts due to comments or hard coded text elements. Therefore, I thought that it would be handy to have the ability to verify selected text against a spell checker.

![spellcheck](https://powershellone.files.wordpress.com/2016/02/spellcheck.gif)

I have extended my ISEUtils (It can be downloaded from my [GitHub repository](https://github.com/DBremen/ISEUtils)) module with the functionality. The spell checking works against the selected text within the ISE and can be activated by pressing F7. 
The spell checking is based on the built-in ability of the [WPF TextBox](https://msdn.microsoft.com/en-us/library/system.windows.controls.primitives.textboxbase.spellcheck%28v=vs.110%29.aspx) which automatically adds the squiggly lines for misspelled words and the spelling suggestions within the context menu. Clicking on the button "Auto Correct" will automatically correct the whole text using the first spelling suggestion (this can lead to some funny results). The spelling uses the "en-us" dictionary if you want to change this you will need to modify the code.
The "spell-checking code" is fairly simple (using [ShowUI](http://show-ui.com/) to build the GUI):
[code language="powershell"]
New-DockPanel {
        New-Button 'Auto-Correct (use first spelling suggestion)' -Dock Bottom -On_Click{
            $txtBox = $this.Parent.Children | where {$_.Name -eq 'txtBox'}
            $startIndex = 0
            $errorIndex = $txtBox.GetNextSpellingErrorCharacterIndex($startIndex, [System.Windows.Documents.LogicalDirection]::Forward)
            while ($errorIndex -ne -1){
                $startIndex = $errorIndex
                $error = $txtBox.GetSpellingError($errorIndex)
                $suggestion = @($error.suggestions)[0]
                if ($suggestion){
                    $error.Correct($suggestion)
                }
                $errorIndex = $txtBox.GetNextSpellingErrorCharacterIndex($startIndex, [System.Windows.Documents.LogicalDirection]::Forward)
                if ($errorIndex -eq $startIndex){
                    $errorIndex = $txtBox.Text.IndexOf(' ',$startIndex) + 1
                }
            }
        }
        New-TextBox -Language 'en-us' -Dock Top -TextWrapping Wrap -VerticalAlignment Stretch -HorizontalAlignment Stretch -Name txtBox  -FontSize 15 -AcceptsReturn -On_Loaded {                       
            $this.Text = $psise.CurrentPowerShellTab.Files.SelectedFile.Editor.SelectedText           
            $this.SpellCheck.IsEnabled = $true          
        }
} -Show
[/code]



![shareThoughts](https://powershellone.files.wordpress.com/2015/10/sharethoughts.jpg)



* * *



Photo Credit: [Will Montague](https://www.flickr.com/photos/36607441@N05/4126262859/) via [Compfight](http://compfight.com) cc
