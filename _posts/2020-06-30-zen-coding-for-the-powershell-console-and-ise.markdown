---
author: dirkbremen
comments: true
date: 2015-11-09 15:23:56+00:00
layout: post
link: https://powershellone.wordpress.com/2015/11/09/zen-coding-for-the-powershell-console-and-ise/
slug: zen-coding-for-the-powershell-console-and-ise
title: Zen Coding for the PowerShell console and ISE
wordpress_id: 875
categories:
- PowerShell
tags:
- AST
- ISE
---

![8381892061_eb3babe76a_m](https://powershellone.files.wordpress.com/2015/11/8381892061_eb3babe76a_m.jpg)
First of all let's clarify what Zen Coding actually is. According to their [website](http://docs.emmet.io/): Emmet (formerly known as Zen Coding) is ...


<blockquote>... a web-developer’s toolkit that can greatly improve your HTML & CSS workflow.</blockquote>


But what does this have to do with PowerShell? At least I find myself quite often trying to convert PowerShell output into HTML or even using the text manipulation capabilities of PowerShell to dynamically construct some static web content. Yes, I hear you shouting already  isn't that why we have [ConvertTo-HTML](https://technet.microsoft.com/en-us/library/hh849944%28v=wps.630%29.aspx) and [Here-Strings](https://technet.microsoft.com/en-us/library/ee692792.aspx) (and [here](https://technet.microsoft.com/en-us/library/hh847740.aspx))? Granted that those can make the job already pretty easy (I would definitely recommend you to have a look into [Creating HTML Reports in PowerShell](https://www.penflip.com/powershellorg/creating-html-reports-in-powershell) if you haven't yet), but there is still an even better way to (dynamically) generate static HTML pages from within PowerShell. Before looking into the implementation details let's have a look at some examples on what zen coding looks like (considering we would have a PowerShell function called zenCode that expands zen code expressions):
[code language="powershell"]
zenCode 'html:5'
<# output:


	
		
		
	
	

#>
zencode 'ul.generic-list>(li.item>lorem10)*4'
<# output:



	
  * Sapien elit in malesuada semper mi, id sollicitudin urna fermentum.

	
  * Sapien elit in malesuada semper mi, id sollicitudin urna fermentum.

	
  * Sapien elit in malesuada semper mi, id sollicitudin urna fermentum.

	
  * Sapien elit in malesuada semper mi, id sollicitudin urna fermentum.


#>
zencode 'div+div>p>span+em^bq'
<# output:






	


		
		__
	


	

<blockquote></blockquote>





#>
zencode 'html>head>title+body>table>tr>th{name}+th{ID}^(tr>(td>lorem2)*3)*2'
<# output:

	
		
		
			<table >
				<tr >
					name
					ID
				</tr>
				<tr >
					
<td >Dolor sit.
</td>
					
<td >Dolor sit.
</td>
					
<td >Dolor sit.
</td>
				</tr>
				<tr >
					
<td >Dolor sit.
</td>
					
<td >Dolor sit.
</td>
					
<td >Dolor sit.
</td>
				</tr>
			</table>
		
	

#>
[/code]
You can have a look at the [Zen Coding Cheat Sheet](https://zen-coding.googlecode.com/files/ZenCodingCheatSheet.pdf) for more examples The syntax might look a bit cryptic at the first glance but once you get the hang of it it's pretty easy. While this is all already pretty cool I wanted a way to combine this with the PowerShell pipeline in order to do things like that:
[code language="powershell"]
zenCode 'ul>li.item{$_}'
<# output



	
  * 5

	
  * 4

	
  * 3

	
  * 2

	
  * 1


#>
gps | zenCode 'html>head>title+body>table>tr>th{name}+th{ID}^(tr>td{$_.name}+td{$_.id})'
<# output (excerpt):

	
		
		
			<table >
                                <tr >
					
<td >conhost
</td>
					
<td >14956
</td>
				</tr>
				<tr >
					
<td >csrss
</td>
					
<td >600
</td>
				</tr>
#>
gps | select -first 10 | zenCode 'html>head>title+body>table[border=1]>(tr>td{$_.Name}+td{$_.ID})+td{$_.Modules | select -first 10}'
<# output (excerpt):

		
		
			<table border="1" >
				<tr >
					Name
					ID
					Modules
				</tr>
				<tr >
					
<td >iexplore
</td>
					
<td >8048
</td>
					
<td >
</td>
				</tr>
				<tr >
					
<td >iexplore
</td>
					
<td >8488
</td>
					
<td >
						<table >
							<tr >
								pstypenames
								BaseAddress
								Container
								EntryPointAddress
								FileName
								FileVersionInfo
								ModuleMemorySize
								ModuleName
								Site
								Company
								Description
								FileVersion
								Product
								ProductVersion
								Size
							</tr>
							<tr >
								
<td >
									<table >
										<tr >
											
<td >System.Diagnostics.ProcessModule
</td>
										</tr>
										<tr >
											
<td >System.ComponentModel.Component
</td>
										</tr>
										<tr >
											
<td >System.MarshalByRefObject
</td>
										</tr>
										<tr >
											
<td >System.Object
</td>
										</tr>
									</table>
								
</td>
								
<td >18612224
</td>
								
<td >
</td>
								
<td >18619984
</td>
								
<td >C:\Program Files (x86)\Internet Explorer\IEXPLORE.EXE
</td>
								
<td >File:             C:\Program Files (x86)\Internet Explorer\IEXPLORE.EXE
InternalName:     iexplore
OriginalFilename: IEXPLORE.EXE.MUI
FileVersion:      11.00.9600.16428 (winblue_gdr.131013-1700)
FileDescription:  Internet Explorer
#>
[/code]
The solution to make this happen relies on the zencoding implementation [Mad Kristensen](http://madskristensen.net/) has developed (https://github.com/madskristensen/zencoding) which he has also made part of his awesome [Web Essentials](http://vswebessentials.com/) Visual Studio extension.
I've made a PowerShell function (Get-ZenCode alias zenCode) and also an ISE Add-on that expand Zen Code expressions and also work with the PowerShell pipeline. Get-ZenCode also supports output to a file (outPath parameter) and showing the result in the default browser (-Show Switch). I'm posting the source code for Get-ZenCode below but you can also download the same including full help and more examples from [my GitHub page](https://github.com/DBremen/ISEUtils/blob/master/functions/Get-ZenCode.ps1) (the function requires the [zenCoding.dll](https://github.com/madskristensen/zencoding) within a resources subfolder) . The ISE Add-On (including Get-ZenCode) is part of my [ISEUtils](https://github.com/DBremen/ISEUtils) Add-On. With the Add-On the expressions can be typed into the Editor (without the preceding zenCode call) and expanded by pressing CTRL+SHIFT+J (or the respective menu entry):
![ExpandZenCode](https://powershellone.files.wordpress.com/2015/11/expandzencode.gif)
https://gist.github.com/06aeb0bcdcc1d57f04d6

How do you like Zen Coding?

![shareThoughts](https://powershellone.files.wordpress.com/2015/10/sharethoughts.jpg)


* * *


Photo Credit: [jurvetson](https://www.flickr.com/photos/44124348109@N01/8381892061/) via [Compfight](http://compfight.com) [cc](https://creativecommons.org/licenses/by/2.0/)
