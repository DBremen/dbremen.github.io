---
author: dirkbremen
comments: true
date: 2015-11-02 16:34:48+00:00
layout: post
link: https://powershellone.wordpress.com/2015/11/02/simplified-where-object-for-multiple-conditions-on-the-same-property-for-powershell/
slug: simplified-where-object-for-multiple-conditions-on-the-same-property-for-powershell
title: Simplified Where-Object for multiple conditions on the same property for PowerShell?
wordpress_id: 859
categories:
- PowerShell
tags:
- AST
---

[![3107494832_60009ec22b_m](https://powershellone.files.wordpress.com/2015/10/3107494832_60009ec22b_m.jpg)](https://powershellone.files.wordpress.com/2015/10/3107494832_60009ec22b_m.jpg)
While PowerShell version 3 already introduced a (quite controversial) [simplified syntax](https://rkeithhill.wordpress.com/2011/10/19/windows-powershell-version-3-simplified-syntax/) for the [Where-Object cmdlet](https://technet.microsoft.com/en-us/library/hh849715.aspx) (alias where). It still doesn't account for a quite common error PowerShell beginners encounter when using where with multiple conditions on the same property. As an example let's say we would like to filter the range 1-10 to get only those numbers that are between 6 and 7. I've seen many people (yes that includes me) attempting to do it like below since it seems a logical translation of 'where x is greater than 5 and lower than 8'.:
[code language="powershell"]
1..10 | where {$_ -gt 5 -and -lt 8}
#correct version
1..10 | where {$_ -gt 5 -and $_ -lt 8}
[/code]
Granted that this failing makes mathematically total sense since it should say 'where x is greater 5 than and **x is** lower than 8' . I'd wish there would be a syntax supporting something like this:
[code language="powershell"]
1..10 | where {$_ (-gt 5 -and -lt 8)}
#or
Get-Process | where {$_.Name (-like 'power*' -and -notlike '*ise')}
[/code]
The idea is that the parentheses would indicate that the preceding variable should be considered as the (left-hand) parameter for the operator. I came up with a crude proof of concept on how this could be done:
https://gist.github.com/d24442b2bbb72f5ff269
What do you think, would you also like to see this kind of syntax for Where-Object?
![shareThoughts](https://powershellone.files.wordpress.com/2015/10/sharethoughts.jpg)


* * *


Photo Credit: [Ana Sofia Guerreirinho](https://www.flickr.com/photos/98153870@N00/3107494832/) via [Compfight](http://compfight.com) [cc](https://creativecommons.org/licenses/by-nd/2.0/)
