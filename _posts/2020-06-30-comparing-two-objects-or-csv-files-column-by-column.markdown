---
author: dirkbremen
comments: true
date: 2015-06-30 18:38:58+00:00
layout: post
link: https://powershellone.wordpress.com/2015/06/30/comparing-two-objects-or-csv-files-column-by-column/
slug: comparing-two-objects-or-csv-files-column-by-column
title: Comparing two objects or .csv files column by column
wordpress_id: 193
categories:
- PowerShell
tags:
- compare
---

[![tree16](https://powershellone.files.wordpress.com/2015/06/2516424698_49af7874e5_m.jpg)](https://powershellone.files.wordpress.com/2015/06/2516424698_49af7874e5_m.jpg)



It has been some time. After the initial excitement, it seems to be more difficult to continue blogging over here. I hope that I can establish and keep a pace for regular posts from now on.

I recently came across a situation where I wanted to compare two .csv files. Knowing PowerShell I immediately thought about using Compare-Object for the job. Let's look at an example:

[code language="powershell"]
$referenceObject=@'
ID,Name,LastName,Town
1,Peter,Peterson,Paris
2,Mary,Poppins,London
3,Dave,Wayne,Texas
4,Sandra,Mulls,Berlin
'@ | ConvertFrom-CSV
$differenceObject=@'
ID,Name,LastName,Town
1,Peter,Peterson,Paris
2,Mary,Poppins,Cambridge
5,Bart,Simpson,Springfield
4,Sandra,Mulls,London
'@ | ConvertFrom-CSV
Compare-Object $referenceObject $differenceObject
[/code]
Which produces no output at all. This is because by default Compare-Object will call the ToString Method of the objects that are to be compared (both objects are of type 'System.Object[]').
Providing an array of property values to the Property parameter makes the output already look better.

[code language="powershell" light="true"]
Compare-Object $referenceObject $differenceObject -Property ID, Name, LastName, Town
[/code]

The output now contains a SideIndicator property that shows which object contains the respective value 



	
  * ==  Contained in both objects

	
  * <=  Contained only in the referenceObject (the first object provided to the cmdlet)

        
  * =>  Contained only in the differenceObject (the latter object provided to the cmdlet)


While this is kind of nice, it still doesn't tell us which property has changed along with the old and new values. I came up with a little helper function that does just that. Get-ChangeLog takes three parameters:

	
  1. The referenceObject

	
  2. The differenceObject

	
  3. A property that acts as a unique identifier for the object. This is in order to be able to know what to compare to across the two objects



[code language="powershell"]
function Get-ChangeLog($referenceObject,$differenceObject,$identifier){
    $props = $referenceObject | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name
    $diff = Compare-Object $referenceObject $differenceObject -Property $props -PassThru | 
        group $identifier
    #capture modifications
    $today = (Get-Date).ToShortDateString()
    $modifications = ($diff | where Count -eq 2).Group | group $identifier
    foreach ($modification in $modifications){
        #compare properties of each group
        foreach ($prop in $props){
            if ($modification.Group[0].$prop -ne $modification.Group[1].$prop){
                $output = $modification.Group | where {$_.SideIndicator -eq '<='} |
                    select (echo Date $identifier ChangeType ChangedProperty From To)
                $output.Date = $today
                $output.ChangeType = "Modified"
                $output.ChangedProperty = $prop
                $output.From = ($modification.Group | where {$_.SideIndicator -eq '<='}).$prop
                $output.To = ($modification.Group | where {$_.SideIndicator -eq '=>'}).$prop
                $output
            }
        }
    }
    #capture removals and additions
    $removalAdditions=$groupedDiff = ($diff | where Count -eq 1).Group | group $identifier
    foreach ($removalAddition in $removalAdditions){
        $ht = [ordered]@{}
        $ht.Add('Date',$today)
        $ht.Add($identifier,$removalAddition.Name)
        $ht.Add('ChangeType','')
        $ht.Add('ChangedProperty','')
        $ht.Add('From','')
        $ht.Add('To','')
        #addition
        if ($removalAddition.Group.SideIndicator -eq "=>"){
            $ht.ChangeType = 'Added'
        }
        #removal
        else{
            $ht.ChangeType = 'Removed'
        }
        New-Object PSObject -Property $ht
    }
}
[/code]

Using it with the same objects from the previous examples will result into the following output:
[code language="powershell" light="true"]
Get-ChangeLog $referenceObject $differenceObject ('ID') | Format-Table -AutoSize
[/code]
[![Capture](https://powershellone.files.wordpress.com/2015/06/capture.png)](https://powershellone.files.wordpress.com/2015/06/capture.png)

The function can also be downloaded from my [GitHub repo](https://github.com/DBremen/PowerShellScripts).

![shareThoughts](https://powershellone.files.wordpress.com/2015/10/sharethoughts.jpg)


* * *


Photo Credit: [ester-**](https://www.flickr.com/photos/64197260@N00/2516424698/) via [Compfight](http://compfight.com) [cc](https://creativecommons.org/licenses/by-nc-sa/2.0/)
