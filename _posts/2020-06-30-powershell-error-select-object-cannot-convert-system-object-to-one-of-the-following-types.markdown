---
author: dirkbremen
comments: true
date: 2015-08-18 09:57:59+00:00
layout: post
link: https://powershellone.wordpress.com/2015/08/18/powershell-error-select-object-cannot-convert-system-object-to-one-of-the-following-types/
slug: powershell-error-select-object-cannot-convert-system-object-to-one-of-the-following-types
title: 'PowerShell Error - "Select-Object : Cannot convert System.Object[] to one
  of the following types..."'
wordpress_id: 384
categories:
- PowerShell
tags:
- error
---

![tree](https://powershellone.files.wordpress.com/2015/08/427968871_092dfdf8ff_m.jpg)

I came across a bug (at least I would assume this a bug) in PowerShell while using the Select-Object (alias select) cmdlet in conjunction with a mix of literal and variable arguments for the Property parameter (attempting to use [Get-ChangeLog](https://powershellone.wordpress.com/2015/06/30/comparing-two-objects-or-csv-files-column-by-column/) with a multiple column identifier). Select-Object's Property parameter accepts either an array of objects, or a hashtable of name/expression pairs as arguments. Let's look at an example:
[code language="powershell"]
Get-Help select -Parameter Property
#usage with literal argument
Get-Process | select Name, ID, Handle, VM, PM
#usage with a variable argument
$props = "Name", "ID", "Handle"
Get-Process | select $props
#mixed usage of literal and a variable argument
Get-Process | select $props, VM, PM
[/code]

The last command results into the following error message:
![select_Error](https://powershellone.files.wordpress.com/2015/08/select_error.png)
Even if we change the literal values to strings and put the arguments in parentheses Select-Object still refuses to accept it:
[code language="powershell"]
$props = "Name", "ID", "Handle"
#check the type of the parameter value
($props, "VM", "PM").GetType().FullName
#should work, but still doesn't
Get-Process | select ($props, "VM", "PM")
[/code]
I found two possible workarounds. 



	
  1. Concatenation of the values

	
  2. Using Write-Output (alias echo) to produce an array of strings (I like that one more)


See also [PowerShell tricks- Build an array of strings without quotation marks](https://powershellone.wordpress.com/2015/08/03/powershell-tricks-build-an-array-of-strings-without-quotation-marks/)
[code language="powershell"]
#concatenate
$props = echo Name ID Handle
Get-Process | select ($props + "VM" + "PM")
#using echo
Get-Process | select (echo $props VM PM)
[/code]

![shareThoughts](https://powershellone.files.wordpress.com/2015/10/sharethoughts.jpg)


* * *


Photo Credit: [S.Raj](https://www.flickr.com/photos/91769296@N00/427968871/) via [Compfight](http://compfight.com) [cc](https://creativecommons.org/licenses/by-nc-nd/2.0/)
