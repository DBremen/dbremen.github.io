---
author: dirkbremen
comments: true
date: 2015-02-16 19:54:18+00:00
layout: post
link: https://powershellone.wordpress.com/2015/02/16/powershell-and-the-missing-ternary-operator/
slug: powershell-and-the-missing-ternary-operator
title: PowerShell and the "missing" ternary operator
wordpress_id: 21
categories:
- PowerShell
---

[![tree4](https://powershellone.files.wordpress.com/2015/02/4007173063_37e4cdb22a_m.jpg)](https://powershellone.files.wordpress.com/2015/02/4007173063_37e4cdb22a_m.jpg)

People switching to PowerShell from other languages like JavaScript or C# might be looking for a [ternary](https://msdn.microsoft.com/en-us/library/ty67wk28.aspx) operator at one point. While there is no built-in ternary operator in PowerShell it is not too hard to come up with something that comes pretty close to it. Let's look at an example:

[code language="powershell"]
filter Get-FourthLetter{
    if ($_.Length -gt 3){
        $_[3]
    }
    else{
        -1
    }
}
'Pete', 'Joe', 'Dirk' | Get-FourthLetter
[/code]

This defines a (admittedly pretty useless) filter (like a function but with a process block only) to get the fourth letter of any word that is "piped" into the filter, which has more than 4 characters or -1 (in case the word has less than 4 chars). Let's try to re-write this with "something like" a ternary operator in PowerShell:

[code language="powershell" highlight="2"]
filter Get-FourthLetter{
    (-1, $_[3])[$_.Length -gt 3]
}
'Pete', 'Joe', 'Dirk'  | Get-FourthLetter
[/code]

Here we replace the if/else construct with a simple array construct of the form (FALSEEXPRESSION, TRUEEXPRESSION). The CONDITION part is then used to index into the array by making use of the fact that $true evaluates to 1 and $false to 0 in PowerShell. To increase the "uselessness" factor even further, let's wrap the "ternary" operator functionality into a more generic filter:

[code language="powershell"]
filter ?:($trueExpression, $falseExpression){
    ($falseExpression, $trueExpression)[$_]
}
'Pete', 'Joe', 'Dirk'  | % { ($_.Length -gt 3)  | ?: $_[3] -1 }
[/code]

I hope this will help anyone that has been desperately searching for a PowerShell ternary operator ;-).

![shareThoughts](https://powershellone.files.wordpress.com/2015/10/sharethoughts.jpg)


* * *


photo credit: [Purple storm. Old Jacarandas avenue in Goodna, near Brisbane](http://www.flickr.com/photos/62938898@N00/4007173063) via [photopin](http://photopin.com) [(license)](https://creativecommons.org/licenses/by-nc-nd/2.0/)
