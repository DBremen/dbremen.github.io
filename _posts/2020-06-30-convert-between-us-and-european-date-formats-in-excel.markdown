---
author: dirkbremen
comments: true
date: 2015-02-27 09:14:46+00:00
layout: post
link: https://powershellone.wordpress.com/2015/02/27/convert-between-us-and-european-date-formats-in-excel/
slug: convert-between-us-and-european-date-formats-in-excel
title: Convert between US and European date formats in Excel
wordpress_id: 87
categories:
- Excel
tags:
- date conversion
---

[![tree7](https://powershellone.files.wordpress.com/2015/02/12881132733_610ffbc0cf_m.jpg)](https://powershellone.files.wordpress.com/2015/02/12881132733_610ffbc0cf_m.jpg)

The easiest way I know of (please let me know if you know a better way) to convert between US ("mm/dd/yy") and European ("dd/mm/yy") dates without using VBA in Excel is via "Text to Columns". Let's look at an example:
[![Convert date1](https://powershellone.files.wordpress.com/2015/02/convertdates1.png)](https://powershellone.files.wordpress.com/2015/02/convertdates1.png)
My system's regional settings are setup for US dates, therefore I need to convert the dates to US format in order to make the Weekday function return a proper result. Here are the steps:



	
  1. Highlight the range of dates to convert (A2:A6)

	
  2. Click on "Text to Columns" in the Data ribbon

	
  3. Go with the defaults in the first two steps of the wizard

	
  4. Select "Date" as Column data format and pick the appropriate Format (DMY) from the dropdown

	
  5. Modify the Destination to paste the results somewhere else if necessary (needs to be on the same sheet)

	
  6. Click on "Finish"


[![ConvertDates2](https://powershellone.files.wordpress.com/2015/02/convertdates2.png)](https://powershellone.files.wordpress.com/2015/02/convertdates2.png)
[![ConvertDates3](https://powershellone.files.wordpress.com/2015/02/convertdates3.png)](https://powershellone.files.wordpress.com/2015/02/convertdates3.png)

![shareThoughts](https://powershellone.files.wordpress.com/2015/10/sharethoughts.jpg)


* * *


photo credit: [Bouleau d'hiver, Megève, Haute-Savoie, Rhône-Alpes, France.](http://www.flickr.com/photos/50879678@N03/12881132733) via [photopin](http://photopin.com) [(license)](https://creativecommons.org/licenses/by-nc-sa/2.0/)
