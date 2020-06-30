---
author: dirkbremen
comments: true
date: 2015-02-24 22:36:54+00:00
layout: post
link: https://powershellone.wordpress.com/2015/02/24/please-wait-while-windows-configures-microsoft-visual-studio-when-starting-excel/
slug: please-wait-while-windows-configures-microsoft-visual-studio-when-starting-excel
title: '"Please wait while windows configures Microsoft Visual Studio..." when  starting
  Excel'
wordpress_id: 64
categories:
- Excel
tags:
- error
---

[![tree6](https://powershellone.files.wordpress.com/2015/02/343236262_528203e659_m.jpg)](https://powershellone.files.wordpress.com/2015/02/343236262_528203e659_m.jpg)

I got this dialog ("Please wait while windows configures Microsoft Visual Studio Professional 2013") on every Excel (2010) start up shortly after I had installed Visual Studio 2013 Community Edition. In my case it delayed the Excel start-up for several minutes. In order to get rid of the quite annoying dialog I just created a new directory under C:\WINDOWS\Microsoft.NET\Framework\URTInstallPath_GAC. To do so just run the command below from an elevated command- or PowerShell prompt:

[code language="powershell" light="true"]
mkdir C:\WINDOWS\Microsoft.NET\Framework\URTInstallPath_GAC
[/code]



* * *


photo credit: [Mañana... - Tomorrow...](http://www.flickr.com/photos/36024934@N00/343236262) via [photopin](http://photopin.com) [(license)](https://creativecommons.org/licenses/by-nc-sa/2.0/)
