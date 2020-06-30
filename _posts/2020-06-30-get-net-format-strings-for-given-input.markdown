---
author: dirkbremen
comments: true
date: 2018-07-19 15:20:01+00:00
layout: post
link: https://powershellone.wordpress.com/2018/07/19/get-net-format-strings-for-given-input/
slug: get-net-format-strings-for-given-input
title: Get .net Format Strings for given input
wordpress_id: 1168
categories:
- PowerShell
---

![2364129390_4fe946df4a_m](https://powershellone.files.wordpress.com/2015/11/2364129390_4fe946df4a_m.jpg)
Yet again, long time no post!
.net Format Strings are very useful when it comes to taking control over the output of your scripts. e.g.: 
[code language="powershell"]
'{0:t}' -f (Get-Date)
#output: h:mm tt
'{0:n1}' -f 2.45
#output: 2.5
[/code]
The problem with those Format Strings is, that hardly anyone can remember them. While there they are thoroughly [documented](https://docs.microsoft.com/en-us/dotnet/standard/base-types/formatting-types) and several nice folks have created cheat-sheets (e.g. [here](http://www.cheat-sheets.org/saved-copy/msnet-formatting-strings.pdf)), I thought it would be nice to be able to get (at least the most common) Format Strings for a given input automatically along with the respective outputs within PowerShell.
![Get-FormatStringOutput](https://powershellone.files.wordpress.com/2018/07/get-formatstringoutput.png)
The function returns output for Integer, Double, and DateTime input. You can download Get-FormatStrings from my GithHub [repository](https://github.com/DBremen/PowerShellScripts) or just grab the code below:
https://gist.github.com/25ec562a8bb21b1899044ca7913ae7ef

![shareThoughts](https://powershellone.files.wordpress.com/2015/10/sharethoughts.jpg)



* * *



Photo Credit: [sharkbait](https://www.flickr.com/photos/61417564@N00/2364129390/) via [Compfight](http://compfight.com) [cc](https://creativecommons.org/licenses/by-nc-sa/2.0/)
