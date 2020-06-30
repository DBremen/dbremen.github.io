---
author: dirkbremen
comments: true
date: 2015-09-16 08:19:35+00:00
layout: post
link: https://powershellone.wordpress.com/2015/09/16/adding-edit-with-powershell-ise-and-open-powershell-here-as-admin-to-the-context-menu/
slug: adding-edit-with-powershell-ise-and-open-powershell-here-as-admin-to-the-context-menu
title: Adding 'Edit with PowerShell ISE' and 'Open PowerShell here (as Admin)' to
  the context menu
wordpress_id: 535
categories:
- PowerShell
---

![1002140874_11967e2e51_m](https://powershellone.files.wordpress.com/2015/09/1002140874_11967e2e51_m.jpg)
In order to edit PowerShell files within PowerShell ISE I used to just drag and drop them from Windows Explorer into the ISE scripting pane. Unfortunately this doesn't work anymore (I believe since Windows 8). The best explanation for the behaviour I found is [here](http://blogs.msdn.com/b/patricka/archive/2010/01/28/q-why-doesn-t-drag-and-drop-work-when-my-application-is-running-elevated-a-mandatory-integrity-control-and-uipi.aspx). In short drag and drop doesn't work from Windows Explorer to an elevated application because of the higher Mandatory Integrity Control (MIC) level of the drag & drop source (Windows Explorer has a default level of medium while the elevated application runs with a high MIC level). There are several workarounds available but they all have negative side effects (elevating explorer to a higher privileges, disabling UAT...). 
The workaround I'm using is adding a context menu for all PowerShell related files to Edit them with PowerShell ISE (while there is already a default 'Edit' context menu entry for PowerShell ISE I like to have it open a specific platform version elevated without loading profile). In addition to that I also like to add a context menu entry to open up a PowerShell command prompt from any folder or drive in Windows Explorer:
![editWithPowerShellISE](https://powershellone.files.wordpress.com/2015/09/editwithpowershellise.png)
![openPowerShellHere](https://powershellone.files.wordpress.com/2015/09/openpowershellhere.png)
I wrapped the creation of the context menu into a function. The function offers to following options:




  * Add 'Edit with PowerShell ISE' context menu entry


  * Add 'Open PowerShell here' context menu entry (to Directories, Directory Backgrounds and Drive(s))


  * The type of context menu entry can be specified by using the contextType parameter


  * Specify the platform (x64 is default) of Windows PowerShell to open


  * Add the -noProfile switch when opening ISE or PowerShell console (-noProfile switch)


  * Run the PowerShell instance as admin (-asAdmin switch)



Example usage:
[code language="powershell"]
Add-PowerShellContextMenu -contextType editWithPowerShellISE -platform x86 -asAdmin
Add-PowerShellContextMenu -contextType openPowerShellHere -platform x86 -asAdmin
[/code]
Below is the source code for 'Add-PowerShellContextMenu', but the function can also be downloaded via [GitHub](https://github.com/DBremen/PowerShellScripts/tree/master/functions).
https://gist.github.com/d598906c17f3fd2eabc9

![shareThoughts](https://powershellone.files.wordpress.com/2015/10/sharethoughts.jpg)


* * *


Photo Credit: [slack12](https://www.flickr.com/photos/84923476@N00/1002140874/) via [Compfight](http://compfight.com) [cc](https://creativecommons.org/licenses/by-nc-nd/2.0/)
