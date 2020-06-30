---
author: dirkbremen
comments: true
date: 2015-10-01 17:41:42+00:00
layout: post
link: https://powershellone.wordpress.com/2015/10/01/powershell-tricks-using-dots-to-refer-to-the-current-location/
slug: powershell-tricks-using-dots-to-refer-to-the-current-location
title: PowerShell tricks - Using dot(s) to refer to the current location
wordpress_id: 632
categories:
- PowerShell
tags:
- tricks
---

![9663950111_c97678228e_m](https://powershellone.files.wordpress.com/2015/09/9663950111_c97678228e_m.jpg)
Most people are aware that PowerShell supports commandline navigation in the same way as the good old command prompt (see my previous post [Improve PowerShell commandline navigation](https://powershellone.wordpress.com/2015/03/03/improve-powershell-commandline-navigation/) for ways to enhance this):
[code language="powershell"]
cd $env:USERPROFILE\Desktop
Resolve-Path '.'
#change to the current direction (doing nothing)
cd .
#move up one level
Resolve-Path '..'
cd ..
[/code]
The above is using cd as the alias for the Set-Location Cmdlet providing:



	
  * One dot as an argument for the Path parameter representing the current location (changing the location to the current location does effectively nothing)

	
  * Two dots for the Path as an argument for the Path parameter representing one level higher than the current location



Since this is implemented by the Provider (at least that's what I believe) the same concept can be used in many different places, basically every built-in command that has a Path parameter.:
[code language="powershell"]
#get all the built-in commands that have a Path parameter
Get-Command | where { $_.Parameters -and $_.Parameters.ContainsKey('Path') -and $_.HelpURI -and $_.HelpURI.StartsWith('http://go.microsoft.com') }

#navigation works also with the registry provider
cd HKLM:\Software\Microsoft
cd ..
cd c:
#open windows explorer using the current location (ii is the alias for Invoke-Item)
ii .
#same one level higher
ii ..
#Within ISE open all files in the current folder or one level higher
psedit .
psedit ..
#copy the current folder and its content to a folder one level higher
copy * ..\test
[/code]
Please share if you know of more tricks using dot(s) as an argument to the Path parameter.

![shareThoughts](https://powershellone.files.wordpress.com/2015/10/sharethoughts.jpg)


* * *


Photo Credit: [Rein -e- Art](https://www.flickr.com/photos/63992625@N06/9663950111/) via [Compfight](http://compfight.com) [cc](https://creativecommons.org/licenses/by-nc/2.0/)
