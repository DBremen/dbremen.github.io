---
author: dirkbremen
comments: true
date: 2015-09-02 12:47:14+00:00
layout: post
link: https://powershellone.wordpress.com/2015/09/02/use-powershell-to-open-regedit-at-a-specific-or-regjump-for-powershell/
slug: use-powershell-to-open-regedit-at-a-specific-or-regjump-for-powershell
title: Use PowerShell to open regedit at a specific path or RegJump for PowerShell
wordpress_id: 466
categories:
- PowerShell
tags:
- native commands
---

![12206559615_2b81475662_m](https://powershellone.files.wordpress.com/2015/09/12206559615_2b81475662_m.jpg)
Even though PowerShell contains everything to read and write to the registry I still find myself quite frequently opening the registry editor (aka regedit.exe). Since navigating the tree manually can be quite time consuming I used to rely on [RegJump](https://technet.microsoft.com/en-us/sysinternals/bb963880.aspx?f=255&MSPPError=-2147217396) developed by Mark Russinovich. 
I was wondering if the same could be implemented using PowerShell and maybe even adding some features like opening multiple registry keys either from the clipboard or provided as an argument to the function. 
Say hello to Open-Registry alias regJump. The function opens (instances of) the registry editor for provided paths from the clipboard or as argument to the regKey parameter. The registry paths can contain hive name shortnames like HKLM, HKCU, HKCR or PowerShell provider paths syntax like HKLM:\, HKCU:\.
Similar to how RegJump.exe handles non-existing paths Open-Registry also ignores those parts of the path and works its way backwards until it finds a valid path or returns an error message if the path doesn't contain any valid parts.
Let's look at some example use cases:



	
  1. Opening multiple instances of regedit at the specified paths via an argument to the regKey paramater:
[code language="powershell"]
$testKeys =@'
HKLM\Software\Microsoft\Outlook Express
HKLM\Software\Microsoft\PowerShell
HKLM\Software\Microsoft\Windows
'@ -split "`r`n"
Open-Registry $testKeys
[/code]


	
  2. Same as above but the keys are no copied to the clipboard instead:
[code language="powershell"]
  @'
HKLM\Software\Microsoft\Outlook Express
HKLM\Software\Microsoft\PowerShell
HKLM\Software\Microsoft\Windows
'@ -split "`r`n" | clip
Open-Registry
[/code]


  3. The example will open regedit with the run key open as the last part of the path does not represent a key
[code language="powershell"]
Open-Registry HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\Skype
[/code]


  4. The example provides an invalid path to the function (using the alias) resulting in a warning message and no instance of regedit opening
[code language="powershell"]
regJump HKLMm\xxxxx
[/code]


Further down below is the source code for the function without comment based help in order to reduce its screen size but the full version can be download from [GitHub](https://github.com/DBremen/PowerShellScripts/blob/master/functions/Open-Registry.ps1). 
As usual when writing PowerShell I've learned one or the other thing along the way. This time I learned how to start a process and wait until its window is visible (this was necessary since otherwise regedit would launch all instances opened on the last path (when multiple paths were passed to the function)):
https://gist.github.com/54403d02c24e303cb5f1

https://gist.github.com/0fab3cb49ecbfa1a6460

![shareThoughts](https://powershellone.files.wordpress.com/2015/10/sharethoughts.jpg)


* * *


Photo Credit: [eLKayPics _ off](https://www.flickr.com/photos/43563866@N02/12206559615/) via [Compfight](http://compfight.com) [cc](https://creativecommons.org/licenses/by-nc-nd/2.0/)
