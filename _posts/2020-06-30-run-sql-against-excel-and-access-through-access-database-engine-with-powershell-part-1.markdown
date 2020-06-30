---
author: dirkbremen
comments: true
date: 2015-07-15 10:56:22+00:00
layout: post
link: https://powershellone.wordpress.com/2015/07/15/run-sql-against-excel-and-access-through-access-database-engine-with-powershell-part-1/
slug: run-sql-against-excel-and-access-through-access-database-engine-with-powershell-part-1
title: Run SQL against Excel and Access through Access Database Engine with PowerShell
  - Part 1
wordpress_id: 210
categories:
- PowerShell
tags:
- query
---

[![tree](https://powershellone.files.wordpress.com/2015/07/4323020112_9856646876_m.jpg)](https://powershellone.files.wordpress.com/2015/07/4323020112_9856646876_m.jpg)
This is part 1 of a series of blog posts around using SQL against Excel and Access through ACE drivers (Access database engine) with PowerShell. 
Part 1 is about introduction and getting up and running.

PowerShell has already some built-in support to slice and dice data via the select, where, and group cmdlets. If it comes to bigger data-sets and join operations though, it lacks performance and features. 
Many of us (including me) have data sitting in either Excel or Access files rather than SQL server or similar more scalable DBMSs.
In case of Excel converting the file to .csv and subsequently pulling the data in using Import-CSV is of course a valid option for several use cases. On the other hand there is another (better) way that doesn't require any conversion and enables reading and writing the data directly into Excel.
First we'll need to download and install the [Microsoft Access Database Engine 2010 Redistributable](https://www.microsoft.com/en-us/download/details.aspx?id=13255). The name is a bit misleading as this is a replacement of the older Jet and OLEDB drivers which can be used for older and newer Excel and Access files. The download offers a 32 and a 64 bit version where the bit size corresponds to the respective bit size of the used office version. In order to avoid the nitty gritty details and focus on the task I have created a module that is a modified and extended version of the [ACE module Chad Miller created](https://gallery.technet.microsoft.com/office/af687d99-5611-4097-97e4-691fda84ad42). Let's download the module to into the user's module path.
[code language="powershell"]
$folderPath = Join-Path -Path ([Environment]::GetFolderPath('MyDocuments')) -ChildPath WindowsPowerShell\Modules\ACE
mkdir $folderPath
$url = 'https://raw.githubusercontent.com/DBremen/PowerShellScripts/master/functions/ACE.psm1'
Invoke-WebRequest $url -OutFile "$folderPath\ACE.psm1"
[/code]
This is everything needed to get started. See you hopefully in the next part to dive into some example queries.

![shareThoughts](https://powershellone.files.wordpress.com/2015/10/sharethoughts.jpg)


* * *


Photo Credit: [Fountain_Head](https://www.flickr.com/photos/37626043@N00/4323020112/) via [Compfight](http://compfight.com) [cc](https://creativecommons.org/licenses/by/2.0/)
