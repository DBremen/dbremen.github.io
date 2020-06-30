---
author: dirkbremen
comments: true
date: 2015-08-04 20:58:32+00:00
layout: post
link: https://powershellone.wordpress.com/2015/08/04/finding-the-index-of-an-object-within-an-array-by-property-value-using-powershell/
slug: finding-the-index-of-an-object-within-an-array-by-property-value-using-powershell
title: Finding the index of an object within an array by property value using PowerShell
wordpress_id: 297
categories:
- PowerShell
---

![1500333523_685c69638c_m](https://powershellone.files.wordpress.com/2015/08/1500333523_685c69638c_m.jpg)
Today I was looking for an option to find the index of an object within an array of objects. Using an array of one dimensional objects like integers this is as simple as using the [static IndexOf method](https://msdn.microsoft.com/en-us/library/7eddebat(v=vs.110).aspx) of the Array class in the System namespace:
[code language="powershell"]
$array=10..1
$index = $array.IndexOf(3)
$array[$index]
[/code]
But in my case I wanted to get the index of an item within an array of multidimensional or rich objects.  As an example let's say after running Get-Process we would like to find the index of the process whose Name property equals "powershell" (the return type here is an array of System.Diagnostics.Process objects). 
My first approach was to use the Select-String cmdlet since I knew it returns a LineNumber property. After some trial and error I came up with the following:
[code language="powershell"]
$processes = Get-Process
$index = (($processes | Out-String).Split("`n") | 
     Select-String "powershell").LineNumber
#index needs to be decremented by 4 since the data starts at line 3 and LineNumber is 1 based
$processes[$index-4]
[/code]
While this returns the desired result it's not a very robust solution. If there is, for example, powershell and powershell_ise running at the same time this would return two line numbers instead of one. Furthermore, the approach does not permit to look for items by property values (unless you throw in some crazy regex). 
Ok, let's give it another try. The problem with the $processes array is that it doesn't have an index property, but fortunately, with PowerShell it's not a problem at all to add one:
[code language="powershell"]
$processes = Get-Process | foreach {$i=0} {$_ | Add-Member Index ($i++) -PassThru}
$index = ($processes | where {$_.Name -eq "powershell"}).Index
$processes[$index]
[/code]
This looks already better. Adding an Index property to the array makes it easy to replicate the IndexOf method's functionality with an array of rich objects. It still involves quite some steps, though. Looking for yet another approach, I came across the [FindIndex method](https://msdn.microsoft.com/en-us/library/x1xzf2ca(v=vs.110).aspx) that is part of the System.Collections.Generic namespace:
[code language="powershell"]
$processes = [Collections.Generic.List[Object]](Get-Process)
$index = $processes.FindIndex( {$args[0].Name -eq "powershell"} )
$processes[$index]
[/code]
With that approach, we first need to cast the array to generic list. Generics are a concept of strongly typed languages like C# which make it possible to write a method that can be used against multiple types of objects (hence generic). For PowerShell, this doesn't matter so much since its type system is rather dynamic and mainly implicit therefore we just use a generic list of objects (kind of a generic generic list) here. The FindIndex method expects a typed predicate as its only argument which in PowerShell conveniently translates to a ScriptBlock. The predicate is exactly the same as what is used as the FilterScript parameter for the Where-Object cmdlet. The only difference is that we need to use the built-in [$args variable](https://technet.microsoft.com/en-us/library/hh847768.aspx) in order to access the current ("Pipeline") element instead of "$_".
How do those approaches compare in terms of execution speed?:
[code language="powershell"]
@'
(gps | foreach {$i=0} {$_ | Add-Member Index ($i++) -PassThru} | where Name -eq "powershell").Index
((gps | out-string).split("`n") | sls "powershell").LineNumber
([Collections.Generic.List[Object]](gps)).FindIndex({$args[0].Name -eq "powershell"})
'@ -split "`n" | foreach{
    (Measure-Command ([ScriptBlock]::Create($_))).TotalSeconds
}
[/code]
On my machine I got 0.21, 1.67, 0.02 respectively. Looks like the last approach also outperformed the others by at least an order of magnitude.

![shareThoughts](https://powershellone.files.wordpress.com/2015/10/sharethoughts.jpg)


* * *


Photo Credit: [Vince Alongi](https://www.flickr.com/photos/90963248@N00/1500333523/) via Compfight [cc](https://creativecommons.org/licenses/by/2.0/)
