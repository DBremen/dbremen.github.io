---
author: dirkbremen
comments: true
date: 2016-05-26 08:41:05+00:00
layout: post
link: https://powershellone.wordpress.com/2016/05/26/full-text-search-using-powershell-everything-and-lucene/
slug: full-text-search-using-powershell-everything-and-lucene
title: Full text search using PowerShell, Everything, and Lucene
wordpress_id: 1136
categories:
- PowerShell
tags:
- search
---

![26803605966_33613e76a6_m](https://powershellone.files.wordpress.com/2016/05/26803605966_33613e76a6_m.jpg)
Searching for files is something everyone does on a very regular basis. While Windows is consistently changing the way this is done with every new operating system, the built-in functionality is still far from being sufficient. Therefore, I'm always looking for methods on how to improve this (you can also find several blog posts in relation to file searches around here). In regards to searching for files based on file names or paths, I'm pretty happy with the performance of [Everything](https://www.voidtools.com/). If it is about searching for files based on their content (aka full-text search), there is still room for improvement in my opinion. 
Recently I've been watching the [session recordings from the PowerShell Conference Europe 2016](https://youtu.be/VRL4TW2FJAI?list=PLDCEho7foSoruQ-gL5GJw-lRkASPJOukl) (I can highly recommend anyone that is interested in PowerShell to watch those). 

In one of the videos, Bruce Payette talks about [how to use Lucene.net through PowerShell](https://www.youtube.com/watch?v=WOEmlc3tkTU&index=58&list=PLDCEho7foSoruQ-gL5GJw-lRkASPJOukl), subsequently [Doug Finke](https://github.com/dfinke/PoShLucene) has also picked up the topic and wrapped all of it into a GUI. [Lucene](https://lucene.apache.org/) is basically the gold standard when it comes to full-text search.

Naturally I also wanted to see how Lucene could help to improve the Windows search capabilities further. My goal was to put it to a test and potentially further improve the implementations in order to be able to index and query text based files on my entire drive. 
Using Bruce's and Doug's implementation, the search worked almost instantaneous even against a huge volume of files to be indexed. Only the creation of the index takes quite some time since the enumeration of the files to be indexed is based on either Get-ChildItem or [System.IO.Directory.EnumerateFiles](https://msdn.microsoft.com/en-us/library/system.io.directory.enumeratefiles%28v=vs.110%29.aspx). 

I've refactored the implementation into a new module ([SearchLucene.psm1](https://github.com/DBremen/SearchLucene)) where I based the file enumeration on the [Everything command-line interface](https://www.voidtools.com/support/everything/command_line_interface/) and made several additional changes. As a result, the creation of the index for my c: drive (SSD) for all .txt, .ps1, and .psm1 files takes now less than a minute. 
Usage:
Prerequesites:




  * SearchLucene.psm1 module installed (The example considers, that you have put the downloaded files into a folder called 'SearchLucene', that resides within one of $env:PSModulePath folders


  * Everything command-line interface installed (Requires the GUI version to be installed)


[code language="powershell"]
Import-Module SearchLucene
#Create the index on disk within the $env:TEMP\test folder. And index all ps1, and psm1 files for the c: drive
<#
default values for each parameter are:
- DirectoryToBeIndexed = 'c:\',
- Include = @('*.ps1','*.psm1','*.txt*')
- IndexDirectory = "$env:temp\luceneIndex"
#>
New-LuceneIndex -DirectoryToBeIndexed 'c:\' -Include @('*.ps1','*.psm1') -IndexDirectory "$env:TEMP\test"

#Search all indexed .ps1 files for the word 'kw2016'
Find-FileLucene 'kw2016' -Include '.ps1'
#outputs a list of file paths that include the word test

#Search all indexed .ps1 files for the word 'test' and output the matching line and line number for each match found within the file
Find-FileLucene 'test' -Include '.ps1' -Detailed

#Same as above but output the result in a table grouped by folder
Find-FileLucene 'kw2016' -Include '.ps1' -Detailed | 
	Sort-Object {Split-Path $_.Path} | 
	Format-Table -GroupBy {Split-Path $_.Path}
[/code] 
![SearchLucene](https://powershellone.files.wordpress.com/2016/05/searchlucene.png)
This is just a small example on how Lucene.net can be used to implement full-text search. The solution could be further improved by including other file types, re-creating or updating the index based on a schedule or triggered by file modifications.



![shareThoughts](https://powershellone.files.wordpress.com/2015/10/sharethoughts.jpg)



* * *




Photo Credit: [Cho Shane](https://www.flickr.com/photos/136261520@N07/26803605966/) via [Compfight](http://compfight.com) [cc](https://creativecommons.org/licenses/by/2.0/)
