---
author: dirkbremen
comments: true
date: 2015-07-20 20:30:21+00:00
layout: post
link: https://powershellone.wordpress.com/2015/07/20/using-the-excel-intersection-operator/
slug: using-the-excel-intersection-operator
title: Using the Excel intersection operator
wordpress_id: 233
categories:
- Excel
---

[![tree](https://powershellone.files.wordpress.com/2015/07/325009584_2a9ecd3e6b_m.jpg)](https://powershellone.files.wordpress.com/2015/07/325009584_2a9ecd3e6b_m.jpg)
One of the lesser-known features of Excel is the intersection operator which can be used to simplify look-up operations. An intersection is the overlap of two or more cell ranges within excel. For instance:
In the screenshot below the ranges C1:C5 and B3:D3 (Cell ranges in Excel are written by using the range operator ":") overlap in the cell C3.
[![intersection1](https://powershellone.files.wordpress.com/2015/07/intersection1.png?w=300)](https://powershellone.files.wordpress.com/2015/07/intersection1.png)
The intersection operator " " (a space) can be used to find the intersection of ranges. To find the intersection of the two ranges one can just use the following formula "=C1:C5 B3:D3":
[![intersection2](https://powershellone.files.wordpress.com/2015/07/intersection2.png?w=300)](https://powershellone.files.wordpress.com/2015/07/intersection2.png)
Combining the intersection operator with named ranges yields to pretty intuitive look-ups in Excel. Let's take up another example using monthly revenue data by region:
[![intersection3](https://powershellone.files.wordpress.com/2015/07/intersection31.png)](https://powershellone.files.wordpress.com/2015/07/intersection31.png)
Highlighting the table and pressing CTRL+SHIFT+F3 will bring up the "Create Names from Selection" dialog. We can go with the defaults (Top row, Left column) in order to create named ranges for each column and row within the table based on their labels:
[![intersection4](https://powershellone.files.wordpress.com/2015/07/intersection41.png)](https://powershellone.files.wordpress.com/2015/07/intersection41.png)
Now, in order to retrieve the March Results for the East region we can simply use "=March East":
[![intersection5](https://powershellone.files.wordpress.com/2015/07/intersection51.png)](https://powershellone.files.wordpress.com/2015/07/intersection51.png)
Getting the Sum of the revenues from January-April for the West region is equally simple "=Sum(January:April West)":
[![intersection6](https://powershellone.files.wordpress.com/2015/07/intersection61.png)](https://powershellone.files.wordpress.com/2015/07/intersection61.png)
Even non-consecutive ranges can be easily referred to. Pulling up the Sum of revenues for the month of January, March, and May for the South region is as easy as typing "=Sum((January,March,May) South)":
[![intersection7](https://powershellone.files.wordpress.com/2015/07/intersection7.png)](https://powershellone.files.wordpress.com/2015/07/intersection7.png)

![shareThoughts](https://powershellone.files.wordpress.com/2015/10/sharethoughts.jpg)


* * *


Photo Credit: [1 brian](https://www.flickr.com/photos/34111548@N00/325009584/) via [Compfight](http://compfight.com) [cc](https://creativecommons.org/licenses/by-nc-sa/2.0/)
