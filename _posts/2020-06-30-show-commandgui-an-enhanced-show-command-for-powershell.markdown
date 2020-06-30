---
author: dirkbremen
comments: true
date: 2015-10-22 17:53:19+00:00
layout: post
link: https://powershellone.wordpress.com/2015/10/22/show-commandgui-an-enhanced-show-command-for-powershell/
slug: show-commandgui-an-enhanced-show-command-for-powershell
title: Show-CommandGUI an enhanced Show-Command for PowerShell
wordpress_id: 803
categories:
- PowerShell
tags:
- AST
- GUI
---

![2036545266_e1f19d8cdd_m](https://powershellone.files.wordpress.com/2015/10/2036545266_e1f19d8cdd_m.jpg)
After my last post ([PowerShell tricks - Use Show-Command to add a simple GUI to your functions](https://powershellone.wordpress.com/2015/10/13/powershell-tricks-use-show-command-to-add-a-simple-gui-to-your-functions/)). I was thinking how one could write a function that would not have the deficiencies that Show-Command has when it comes to providing a GUI for functions. In addition to what Show-Command does I wanted a function that:



	
  * Considers advanced function parameters (i.e. ValidateScript, ValidatePattern, ValidateRange, ValideLength)

	
  * Populates the fields with the respective default values (if applicable)

        
  * Provides a browse for file or browse for folder option (if the parameter name contains 'file' or 'folder')


  * Provides meaningful error messages via message boxes

	
  * Doesn't require the use of Invoke-Expression in order to run the parameters against the command


  * Can be customized to my own preferences



Say hello to Show-CommandGUI.

![Show-CommandGUI](https://powershellone.files.wordpress.com/2015/10/show-commandgui1.png)
The screenshot above is produced with the following test function:
[code language="powershell"]
function test{
    [CmdletBinding(DefaultParameterSetName='Basic')]
    Param
    (
        [Parameter(Mandatory=$true, 
                   Position=0,
                   ParameterSetName='Basic')]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("sun", "moon", "earth")] 
        [string]$choice,
        [ValidateRange(2,5)]
        $number,
        [ValidatePattern("^[a-z]")]
        [ValidateLength(2,5)]
        [String]$pattern,
        [ValidateScript({$_ -like '*test'})]
        $string,
        [Parameter(ParameterSetName='Advanced')]
        [switch]$switch,
        [Parameter(Mandatory=$true, ParameterSetName='Advanced')]
        $filePath = 'c:\test.txt',
        [Parameter(Mandatory=$true, ParameterSetName='Basic')]
        $folderPath = 'c:\'
    )
    "pattern: $pattern"
    "number: $number"
    "string: $string"
    if ($PSCmdlet.ParameterSetName -eq 'Advanced'){
        "switch: $switch"
        "filePath: $filePath"
    }
    else{
        "choice: $choice"
        "folderPath: $folderPath"
    }
}
[/code]
Producing the GUI is as simple as this:
[code language="powershell"]
Import-Module "$PATHTOMODULE\Show-CommandGUI.psm1"
Show-CommandGUI test
[/code]
The module and the test function can be downloaded via [GitHub](https://github.com/DBremen/Show-CommandGUI). Please let me know if you have any questions or ideas on how to improve the function.

![shareThoughts](https://powershellone.files.wordpress.com/2015/10/sharethoughts.jpg)


* * *


Photo Credit: [Fernando X. Sanchez](https://www.flickr.com/photos/73487842@N00/2036545266/) via [Compfight](http://compfight.com) [cc](https://creativecommons.org/licenses/by-nc-nd/2.0/)
