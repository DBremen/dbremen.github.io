---
author: dirkbremen
comments: true
date: 2015-08-27 13:57:43+00:00
layout: post
link: https://powershellone.wordpress.com/2015/08/27/using-powershell-to-clean-up-excel-data-with-multiple-entries-per-cell/
slug: using-powershell-to-clean-up-excel-data-with-multiple-entries-per-cell
title: Using PowerShell to clean-up excel data with multiple entries per cell
wordpress_id: 437
categories:
- PowerShell
tags:
- clean-up
- data
---

![8231960108_b07671cb72_m](https://powershellone.files.wordpress.com/2015/08/8231960108_b07671cb72_m.jpg)
How many times did you come across a situation where you were supposed to work with Data that looks like this?:
![CleanUpData](https://powershellone.files.wordpress.com/2015/08/cleanupdata.png)
Some of the cells have multiple entries that are either separated by comma or line-breaks (via Alt+Enter). Furthermore several of those entries contain extraneous spaces. Happy days! What would be actually needed in order to work with the data is one clean entry per cell. In order to do that the columns for those rows that contain multiple entries per cell also need to be cross-joined (or Cartesian product) so that all possible combinations for the entries are accounted for. The end result should look like this:
 ![CleanUpData2](https://powershellone.files.wordpress.com/2015/08/cleanupdata2.png)
How could we do the same using PowerShell? Let's first have a look on how to do the cross-join part. This can be done quite easily with nested loops. Taking the second row from the example, the following will lead to the desired result:
[code language="powershell"]
$name= @('Nigel')
$products = 'Product 1', 'Product 2'
$preferences = 'Fast Delivery', 'Product Quality'
foreach($n in $name){
    foreach($product in $products){
        foreach($preference in $preferences){
            "$n, $product, $preference"
        }
    }
}
[/code]
One way to turn this into a more generic solution is using recursion (You need to understand recursion in order to understand recursion ;-) ). 
Here is an implementation of the same:
https://gist.github.com/a7209498dbaacb1ef951
Ok, having covered the difficult part we now only need to read the data from excel clean it up and apply the Cartesian product function to it. Here is the full code to automate the whole process:
https://gist.github.com/67a2b18e59f440184f47
The above contains a modified version of the CartesianProduct function in order handle objects (actually ordered hashtables since they preserve the column order). If time permits I would like to implement the same as an Excel macro and share it as part of another post.
Update: I've added [another post](https://powershellone.wordpress.com/2015/09/03/automatically-clean-up-excel-data-with-multiple-entries-per-cell-separated-by-comma-or-line-breaks/) outlining how to do the same (using another approach) via an Excel Macro

![shareThoughts](https://powershellone.files.wordpress.com/2015/10/sharethoughts.jpg)


* * *


Photo Credit: [pni](https://www.flickr.com/photos/16391511@N00/8231960108/) via [Compfight](http://compfight.com) [cc](https://creativecommons.org/licenses/by-nc-sa/2.0/)
