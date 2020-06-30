---
author: dirkbremen
comments: true
date: 2016-05-06 07:43:15+00:00
layout: post
link: https://powershellone.wordpress.com/2016/05/06/powershell-tricks-open-a-dialog-as-topmost-window/
slug: powershell-tricks-open-a-dialog-as-topmost-window
title: PowerShell tricks – Open a dialog as topmost window
wordpress_id: 1104
categories:
- PowerShell
tags:
- tricks
---

![26738830652_745071e136_m](https://powershellone.files.wordpress.com/2016/05/26738830652_745071e136_m.jpg)
Windows.Forms provides easy access to several built-in dialogs (see [MSDN: Dialog-Box Controls and Components](https://msdn.microsoft.com/en-us/library/6t3a1fcc%28v=vs.110%29.aspx)). Here is an usage example to show a "FolderBrowse" dialog:
[code language="powershell"]
Add-Type -AssemblyName Windows.Forms
$FolderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
$FolderBrowser.Description = 'Select the folder containing the data'
$result = $FolderBrowser.ShowDialog()
if ($result -eq [Windows.Forms.DialogResult]::OK){
    $FolderBrowser.SelectedPath
}
else {
    exit
}
[/code]
While this works as expected, the dialog won't show up as the topmost window. This could lead to situations where users of your script might miss the dialog or simply complain because they have to switch windows. Even though there is no built-in property to set the dialog as the topmost window, the same can be achieved using the second overload of the ShowDialog method ([MSDN: ShowDialog method](https://msdn.microsoft.com/en-us/library/system.windows.forms.form.showdialog%28v=vs.110%29.aspx)). This overload expects a parameter which indicates the parent windows of the dialog. Since the owning window will not be used after the dialog has been closed we can just create a new form on the fly within the method call:
[code language="powershell" highlight="4"]
Add-Type -AssemblyName System.Windows.Forms
$FolderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
$FolderBrowser.Description = 'Select the folder containing the data'
$result = $FolderBrowser.ShowDialog((New-Object System.Windows.Forms.Form -Property @{TopMost = $true }))
if ($result -eq [Windows.Forms.DialogResult]::OK){
    $FolderBrowser.SelectedPath
}
else {
    exit
}
[/code]


![shareThoughts](https://powershellone.files.wordpress.com/2015/10/sharethoughts.jpg)



* * *



Photo Credit: [Infomastern](https://www.flickr.com/photos/55856449@N04/26738830652/) via [Compfight](http://compfight.com) [cc](https://creativecommons.org/licenses/by-sa/2.0/)
