---
author: dirkbremen
comments: true
date: 2015-07-30 18:34:49+00:00
layout: post
link: https://powershellone.wordpress.com/2015/07/30/sort-data-using-a-custom-list-in-powershell/
slug: sort-data-using-a-custom-list-in-powershell
title: Sort data using a custom list in PowerShell
wordpress_id: 270
categories:
- PowerShell
tags:
- sort
---

[![5865108068_2d80d15834_m](https://powershellone.files.wordpress.com/2015/07/5865108068_2d80d15834_m.jpg)]()

Sometimes you might come across a situation where you'd like to sort a collection based on a custom list (similar to the [feature available in Excel](https://support.office.com/en-us/article/Sort-data-using-a-custom-list-def8ff2b-681a-4fc3-9bd2-a06455c379e1)), rather than doing a basic sort based on the alphanumeric order of the property values using the Sort-Object cmdlet:
[code language="powershell"]
$numberWords="three","one","two","four"
$numberWords | sort
[/code]
The above doesn't really do the trick, if one would like to sort the collection based on the semantic order. For one dimensional arrays like the one used in the example above the System.Array type has an overload of the  static sort method that can do this (kind of):
[code language="powershell"]
$numberWords="three","one","two","four"
$ranks=3,1,2,4
[Array]::Sort($ranks,$numberWords)
$numberWords
[/code]
While this produces the correct order (changing the order of the items in-place), it does not really scale to a longer list, since it requires the list of ranks to be provided for each element of the array. Furthermore this wouldn't work for collections of objects. The problem can be better approached by utilizing calculated properties for the Property parameter of the Sort-Object (see ...
[code language="powershell" light="true"]
Get-Help sort -Parameter Property
Get-Help sort -Examples 
[/code]
for more details):
[code language="powershell"]
$numberWords="three","one","two","four"
$numberWords=$numberWords*10
$customList="one","two","three","four"
$numberWords | sort { $customList.IndexOf($_) }
[/code]
In the example above a scriptblock is used instead of a property Name for the Property parameter. Inside the scriptblock the ranks of the items within the collection ($numberWords) are determined by their position within the custom list ($customList) through the usage of the IndexOf() method. The same approach can also be used to sort collections of objects. Let's try to sort processes by a custom list of process names:
[code language="powershell"]
$customList = 'iexplore', 'excel', 'notepad' 
Get-Process | sort {
	$rank=$customList.IndexOf($($_.Name.ToLower()))
	if($rank -ne -1){$rank}
	else{[System.Double]::PositiveInfinity}
},Name
[/code]
In addition to the approach used in the previous example, here we are also dealing with property values that do not appear in the list. In this case the IndexOf() method returns -1, which would lead the object(s) to show at the top of the list, instead we assign a very high number for those values this makes the object(s) showing up at the bottom of the list. Adding the Name property as an additional Property parameter value produces the additional property values to be sorted alphabetically.
Let's wrap this into a function for better re-usability:
[code language="powershell"]
function Sort-CustomList{
    param(
    [Parameter(ValueFromPipeline=$true)]$collection,
    [Parameter(Position=0)]$customList,
    [Parameter(Position=1)]$propertyName,
    [Parameter(Position=2)]$additionalProperty
    )
    $properties=,{
        $rank=$customList.IndexOf($($_."$propertyName".ToLower()))
        if($rank -ne -1){$rank}
        else{[System.Double]::PositiveInfinity}
    } 
    if ($additionalProperty){
        $properties+=$additionalProperty
    }
    $Input | sort $properties
}
$customList = 'iexplore', 'excel', 'notepad' 
Get-Process | Sort-CustomList $customList Name Name
[/code]
Sort-CustomList can also be downloaded from my [GitHub repository](https://github.com/DBremen/PowerShellScripts/blob/master/Data%20Wrangling/Sort-CustomList.ps1).

![shareThoughts](https://powershellone.files.wordpress.com/2015/10/sharethoughts.jpg)


* * *


Photo Credit: [...-Wink-...](https://www.flickr.com/photos/68842954@N00/5865108068/) via [Compfight](http://compfight.com) [cc](https://creativecommons.org/licenses/by-nc-sa/2.0/)
