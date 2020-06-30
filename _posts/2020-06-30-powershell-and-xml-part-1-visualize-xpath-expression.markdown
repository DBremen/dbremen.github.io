---
author: dirkbremen
comments: true
date: 2016-03-14 15:27:02+00:00
layout: post
link: https://powershellone.wordpress.com/2016/03/14/powershell-and-xml-part-1-visualize-xpath-expression/
slug: powershell-and-xml-part-1-visualize-xpath-expression
title: PowerShell and XML part 1 - Visualize XPath expression
wordpress_id: 1084
categories:
- PowerShell
tags:
- xml
---

![25284059970_e955b4e014_m](https://powershellone.files.wordpress.com/2016/03/25284059970_e955b4e014_m.jpg)

This is supposed to be the start of a small series of posts on how to deal with XML through PowerShell. While PowerShell already comes with built-in support for XML, there is quite a lot to learn. As part of the learning path, there might be some good opportunities where we can try to make things a little bit easier and extend the capabilities of the built-in commands.
Before diving any deeper into the details of PowerShell in conjunction with XML, I would like to start the series with XPath. This post's goal is not to provide you with an XPath reference nor will it be an extensive tutorial. According to the principle...


<blockquote>Give a man a fish and you feed him for a day; teach a man to fish and you feed him for a lifetime.</blockquote>


... I will rather guide you through the first steps, point you to some references, and share a PowerShell script that will hopefully help you also on journey to learn XPath. In layman's terms, XPath can be considered as SQL for XML. Hence, it is essential to learn XPath if you would like to do any serious XML (yes, with PowerShell one can get around this by using dot notation and built-in filter commands, but once you know XPath a lot of the tasks can be done easier and more efficient) related job. 
Actually I haven't used XPath a lot so far myself and also never really bothered to learn it either (the latter might have caused the former in this case ;-) ). 
In terms of references I can recommend the following as a starting point:



	
  * [W3 Schools XPath tutorial](http://www.w3schools.com/xsl/xpath_intro.asp)

	
  * [Microsoft XPath reference](https://msdn.microsoft.com/en-us/library/ms256471%28v=vs.110%29.aspx)

	
  * [Bartek Bielawski's series of posts  in the PowerShellMagazine](http://www.powershellmagazine.com/author/bbartek/page/4/)



I will use a slightly modified version of the example [inventory.xml XML file that Microsoft uses](https://msdn.microsoft.com/en-us/library/ms256095%28v=vs.110%29.aspx) as part of their [XPath reference](https://msdn.microsoft.com/en-us/library/ms256115(v=vs.110).aspx). The file can be downloaded from [here](https://raw.githubusercontent.com/DBremen/PowerShell-XMLHelpers/master/data/Inventory.xml).
The easiest way to use XPath through PowerShell is via the [Select-XML](https://technet.microsoft.com/en-us/library/hh849968.aspx) cmdlet. The query part of Select-XML is basically a wrapper around  [SelectNodes](https://msdn.microsoft.com/en-us/library/system.xml.xmlnode.selectnodes(v=vs.110).aspx) (with the downside that it does not support most of the XPath functions (more on that in a future post)). The Select-XML cmdlet supports input via Path[], String[] or XML (array of XML modes) through its ParameterSets:
[code language="powershell" light="true"]
Get-Command Select-XML -Syntax
[/code]
The XPath expression argument for Select-XML's XPath parameter is one of the few places where case matters in PowerShell(i.e. **XPath expressions are case-sensitive**). The output is an array of matching XML nodes. Using above mentioned inventory.xml let's look at some examples:
[code language="powershell"]
$path = 'c:\inventory.xml'
$xml = Select-Xml -Path $path -XPath / 
#Select the first book element that is the child of the bookstore element.
$xml | Select-XML /bookstore/book[1] | foreach { $_.Node }
#Select all the title elements that have a "lang" attribute with a value of "en"
$xml | Select-XML //title[@lang='en'] | foreach { $_.Node }
[/code]
Before throwing more random XPath examples at you I would like to share 'Test-XPath' ( download is available [here](https://github.com/DBremen/PowerShell-XMLHelpers)). Test-XPath loads XML into a tree-view and provides a combobox to type an XPath expression that is used to query parts of the XML, matching XML nodes are then highlighted within the tree-view. If no XML argument is provided Test-XPath will load the mentioned inventory.XML and populate the combobox with most of the example XPath expressions from the Microsoft XPath reference. Test-XPath will hopefully help you to get a better grasp of XPath by example:
[![Test-XPath](https://powershellone.files.wordpress.com/2016/03/test-xpath.gif)](https://powershellone.files.wordpress.com/2016/03/test-xpath.gif)
 
While this just scratches the surface of what can be done with XPath I will leave those details for another post (e.g. Namespaces, XPath functions, more general XML related tasks).

![shareThoughts](https://powershellone.files.wordpress.com/2015/10/sharethoughts.jpg)



* * *



Photo Credit: [herdiephoto](https://www.flickr.com/photos/33458919@N03/25284059970/) via [Compfight](http://compfight.com) [cc](https://creativecommons.org/licenses/by/2.0/)[
