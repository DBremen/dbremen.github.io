---
author: dirkbremen
comments: true
date: 2015-10-12 06:15:17+00:00
layout: post
link: https://powershellone.wordpress.com/2015/10/12/powershell-tricks-useful-default-parameters-to-add-to-your-profile/
slug: powershell-tricks-useful-default-parameters-to-add-to-your-profile
title: PowerShell tricks – Useful default parameters to add to your profile
wordpress_id: 674
categories:
- PowerShell
tags:
- tricks
---

![15389627623_7ef1f7595f_m](https://powershellone.files.wordpress.com/2015/10/15389627623_7ef1f7595f_m.jpg)
Since version 3 PowerShell introduced $PSDefaultParameterValues which is a built-in preference variable which lets you specify default values for any cmdlet or advanced function. You can read much more about it inside the [respective help file](https://technet.microsoft.com/en-us/library/hh847819.aspx). In a nutshell $PSDefaultParameterValues is a hash-table where (in its most common version) the key consists of the cmdlet name and parameter name separated by a colon (:) and the value is the custom default value:
[code language="powershell"]
<CmdletName>:<ParameterName>"="<DefaultValue>
[/code]
I've added the following default parameter values to my profile (You can read [here](http://www.computerperformance.co.uk/powershell/powershell_profile_ps1.htm) and [here](http://blogs.technet.com/b/heyscriptingguy/archive/2012/05/21/understanding-the-six-powershell-profiles.aspx) on how to work with profiles):
[code language="powershell"]
$PSDefaultParameterValues.Add("Get-ChildItem:Force",$true)
$PSDefaultParameterValues.Add("Receive-Job:Keep",$true)
$PSDefaultParameterValues.Add("Format-Table:AutoSize",$true)
$PSDefaultParameterValues.Add("Import-Module:Force",$true)
$PSDefaultParameterValues.Add('Export-Csv:NoTypeInformation', $true)
$PSDefaultParameterValues.Add('Get-Member:Force', $true)
$PSDefaultParameterValues.Add('Format-List:Property', '*')
$PSDefaultParameterValues.Add('Set-Location:Path', '..')
$PSDefaultParameterValues.Add('Get-Help:Detailed', $true )
[/code]
What are other default parameter values that you use?

![shareThoughts](https://powershellone.files.wordpress.com/2015/10/sharethoughts.jpg)


* * *


Photo Credit: [coloneljohnbritt](https://www.flickr.com/photos/30453657@N04/15389627623/) via [Compfight](http://compfight.com) [cc](https://creativecommons.org/licenses/by-nc-sa/2.0/)
