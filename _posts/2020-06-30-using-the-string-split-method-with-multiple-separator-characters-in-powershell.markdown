---
author: dirkbremen
comments: true
date: 2015-09-17 09:42:12+00:00
layout: post
link: https://powershellone.wordpress.com/2015/09/17/using-the-string-split-method-with-multiple-separator-characters-in-powershell/
slug: using-the-string-split-method-with-multiple-separator-characters-in-powershell
title: Using the String.Split method with multiple separator characters in PowerShell
wordpress_id: 550
categories:
- PowerShell
---

![15703896368_bfc55bdd19_m](https://powershellone.files.wordpress.com/2015/09/15703896368_bfc55bdd19_m.jpg)
This post is about what I thought of an odd behaviour when calling the .NET [String.Split method](https://msdn.microsoft.com/en-us/library/b873y76a%28v=vs.110%29.aspx) with multiple separator characters from PowerShell. I first came across this myself but didn't really pay much attention to it. Only after reading about it again over on [Tommy Maynard's blog](http://tommymaynard.com/ql-using-replace-to-fix-split-and-convert-path-20141021/), I decided to find out more.
Let's have a look at an example first:
[code language="powershell"]
#using String.Split with one separator character works as expected
'This is a test'.Split('e')
#using multiple characters not so much
'c:\\test'.Split('\\')
'c:\\test'.Split('\\').Count
[/code]
When running the second example trying to split a string based on double backslashes the result is an array of 3 strings instead of two. Let's try to see why this is happening by retrieving the specific overload definition we are using:
[code language="powershell"]
#get the overload definition of the method we are using
''.Split.OverloadDefinitions[0]
#string[] Split(Params char[] separator)
[/code]
Ok, it looks like this overload of the Split method expects a character array for the separator parameter. That is why we saw an additional split, every character of the string argument '\\' is considered as a unique separator. Let's see if String.Split has other overload definitions that accept a String as the separator argument:
[code language="powershell"]
''.Split.OverloadDefinitions | Select-String 'string[] separator' -SimpleMatch
<#
string[] Split(string[] separator, System.StringSplitOptions options)
string[] Split(string[] separator, int count, System.StringSplitOptions options)
#>
[/code]
Indeed, there are two overloads that accept a String array argument instead. Let's use the first one. We don't need the [StringSplitOptions](https://msdn.microsoft.com/en-us/library/system.stringsplitoptions%28v=vs.110%29.aspx) parameter in this case and can therefore use a value of 'None' for the argument.
[code language="powershell"]
#this doesn't work since we need a String array
 'c:\\test'.Split('\\', 'None')
#finally we get only two parts back
 'c:\\test'.Split(@('\\'), 'None')
'c:\\test'.Split(@('\\'), 'None').Count
[/code]
We could have used the [-split operator](https://technet.microsoft.com/en-us/library/hh847811.aspx) in the first place, but that would have been to easy, right ;-). Furthermore with the String.Split method we can also split a string by multiple strings in just one go:
[code language="powershell"]
#using -split operator we need to escape the \ by doubling them since we are dealing with regular expressions
'c:\\test' -split '\\\\'
#splitting by two strings
'split by xx and yy in one go'.Split(('xx','yy'),'None')
#can be done also with -split using a scriptBlock

[/code]
In conclusion, PowerShell provides a lot of options when  it comes to splitting strings. Only looking at the separator parameter we have five options:



	
  1. Using String.Split's first overload with a character array

	
  2. Using one of String.Split's overloads that accept a string array

	
  3. Using the -split operator which accepts a string for the separator parameter (the string is actually interpreted as a regular expression)

	
  4. Using the -split operator which also accepts a ScriptBlock to determine the split operation. With that one can do a lot of things within the ScriptBlock $_ represents the current character, $args[0] the entire string, and $args[1] the current position within the entire string

	
  5. Finally there is also the [.NET Regex.Split method](https://msdn.microsoft.com/en-us/library/system.text.regularexpressions.regex.split%28v=vs.110%29.aspx) with even more options but very similar to the -split operator



![shareThoughts](https://powershellone.files.wordpress.com/2015/10/sharethoughts.jpg)


* * *


Photo Credit: [Matiluba](https://www.flickr.com/photos/42040591@N05/15703896368/) via [Compfight](http://compfight.com) [cc](https://creativecommons.org/licenses/by-nc-nd/2.0/)
