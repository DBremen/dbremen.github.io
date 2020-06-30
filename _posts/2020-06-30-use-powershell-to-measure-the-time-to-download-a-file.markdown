---
author: dirkbremen
comments: true
date: 2015-02-25 22:58:33+00:00
layout: post
link: https://powershellone.wordpress.com/2015/02/25/use-powershell-to-measure-the-time-to-download-a-file/
slug: use-powershell-to-measure-the-time-to-download-a-file
title: Use PowerShell to measure the time to download a file
wordpress_id: 76
categories:
- PowerShell
tags:
- measure download
---

[![tree 7](https://powershellone.files.wordpress.com/2015/02/2992344975_38ec551cf8_m.jpg)](https://powershellone.files.wordpress.com/2015/02/2992344975_38ec551cf8_m.jpg)

It is actually surprisingly easy to measure how long it takes to download a file with PowerShell. Let's look at an example: My internet speed is according to [speedtest.net](http://www.speedtest.net/) around 4.2 Mbps (megabits/second). If I would like to know how long it takes me to download a file of 1GB I can use a simple one liner:
[code language="powershell"]
[TimeSpan]::FromSeconds(1GB/(4.2/8*1MB))
[/code]
How does that actually work? 



	
  1. Divide the size of the files in bytes (1GB/)

	
  2. by the download speed/second in bytes (*1MB). First converting Mb into MB (4.2/8)

	
  3. The results is the time it takes to download the specified size in decimal seconds

        
  4. The result is used to create a new TimeSpan object (around 32 minutes to download 1GB on my PC)


It doesn't take much more effort to turn this into a re-usable function:
[code language="powershell"]
function Get-DownloadTime($SizeInBytes,$SpeedInMbps,[switch]$AsTimeSpan){
    $ts = [TimeSpan]::FromSeconds($SizeInBytes/($SpeedInMbps/8*1MB))
    if ($AsTimeSpan){
        $ts
    }
    else{
        $ts.ToString('hh\:mm\:ss')
    }
}
#usage
Get-DownloadTime 1GB 4.2
Get-DownloadTime 1GB 4.2 -AsTimeSpan
[/code]
The function takes the size in bytes and the speed in Mbps and returns by default the time in the format "hh:mm:ss" or the TimeSpan object when used with the -AsTimeSpan switch. More details on the TimeSpan format specifiers can be found [here](https://msdn.microsoft.com/en-us/library/ee372287.aspx?f=255&MSPPError=-2147217396).

![shareThoughts](https://powershellone.files.wordpress.com/2015/10/sharethoughts.jpg)


* * *


photo credit: [Pine Forest Colorful Tree](http://www.flickr.com/photos/10159247@N04/2992344975) via [photopin](http://photopin.com) [(license)](https://creativecommons.org/licenses/by-nc-nd/2.0/)
