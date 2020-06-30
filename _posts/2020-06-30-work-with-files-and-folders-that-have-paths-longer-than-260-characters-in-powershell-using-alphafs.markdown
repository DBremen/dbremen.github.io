---
author: dirkbremen
comments: true
date: 2015-03-13 21:09:20+00:00
layout: post
link: https://powershellone.wordpress.com/2015/03/13/work-with-files-and-folders-that-have-paths-longer-than-260-characters-in-powershell-using-alphafs/
slug: work-with-files-and-folders-that-have-paths-longer-than-260-characters-in-powershell-using-alphafs
title: Work with files and folders that have paths longer than 260 characters in PowerShell
  using AlphaFS
wordpress_id: 168
categories:
- PowerShell
---

[![tree](https://powershellone.files.wordpress.com/2015/03/16686561952_1442f9d941_m.jpg)](https://powershellone.files.wordpress.com/2015/03/16686561952_1442f9d941_m.jpg)

If you try to use one of the built-in 'item' cmdlets (i.e. Get-Command *item* -Module Microsoft.PowerShell.Management) on the FileSystem provider with a path that is longer than 260 characters (actually > 248 characters on a folder and > 260 on a file), you will not be able to do it. For example running the line below in order to create a folder structure on c: that is longer than 260 characters :
[code language="powershell"]
1..60 | foreach {$folderTree = 'c:\'} {$folderTree += "test$_\"}
$folderTree.Length
mkdir $folderTree
[/code]
Will result in an error message:
[![screenShotFilePath](https://powershellone.files.wordpress.com/2015/03/screenshotfilepath.png)](https://powershellone.files.wordpress.com/2015/03/screenshotfilepath.png)
This is not only a PowerShell deficiency but stems probably from the good old Dos days and applies as well to the underlying .Net methods. You can read more about it [here](http://stackoverflow.com/questions/1880321/why-does-the-260-character-path-length-limit-exist-in-windows) if you fancy. While there are ways around it (e.g. using subst or \\?\ prefix), those are not really nice solution.
This is where AlphaFS can help. According to the description on the [project's webpage](http://alphafs.alphaleonis.com/) 


<blockquote>
The file system support in .NET is pretty good for most uses. However there are a few shortcomings, which this library tries to alleviate. The most notable deficiency of the standard .NET System.IO is the lack of support of advanced NTFS features, most notably extended length path support (eg. file/directory paths longer than 260 characters).
</blockquote>


it's a perfect fit for the problem at hand. Let's see how we can use AlphaFS through PowerShell starting off by downloading and un-compressing the release version from the project's github repository:
[code language="powershell"]
cd c:\
#download and unzip
mkdir 'AlphaFS'
$destFolder = 'C:\AlphaFS'
$url = 'https://github.com/alphaleonis/AlphaFS/releases/download/v2.0.1/AlphaFS.2.0.1.zip'
Invoke-WebRequest $url -OutFile "$destFolder\AlphaFS.zip"
$shFolder = (New-Object -ComObject Shell.Application).NameSpace($destFolder)
$shZip = (New-Object -ComObject Shell.Application).NameSpace('C:\AlphaFS\AlphaFS.zip')
$shFolder.CopyHere($shZip.Items(),16)
del "$destFolder\AlphaFS.zip"
[/code]
Now we can load the library, explore it and start accessing its members (we'll use the .net v4 version):
[code language="powershell"]
$alphaFS = Add-Type -Path $destFolder\lib\net40\AlphaFS.dll -PassThru
$alphaFS | where IsPublic | select Name, FullName
$alphaFS | where IsPublic | select Name, FullName | where Name -like *Directory*
[Alphaleonis.Win32.Filesystem.Directory] | Get-Member -Static
[Alphaleonis.Win32.Filesystem.Directory]::CreateDirectory
#let's try it again
1..60 | foreach {$folderTree = 'c:\'} {$folderTree += "test$_\"}
[Alphaleonis.Win32.Filesystem.Directory]::CreateDirectory($folderTree)
#worked!
#delete the folder tree recursively
[Alphaleonis.Win32.Filesystem.Directory]::Delete($folderTree, $true)
[/code]
The library has support for many other useful features like:



	
  * Creation of Hardlinks

        
  * Accessing hidden volumes

        
  * Transactional file operations (similar to the registry provider in PowerShell)

        
  * Copying and moving files with progress indicator

        
  * NTFS Alternate Data Streams

        
  * Accessing network resources (SMB/DFS)


The full documentation for AlphaFS can be found [here](http://alphafs.alphaleonis.com/doc/2.0/index.html).
Update: Recently I also came across the [PowerShell usage wiki on the project's GitHub page](https://github.com/alphaleonis/AlphaFS/wiki/PowerShell).

![shareThoughts](https://powershellone.files.wordpress.com/2015/10/sharethoughts.jpg)


* * *


Photo Credit: [ekarbig](https://www.flickr.com/photos/93103687@N07/16686561952/) via [Compfight](http://compfight.com) [cc](https://creativecommons.org/licenses/by-nc-nd/2.0/)
