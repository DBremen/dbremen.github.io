---
author: dirkbremen
comments: true
date: 2015-09-03 20:12:04+00:00
layout: post
link: https://powershellone.wordpress.com/2015/09/03/automatically-clean-up-excel-data-with-multiple-entries-per-cell-separated-by-comma-or-line-breaks/
slug: automatically-clean-up-excel-data-with-multiple-entries-per-cell-separated-by-comma-or-line-breaks
title: Automatically clean-up excel data with multiple entries per cell separated
  by comma or line-breaks
wordpress_id: 481
categories:
- Excel
tags:
- clean-up
- data
---

![tree](https://powershellone.files.wordpress.com/2015/09/15650146954_b83cb9b72c_m.jpg)
This is a follow-up from a [previous post](https://powershellone.wordpress.com/2015/08/27/using-powershell-to-clean-up-excel-data-with-multiple-entries-per-cell/) where I did the same using PowerShell.
A short recap first. The goal is to turn something like this:
![CleanUpData](https://powershellone.files.wordpress.com/2015/08/cleanupdata.png)
Into this:
![CleanUpData2](https://powershellone.files.wordpress.com/2015/08/cleanupdata2.png)
In the original state some of the cells have multiple entries that are either separated by comma or line-breaks (via Alt+Enter). Furthermore several of those entries contain extraneous spaces. In order to tabulate the data the columns for those rows that contain multiple entries per cell also need to be cross-joined (or Cartesian product) to ensure all possible combinations for the entries are accounted for. 
Rather than merely translating the recursive CartesianProduct function from the previous post into VBA I decided to follow a different approach. 
Utilizing [ADO](https://support.microsoft.com/en-us/kb/257819) to build a cross-join (without duplicates) across columns for rows that contain multiple entries. <del>In order do that (I'm not really good at VBA and there might be better ways, that I'd love to hear about) the columns need to be copied to separate sheets so that the ADODB adapter recognizes them as separate tables</del>I actually found that there is no need to copy the columns to separate sheets since ADO also accepts range references.The SQL for the cross-join with only unique entries is very simple. Assuming the following setup (for the separated entries of the second row from our example):
![cross-join3](https://powershellone.files.wordpress.com/2015/09/cross-join3.png)
The Macro to build the cross-join looks like this:
https://gist.github.com/d840be45ba5c82e6d874
If you like to follow along here are the steps:



	
  1. Setup up the workbook as in the screenshot and save it (as .xlsm)

	
  2. Press Alt+F11 to open the Visual Basic Editor (VBE)

	
  3. Locate the project for your workbook (VBAProject(NAME.xlsm)) within the project tree view on the left hand side

	
  4. Right-Click the project entry and pick 'Insert -> Module'

	
  5. Copy and paste the code into the new window

	
  6. From the menu at the top select Tools -> References...

	
  7. Tick the box for the entry 'Microsoft ActiveX Data Objects 2.x Library' and click 'OK'

	
  8. Close the VBE window

	
  9. Run the Macro by hitting Alt+F8 and picking the entry for 'CrossJoinRanges' and clicking on 'Run'


If everything worked out (in case it didn't you can download the workbook via [GitHub](https://github.com/DBremen/ExcelExamples/raw/master/CrossJoinRanges.xlsm)) the workbook should now contain a new sheet with the cross-joined content of the other sheets:
![cross-join2](https://powershellone.files.wordpress.com/2015/09/cross-join2.png)
To turn this into a re-usable generic Macro the columns for the rows containing cells with multiple-entries need to be copied to a temporary sheet and the SQL statement needs to be build dynamically based on the number of columns and rows. Furthermore the Macro should also take care of rows that do not contain multiple entries, add the header to the output, and remove extraneous spaces from all entries. The final result uses two Subs one for the cross-join (CrossJoinRangesWithoutDupes) and another one that acts as the main entry point and to do the rest of the job (CleanData) and a little helper function (isSaved) to determine whether the workbook has ever been saved (otherwise I didn't get the ADODB connection to work):
https://gist.github.com/85dc6a1a7d8903102cce
A workbook containing the Macro that produces the output shown at the top of the post can be downloaded from my [GitHub repo](https://github.com/DBremen/ExcelExamples/raw/master/CleanData_CrossJoin.xlsm). If you'd like to use the function more frequently I would recommend adding it to the Personal Macro Book as outlined [here](https://support.office.com/en-nz/article/Copy-your-macros-to-a-Personal-Macro-Workbook-aa439b90-f836-4381-97f0-6e4c3f5ee566) in order to have it available across all Excel files.

![shareThoughts](https://powershellone.files.wordpress.com/2015/10/sharethoughts.jpg)


* * *


Photo Credit: [byb64](https://www.flickr.com/photos/50879678@N03/15650146954/) via [Compfight](http://compfight.com) [cc](https://creativecommons.org/licenses/by-nc-sa/2.0/)
