---
author: dirkbremen
comments: true
date: 2015-09-25 17:29:57+00:00
layout: post
link: https://powershellone.wordpress.com/2015/09/25/using-microsoft-synctoy-through-powershell/
slug: using-microsoft-synctoy-through-powershell
title: Using Microsoft SyncToy through PowerShell
wordpress_id: 568
categories:
- PowerShell
tags:
- Sync
---

![4745206997_ac577b3248_m](https://powershellone.files.wordpress.com/2015/09/4745206997_ac577b3248_m.jpg)
This post is about running [Microsoft SyncToy](http://www.microsoft.com/en-us/download/details.aspx?id=15155) via PowerShell. For those that don't know SyncToy: 


<blockquote>SyncToy 2.1 is a free application that synchronizes files and folders between locations. Typical uses include sharing files, such as photos, with other computers and creating backup copies of files and folders. </blockquote>


SyncToy has been around already since good old Windows XP times and even though there are alternative freeware applications it's still one of my favorite tools for the job.
While SyncToy already comes with a commandline version out of the box, it's lacking quite some features as compared to the graphical user interface:



        
  * No option to preview the sync operation

	
  * No progress indication

	
  * No option to exclude subfolders

	
  * No option to exclude files by attributes (e.g. hidden, system)

	
  * No option to specify recursion

	
  * No option to specify action for overwritten files


Googling around for solutions I came across two related posts on codeproject.com:

	
  * [Quietly run Microsoft's SyncToy](http://www.codeproject.com/Articles/16112/Quietly-run-Microsoft-s-SyncToy)

	
  * [Run Microsoft SyncToy from a Console Application](http://www.codeproject.com/Articles/16269/Run-Microsoft-SyncToy-from-a-Console-Application)


Following translating the suggest approach to PowerShell it seemed to be quite easy to accomplish what I wanted utilizing the SyncToyEngine.dll .NET assembly that comes with the SyncToy installation. Considering that I would have setup already a folder pairing called 'Test' using the GUI, the following code should initiate the sync operation (it's important to use the correct version of PowerShell to test this (i.e. SyncToy(x64) needs to be run via PowerShell x64):
[code language="powershell"]
$syncToyEnginePath = Resolve-Path 'c:\Program Files*\SyncToy 2.1\SyncToyEngine.dll'
#load the dll
Add-Type -Path $syncToyEnginePath

#retrieve the sync engine configuration
$syncToyEngineConfigPath = "$env:LOCALAPPDATA\Microsoft\SyncToy\2.0\SyncToyDirPairs.bin"
$bf = New-Object Runtime.Serialization.Formatters.Binary.BinaryFormatter 
$sr = New-Object IO.StreamReader($syncToyEngineConfigPath)
do{
    $seConfig = [SyncToy.SyncEngineConfig]$bf.Deserialize($sr.BaseStream)
    if ($seConfig.Name -eq 'Test'){
        $engineConfig = $seConfig
        break
    }
}
while($sr.BaseStream.Position -lt $sr.BaseStream.Length)
$sr.Close()
$sr.Dispose()

#invoke the sync
$syncEngine = New-Object SyncToy.SyncEngine($engineConfig)
$syncEngine.Sync()
[/code]
But unfortunately the last line causes PowerShell to hang. After multiple unsuccessful attempts to work around this (also implementing the same as a C# PowerShell cmdlet). I ended up writing a C# executable that only takes care of the synchronization and preview part, since I wanted to keep as much as possible of the code in PowerShell. The end result is a PowerShell module 'SyncToy.psm1' providing three functions:
<table >
<tr >NameDescription
<tr >
<td style="border:1px solid black;padding:3px;" >Get-SyncConfig
</td>
<td style="border:1px solid black;padding:3px;" >To retrieve an existing sync configuration (FolderPair) either setup via Set-SyncConfig or GUI
</td></tr>
<tr >
<td style="border:1px solid black;padding:3px;" >Set-SyncConfig
</td>
<td style="border:1px solid black;padding:3px;" >To configure a new Sync Configuration (FolderPair). Those can be stored into the default configuration that the GUI uses (default behaviour) or into a custom path
</td></tr>
<tr >
<td style="border:1px solid black;padding:3px;" >Invoke-Sync
</td>
<td style="border:1px solid black;padding:3px;" >To preview a  sync operation or to run the actual sync operation showing results and a progress bar
</td></tr>
</table>
Let's have a look at an example usage. Setting up two folders and a sync between the two. The below code is part of the module (Test-SyncToy), and can be downloaded via [GitHub](https://github.com/DBremen/SyncToy):
[code language="powershell"]
#Import the module
Import-Module $PSScriptRoot\SyncToy.psm1
#create folders for testing
#leftDir containing some content
$leftDir = "$env:TEMP\Left"
mkdir $leftDir | Out-Null
foreach ($num in 1..30){
    mkdir "$leftDir\test$num" | Out-Null
    foreach ($num2 in 1..10){
        $extension = '.txt'
        if ($num2 % 2){
            $extension = '.ps1'
        }
        "Test $num2" | Set-Content -Path ("$leftDir\test$num\test$num2" + $extension)
    }
}
#rightDir as the initial destination
$rightDir = "$env:TEMP\Right"
mkdir $rightDir | Out-Null

#exclude test10-test29 sub-folders from sync
$excludeFolders = (dir "$leftDir\test[1-2][0-9]" -Directory).FullName 

#setup the sync configuration
Set-SyncConfig -folderPairName 'Test' -leftDir $leftDir -rightDir $rightDir -syncMode Synchronize `
    -includedFilesPattern '*.ps1' -excludedSubFolders $excludeFolders 

#preview the sync
$previewResults = Invoke-Sync -folderPairName 'Test' -previewOnly
$previewResults
$previewResults.Action
#run the snyc
$results = Invoke-Sync -folderPairName 'Test' 
$results
[/code]

Please let me know if you have any further suggestions, questions or comments about the module. 
![shareThoughts](https://powershellone.files.wordpress.com/2015/10/sharethoughts.jpg)


* * *


Photo Credit: [Tatters ❀](https://www.flickr.com/photos/62938898@N00/4745206997/) via [Compfight](http://compfight.com) [cc](https://creativecommons.org/licenses/by-nc-nd/2.0/)
