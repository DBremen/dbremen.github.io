---
author: dirkbremen
comments: true
date: 2015-02-28 22:14:28+00:00
layout: post
link: https://powershellone.wordpress.com/2015/02/28/using-everything-search-command-line-es-exe-via-powershell/
slug: using-everything-search-command-line-es-exe-via-powershell
title: Using Everything search command line (es.exe) via PowerShell
wordpress_id: 96
categories:
- PowerShell
tags:
- search
---

[![tree8](https://powershellone.files.wordpress.com/2015/02/5314943918_fe24c7f933_m.jpg)](https://powershellone.files.wordpress.com/2015/02/5314943918_fe24c7f933_m.jpg)

[Everything](http://voidtools.com/) by voidtools is a great search utility for Windows. It returns almost instantaneous results for file and folder searches by utilizing the Master File Table(s). There is also a command-line version of everything ([es.exe](http://www.voidtools.com/es.zip)) and this post is about a wrapper I wrote in PowerShell around es.exe.
The full version including full help (which I'm skipping here to keep it shorter) can be downloaded from my [GitHub repository](https://github.com/DirkBremen/PowerShellScripts/blob/master/functions/Get-ESSearchResult.ps1)
[code language="powershell"]
function Get-ESSearchResult {
    [CmdletBinding()]
    [Alias("search")]
    Param
    (
        #searchterm
        [Parameter(Mandatory=$true, Position=0)]
        $SearchTerm,
        #openitem
        [switch]$OpenItem,
        [switch]$CopyFullPath,
        [switch]$OpenFolder,
        [switch]$AsObject
    )
    $esPath = 'C:\Program Files*\es\es.exe'
    if (!(Test-Path (Resolve-Path $esPath).Path)){
        Write-Warning "Everything commandline es.exe could not be found on the system please download and install via http://www.voidtools.com/es.zip"
        exit
    }
	$result = & (Resolve-Path $esPath).Path $SearchTerm
    if($result.Count -gt 1){
        $result = $result | Out-GridView -PassThru
    }
    foreach($record in $result){
        switch ($PSBoundParameters){
	        { $_.ContainsKey("CopyFullPath") } { $record | clip }
	        { $_.ContainsKey("OpenItem") }     { if (Test-Path $record -PathType Leaf) {  & "$record" } }
	        { $_.ContainsKey("OpenFolder") }   {  & "explorer.exe" /select,"$(Split-Path $record)" }
	        { $_.ContainsKey("AsObject") }     { $record | Get-ItemProperty }
	        default                            { $record | Get-ItemProperty | 
                                                    select Name,DirectoryName,@{Name="Size";Expression={$_.Length | Get-FileSize }},LastWriteTime
                                               }
        }
    }
}
[/code]
The function contains a call to "Get-FileSize" a helper filter in order to return the file size of the selected items in proper format:
[code language="powershell"]
filter Get-FileSize {
	"{0:N2} {1}" -f $(
	if ($_ -lt 1kb) { $_, 'Bytes' }
	elseif ($_ -lt 1mb) { ($_/1kb), 'KB' }
	elseif ($_ -lt 1gb) { ($_/1mb), 'MB' }
	elseif ($_ -lt 1tb) { ($_/1gb), 'GB' }
	elseif ($_ -lt 1pb) { ($_/1tb), 'TB' }
	else { ($_/1pb), 'PB' }
	)
}
[/code]

How does it work? The Get-ESSearchResult function (alias search) searches for all items containing the search term (SearchTerm parameter is the only mandatory parameter). The search results (if multiple) are piped to Out-GridView with the -PassThru option enabled so that the result can be seen in GUI and one or multiple items from within the search results can be selected. By default (no switches turned on) the selected item(s) are converted to FileSystemInfo objects and their Name, DirectoryName, FileSize and LastModifiedDate are output. The resulting objects can be used for further processing (copying, deleting....).

The switch Parameters add the following features and can be used in any combination:



	
  * -OpenItem : Invoke the selected item(s) (only applies to files not folders)

	
  * -CopyFullPath : Copy the full Path of the selected item to the clipboard

	
  * -OpenFolder : Opens the folder(s) that contain(s) the selected item(s) in windows explorer

	
  * -AsObject : Similar to default output but the full FileSystemInfo objects related to the selected item(s) are output


I hope that the function can also help some of you to find your files and folders faster from the commandline.
I've written another blog post in relation to Everything and PowerShell:
[Search fiel content by keyword using Everyting + PowerShell + GUI](https://powershellone.wordpress.com/2015/08/11/search-file-content-by-keyword-using-everything-powershell-gui/)

![shareThoughts](https://powershellone.files.wordpress.com/2015/10/sharethoughts.jpg)


* * *


photo credit: [983 Foggy Day](http://www.flickr.com/photos/33083406@N02/5314943918) via [photopin](http://photopin.com) [(license)](https://creativecommons.org/licenses/by-nc-nd/2.0/)
