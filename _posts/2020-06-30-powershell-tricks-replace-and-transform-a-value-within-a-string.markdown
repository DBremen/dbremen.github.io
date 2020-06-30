---
author: dirkbremen
comments: true
date: 2015-08-19 12:52:55+00:00
layout: post
link: https://powershellone.wordpress.com/2015/08/19/powershell-tricks-replace-and-transform-a-value-within-a-string/
slug: powershell-tricks-replace-and-transform-a-value-within-a-string
title: PowerShell tricks - replace and transform a value within a string
wordpress_id: 397
categories:
- PowerShell
tags:
- tricks
---

![tree](https://powershellone.files.wordpress.com/2015/08/4979054716_6954959afa_m.jpg)

Most PowerShell users know already of the [String.Replace](https://msdn.microsoft.com/en-us/library/system.string.replace%28v=vs.110%29.aspx) method and the [PowerShell -replace operator](https://technet.microsoft.com/en-us/library/hh847759.aspx). While the latter is quite powerful with its support for regular expressions ... :
[code language="powershell"]
#using string's replace method
'this is good'.Replace('good','quite good')
#using PowerShell's replace operator to remove duplicate words
'this this is a a test' -replace '\b(\w+)(\s+\1){1,}\b', '$1'
[/code]
... there is an even more powerful option available for cases where the characters that we want to replace need to be "transformed" in some way. Let's look two examples:



	
  1. Increase a number within a string by one e.g. 'XX33.txt' should turn into 'XX34.txt'

	
  2. Capitalize the second word within a sentence string e.g. 'this is a test' should turn into 'this IS a test'


For the two examples there are of course multiple ways to accomplish this using PowerShell without involving regex replace, but there might be situations where it is your only option. For those case the .net [Regex.Replace method](https://msdn.microsoft.com/en-us/library/system.text.regularexpressions.regex.replace%28v=vs.110%29.aspx) could become your new best friend. The method provides an overload that takes the following three arguments:
<table style="border:1px solid black;" >
  <tr >ParameterDescription</tr>
  <tr >
<td style="border:1px solid black;padding:3px;" >Input string
</td>
<td style="border:1px solid black;padding:3px;" >Text that contains the character(s) to be replaced
</td>
  <tr >
<td style="border:1px solid black;padding:3px;" >Pattern string
</td>
<td style="border:1px solid black;padding:3px;" >The regex pattern that identifies the character(s) to be replaced
</td>
  <tr >
<td style="border:1px solid black;padding:3px;" >MatchEvaluator
</td>
<td style="border:1px solid black;padding:3px;" >A scriptBlock that is being evaluated against the captured matched characters
</td>
</table>
The 3rd argument (MatchEvaluator) is the key to the solution as the scriptBlock automatically receives the captured characters as an argument it can be used to transform the match(es) using any method available. Let's use the same to solve the two example problems:
https://gist.github.com/d137f3d96d69b53700a8
The automatic $args[0] variable can be used to access the match(es) within the scriptBlock. Note that for the second example the ToUpper method is called on the Value property rather than the $args[0] variable directly. Furthermore the $counter variable needs to be declared in script scope (see also [PowerShell scope write-up](https://powershellone.wordpress.com/2015/02/22/powershell-scope-write-up/)) in order to be visible within the scriptBlock for PowerShell version 3 or later.

![shareThoughts](https://powershellone.files.wordpress.com/2015/10/sharethoughts.jpg)


* * *


Photo Credit: [Indy Kethdy](https://www.flickr.com/photos/9284496@N07/4979054716/) via [Compfight](http://compfight.com) [cc](https://creativecommons.org/licenses/by-nc-sa/2.0/)
