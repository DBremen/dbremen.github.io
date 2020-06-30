---
author: dirkbremen
comments: true
date: 2015-09-10 11:18:55+00:00
layout: post
link: https://powershellone.wordpress.com/2015/09/10/automatically-convert-an-excel-table-to-a-checklist-for-jira/
slug: automatically-convert-an-excel-table-to-a-checklist-for-jira
title: Automatically convert an Excel table to a checklist for JIRA
wordpress_id: 525
categories:
- Excel
---

![3161323938_3bb7be6248_m](https://powershellone.files.wordpress.com/2015/09/3161323938_3bb7be6248_m.jpg)
JIRA supports a subset of [Wiki Markup to add tables](https://jira.atlassian.com/secure/WikiRendererHelpAction.jspa?section=tables) and [other formatting](https://jira.atlassian.com/secure/WikiRendererHelpAction.jspa?section=all) to fields like Description or Comments. Writing the Wiki Markup manually is quite time consuming though. To make the process a bit easier I ended up writing a Macro that converts an Excel based task tracker list into JIRA.
From this:
![jiraTable](https://powershellone.files.wordpress.com/2015/09/jiratable.png)
Into that:
![jiraWikiMarkup](https://powershellone.files.wordpress.com/2015/09/jirawikimarkup.png)
Running the Macro will copy the Wiki Markup to the clipboard from where it can be pasted into JIRA.
The Macro relies on a mapping between Status values and [ supported Markup symbols](https://jira.atlassian.com/secure/WikiRendererHelpAction.jspa?section=miscellaneous) and assumes that the selected cell is within the range that needs to be converted before running the Macro. The VBA project requires the following  additional references:



	
  1. Microsoft Scripting Runtime (for the Dictionary object)

	
  2. Microsoft Forms 2.0 Object Library (for the DataObject to provide the copy to clipboard functionality)


https://gist.github.com/0ba67c6ec894ee581d98
A Workbook containing the example can also be downloaded from [GitHub](https://github.com/DBremen/ExcelExamples/blob/master/ConvertTableToJIRAMarkup.xlsm?raw=true).

![shareThoughts](https://powershellone.files.wordpress.com/2015/10/sharethoughts.jpg)


* * *


Photo Credit: [chantrybee](https://www.flickr.com/photos/87779778@N00/3161323938/) via [Compfight](http://compfight.com) [cc](https://creativecommons.org/licenses/by/2.0/)
