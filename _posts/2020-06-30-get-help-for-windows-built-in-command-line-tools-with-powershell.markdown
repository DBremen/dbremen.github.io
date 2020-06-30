---
author: dirkbremen
comments: true
date: 2016-05-23 08:17:35+00:00
layout: post
link: https://powershellone.wordpress.com/2016/05/23/get-help-for-windows-built-in-command-line-tools-with-powershell/
slug: get-help-for-windows-built-in-command-line-tools-with-powershell
title: Get help for Windows built-in command-line tools with PowerShell
wordpress_id: 1120
categories:
- PowerShell
---

![26709891580_b8657b36d2_m](https://powershellone.files.wordpress.com/2016/05/26709891580_b8657b36d2_m.jpg)
One of the reasons I like PowerShell is its built-in help system ([here](http://www.darkoperator.com/blog/2013/1/15/powershell-basicsusing-the-help-subsystem.html) is a nice post in case you don't know how to use PowerShell's built-in help). E.g.:
[code language="powershell"]
Get-Help Get-Command
Get-Help Get-Command -Examples
Get-Help Get-Command -Parameter Name
[/code]
In fact, once you get comfortable using PowerShell help aka Get-Help, you start missing similar built-in documentation for other tools/scripting languages. Wouldn't it be nice if one could use Get-He.lp for Windows command-line tools?:
[code language="powershell"]
Get-Help chkdsk
Get-Help chkdsk -Examples
Get-Help chkdsk -Paramater c
[/code]

![GetLegacyHelp](https://powershellone.files.wordpress.com/2016/05/getlegacyhelp.png)
Say 'Hello' to Get-LegacyHelp! With Get-LegacyHelp you can retrieve help for built-in windows command line tools in a similar way as Get-Help works against PowerShell cmdlets. 
How does it work? Importing the module (Get-LegacyHelp.psm1) and running Get-LegacyHelp (alias glh) the first time will perform the following steps:



	
  * Download the Windows command line reference help file [WinCmdRef.chm](https://www.microsoft.com/en-ie/download/details.aspx?id=2632)

	
  * Download and extract the [HTML Agility pack](https://htmlagilitypack.codeplex.com/) dll

	
  * Decomple the .chm into separate .html files using hh.exe

	
  * Rename the html files and extract the information (using HTML Agility Pack) into PSObject format

	
  * Export the entire object to disk using Export-CliXml



Afterwards (and for any subsequent invocation):


  * The XML is imported...


  * Relevant information filtered..


  * and the data is displayed in a similar format to the Get-Help output


Get-LegacyHelp supports the -Parameter, -Full, and -Examples parameters:
[![GetLegacyHelpExamples](https://powershellone.files.wordpress.com/2016/05/getlegacyhelpexamples.png)](https://powershellone.files.wordpress.com/2016/05/getlegacyhelpexamples.png)

[![GetLegacyHelpParameter](https://powershellone.files.wordpress.com/2016/05/getlegacyhelpparameter.png)](https://powershellone.files.wordpress.com/2016/05/getlegacyhelpparameter.png)

The Module can be downloaded from my [GitHub repository](https://github.com/DBremen/PowerShellScripts/tree/master/functions). It's not perfect since the information is not consistently structured throughout the .chm file. If you want to improve it, please feel free to fork and share.

![shareThoughts](https://powershellone.files.wordpress.com/2015/10/sharethoughts.jpg)



* * *



Photo Credit: [Bruno Zaffoni](https://www.flickr.com/photos/78678985@N04/26709891580/) via [Compfight](http://compfight.com) [cc](https://creativecommons.org/licenses/by-nc-sa/2.0/)
