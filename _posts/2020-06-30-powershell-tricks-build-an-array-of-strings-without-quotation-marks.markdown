---
author: dirkbremen
comments: true
date: 2015-08-03 10:49:38+00:00
layout: post
link: https://powershellone.wordpress.com/2015/08/03/powershell-tricks-build-an-array-of-strings-without-quotation-marks/
slug: powershell-tricks-build-an-array-of-strings-without-quotation-marks
title: PowerShell tricks - Build an array of strings without quotation marks
wordpress_id: 286
categories:
- PowerShell
tags:
- tricks
---

![tree](https://powershellone.files.wordpress.com/2015/07/15648707286_9368aa0c70_m.jpg)
This is one of the tricks I keep forgetting about and therefore document it here for myself but also in case someone else might find it useful. 
In order to create an array of strings one usually does something like this:
[code language="powershell" light="true"]
$stringArray = "first", "second", "third", "fourth"
[/code]
It involves quite some redundant characters in order to do a simple thing. This can be made easier using a simple function that is part of the excellent [PowerShell Communicty Extensions](https://pscx.codeplex.com/). The QL (QL is short for Quote-List an idea borrowed from Perl) function has the following definition:
[code language="powershell"]
function ql {$args}
ql first second third fourth
[/code]
Note that extraneous commas and quotation marks can be avoided using this approach. There is actually even a built-in cmdlet that can be used for the same purpose. Write-Output alias echo or write:
[code language="powershell" light="true"]
echo first second third fourth
[/code]
If an element of the string array we'd like to create contains a space the element needs to be surrounded in quotes:
[code language="powershell" light="true"]
echo first second third fourth "with space"
[/code]
As a bonus tip we can use a similar idea as for the ql function in order to create strings without having to limit them by quotation marks:
[code language="powershell"]
function qs {"$args"}
qs this is a long string without any quotes
#only gotcha is when using quotes (single or double) within the argument
#qs this does not' work
qs quotes require escaping using a `'backtick`' otherwise it will not work
[/code]

![shareThoughts](https://powershellone.files.wordpress.com/2015/10/sharethoughts.jpg)


* * *


Photo Credit: [bjimmy934](https://www.flickr.com/photos/96828128@N02/15648707286/) via [Compfight](http://compfight.com) [cc](https://creativecommons.org/licenses/by/2.0/)
