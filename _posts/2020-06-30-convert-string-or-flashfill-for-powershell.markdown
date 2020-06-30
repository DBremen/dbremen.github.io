---
author: dirkbremen
comments: true
date: 2015-11-24 14:41:12+00:00
layout: post
link: https://powershellone.wordpress.com/2015/11/24/convert-string-or-flashfill-for-powershell/
slug: convert-string-or-flashfill-for-powershell
title: Convert-String for PowerShell is like FlashFill for Excel
wordpress_id: 961
categories:
- PowerShell
---

![16251434544_ac3c18c295_m](https://powershellone.files.wordpress.com/2015/11/16251434544_ac3c18c295_m.jpg)

[One of the many great additions](https://technet.microsoft.com/en-us/library/hh857339.aspx#BKMK_new50) that come with [Powershell v5](https://technet.microsoft.com/en-us/library/hh857339.aspx) is the  Convert-String cmdlet  (there is no official documentation at this point). Convert-String along with [ConvertFrom-String](https://technet.microsoft.com/en-us/library/dn807178.aspx) expose [FlashExtract](http://research.microsoft.com/en-us/um/people/sumitg/pubs/pldi14-flashextract.pdf) functionality to the PowerShell world. While ConvertFrom-String allows for some very sophisticated template based parsing ([Here](http://blogs.msdn.com/b/powershell/archive/2014/10/31/convertfrom-string-example-based-text-parsing.aspx), [here](http://foxdeploy.com/2015/01/13/walkthrough-part-two-advanced-parsing-with-convertfrom-string/) and [here](https://www.youtube.com/watch?v=9L0gIt5CtJ8) are some good links to get started) does Convert-String work much more like the [FlashFill](https://support.office.com/en-us/article/Use-AutoFill-and-Flash-Fill-2e79a709-c814-4b27-8bc2-c4dc84d49464) feature added in MS Excel. 
Convert-String can parse strings based on 1 or multiple examples. Let's look at two simple use cases:
![ConvertString](https://powershellone.files.wordpress.com/2015/11/convertstring3.gif)
Code:
[code language="powershell"]
'Jeffrey Snover', 'Ed Wilson', 'Bruce Payette', 'Lee Holmes' | 
   Convert-String -Example 'First Last=>_ F. Last'

1..10 | 
   foreach { [math]::Round((get-random -Minimum 1e9 -Maximum 9e9)) } | 
   Convert-String -Example '0123456789=(012) 345-6789'
[/code]
In addition to the input string the cmdlet only takes an argument on the 'Example' parameter. The 'Example' parameter expects  one of the following argument forms (thank you [dotPeek](https://www.jetbrains.com/decompiler/)):
<table >
<tr >DescriptionSyntaxExample</tr>
<tr >
<td style="border:1px solid black;padding:3px;" >A string of the form ORIGINAL=TRANSFORMED
</td>
<td style="border:1px solid black;padding:3px;" >'ORIGINAL=TRANSFORMED'
</td>
<td style="border:1px solid black;padding:3px;" >'First Last=F. L'
</td></tr>
<tr >
<td style="border:1px solid black;padding:3px;" >An array of strings of the form ORIGINAL=TRANSFORMED
</td>
<td style="border:1px solid black;padding:3px;" >'ORIGINAL1=TRANSFORMED1', 'ORIGINAL2=TRANSFORMED2'
</td>
<td style="border:1px solid black;padding:3px;" >('Jeffery Snover=J S', 'Lee Holmes=L H')
</td></tr>
<tr >
<td style="border:1px solid black;padding:3px;" >A hashtable with BEFORE and AFTER keys
</td>
<td style="border:1px solid black;padding:3px;" >@{BEFORE=ORIGINAL;AFTER=TRANSFORMED'}
</td>
<td style="border:1px solid black;padding:3px;" >@{  
BEFORE='First Last';  
AFTER='F Last'}
</td></tr>
<tr >
<td style="border:1px solid black;padding:3px;" >An array of hashtables with BEFORE and AFTER key pairs
</td>
<td style="border:1px solid black;padding:3px;" >@{BEFORE=ORIGINAL;AFTER=TRANSFORMED'}
</td>
<td style="border:1px solid black;padding:3px;" >@{  
BEFORE='Jeffery Snover';  
AFTER='J S'},  
@{  
BEFORE='Lee Holmes';  
AFTER='L H'}
</td></tr>
</table>
One more thing to note about the Example parameter syntax is, that '\' can be used to escape characters (e.g. if you have '=' in your pattern you have to use '\=' instead).
The FlashExtract engine basically automatically figures out what you want based on examples. Attempting to parse more complex patterns requires more examples, where the examples should reflect the different variations of the pattern within the string to parse. Let's look at some more examples for illustration purpose:
[code language="powershell"]
$txt = @'
Pete,47,Canada
Jake,23,France
Carol,33,Italy
Jane,18,Ireland
'@ -split "`n"
$ex = 'Pete,47,Canada=Pete is from Canada and 47 years old'
$txt | Convert-String -Example $ex
[/code]
Whoops, this didn't work out. This time around Convert-String was not able to recognize the full pattern throughout the entire input. Therefore we will need to provide more examples:
[code language="powershell"]
$txt = @'
Pete,47,Canada
Jake,23,France
Carol,33,Italy
Jane,18,Ireland
'@ -split "`n" 
$ex1 = 'Pete,47,Canada=Pete is from Canada and 47 years old'
$ex2 = 'Jake,23,France=Jake is from France and 23 years old'
$txt | Convert-String -Example ($ex1, $ex2)
[/code]
Two examples are indeed sufficient in this case. Convert-String is also able to figure out some variations itself. Here for example the age is either one or two characters long:
[code language="powershell"]
$txt = @'
Pete,47,Canada
Jake,23,France
Carol,3,Italy
Jane,8,Ireland
'@ -split "`n"
$ex1 = 'Pete,47,Canada=Pete is from Canada and 47 years old'
$ex2 = 'Jake,23,France=Jake is from France and 23 years old'
$txt | Convert-String -Example ($ex1, $ex2)
[/code]
Until now you might think that all this can also be quite easily achieved using previous PowerShell parsing capabilities and you would be right. While the examples so far can also make your life easier Convert-String can also do more advanced parsing which previously could be mainly done using Regular Expressions:
[code language="powershell"]
$txt = @'
Pete47Canada
Jake23France
Carol3Italy
Jane8Ireland
'@ -split "`n"
$ex1 = 'Pete47Canada=Pete is from Canada and 47 years old'
$ex2 = 'Jake23France=Jake is from France and 23 years old'
$txt | Convert-String -Example ($ex1, $ex2)
[/code]
Pretty cool, huh? 
Even more examples:
[code language="powershell"]
$txt = @'
Pete12/25/1966Canada
Jake3/14/1975France
Carol4/1/2012Italy
Jane8/17/2000Ireland
'@ -split "`n"
$ex1 = 'Pete12/25/1966Canada=Pete was born in 1966 and lives in Canada'
$ex2 = 'Carol4/1/2012Italy=Carol was born in 2012 and lives in Italy'
$txt | Convert-String -Example $ex1, $ex2

$txt = @'
Pete12/25/1966Canada
Jake3/14/1975France
Carol4/1/2012Italy
Jane8/17/2000Ireland
'@ -split "`n"
$ex1 = 'Pete12/25/1966Canada=Pete 12 Canada'
$ex2 = 'Carol4/1/2012Italy=Carol 4 Italy'
$txt | Convert-String -Example $ex1, $ex2 | 
    foreach { 
        $name, $month, $country = $_.Split()
        "$name was born in $((Get-Date -Month $month).ToString('MMMM')) and lives in $country" 
    }

$txt = @'
Pete$12.77Canada
Jake$13.8France
Carol$14.989Italy
Jane$17.99Ireland
'@ -split "`n"
$txt | Convert-String -Example 'Pete$12.77Canada=12,77'
[/code]

Convert-String can make all of us string parsing rock stars!

![shareThoughts](https://powershellone.files.wordpress.com/2015/10/sharethoughts.jpg)



* * *



Photo Credit: [Eric@focus](https://www.flickr.com/photos/15979685@N08/16251434544/) via [Compfight](http://compfight.com) [cc](https://creativecommons.org/licenses/by-sa/2.0/)
