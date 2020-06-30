---
author: dirkbremen
comments: true
date: 2016-02-13 21:31:59+00:00
layout: post
link: https://powershellone.wordpress.com/2016/02/13/retrieve-uninstallstrings-to-fix-installer-issues/
slug: retrieve-uninstallstrings-to-fix-installer-issues
title: Retrieve UninstallStrings to fix installer issues
wordpress_id: 1013
categories:
- PowerShell
- Troubleshooting
tags:
- Installer
- MSI
---

![24356667904_413b3b0856_m](https://powershellone.files.wordpress.com/2016/02/24356667904_413b3b0856_m.jpg)
Recently I have encountered several installer related issues on my machine. Most of them seemed to be caused by insufficient privileges. 
This kind of issue can be usually fixed by running the installer "As Administrator". In case the issue is in relation to an already installed software packet, it's sometimes not so easy to locate the respective uninstaller/MSI packet, though. For that purpose, I've written a small PowerShell function that scans the registry (it turned out that if you are using PowerShell v5, there is a better way of doing this. See below for more details) (have a look [here](http://gregramsey.net/2012/02/20/win32_product-is-evil/) on why I didn't want to use WMI Win32_Product instead) for the information. The function has the following features:



	
  * Search for software by name including wildcards (parameter DisplayName defaults to '*')

	
  * Search through user specific (HKCU) and/or machine specific (HKLM) registry hives (parameter Hive defaults to HKLM, HKCU only accepts a combination of 'HKCU' and/or 'HKLM')

	
  * If a key is found matching the DisplayName. Output an object with the following properties: RegistryHive, DisplayName, UninstallString, msiGUID (if present), InstallLocation=$subKey.InstallLocation, Version (DisplayVersion)


Usage (if your PowerShell version < 5):
[code language="powershell"]
#search for the chrome uinstaller only in the machine wide registry hive
Get-Uninstaller *chrome* -Hive HKLM
[/code]
Output:
![GetUninstaller](https://powershellone.files.wordpress.com/2016/02/getuninstaller.png)
If you happen to be on PowerShell v5 ($PSVersionTable.PSVersion.Major -eq 5) you can use the built-in Get-Package to retrieve the same information:
https://gist.github.com/b1f581769ddb515e6392

Armed with that information one can easily run the installer (MSI) or uninstall routine with elevated privileges in order to fix some installer related issues. For msi installer packets the following command will reinstall the respective software (see [here ](https://msdn.microsoft.com/en-us/library/windows/desktop/aa371182(v=vs.85).aspx)for more details on the reinstall mode). It hopefully goes without saying, that you should only run those commands if you know what you are doing:
[code light="true"]
msiexec /i {msiGUID} REINSTALL=ALL REINSTALLMODE=omus /l*v log.txt
[/code]
Below is the source of the helper function for older PowerShell version. I have also uploaded another adaption that uses the best approach depending on the PowerShell version, to [my GitHub repo](https://github.com/DBremen/PowerShellScripts/tree/master/functions).
https://gist.github.com/2225b030b75388ad53c7


![shareThoughts](https://powershellone.files.wordpress.com/2015/10/sharethoughts.jpg)



* * *




Photo Credit: [Chad Sparkes](https://www.flickr.com/photos/113086034@N04/24356667904/) via [Compfight](http://compfight.com) [cc](https://creativecommons.org/licenses/by/2.0/)
