---
author: dirkbremen
comments: true
date: 2015-08-11 21:24:33+00:00
layout: post
link: https://powershellone.wordpress.com/2015/08/11/search-file-content-by-keyword-using-everything-powershell-gui/
slug: search-file-content-by-keyword-using-everything-powershell-gui
title: Search file content by keyword using Everything + PowerShell + GUI
wordpress_id: 339
categories:
- PowerShell
tags:
- GUI
- search
---

![tree](https://powershellone.files.wordpress.com/2015/08/4268390987_6ac870f045_m.jpg)
Even with Windows 10 MS still didn't manage to include a proper in-built file search functionality. If it is about searching for files I definitely prefer the excellent [Everything search engine](http://www.voidtools.com/) (see also my post on [a PowerShell wrapper around Everything commandline](https://powershellone.wordpress.com/2015/02/28/using-everything-search-command-line-es-exe-via-powershell/)) .But quite frequently I also need to search for keywords/pattern within files. PowerShell's Get-ChildItem and Select-String can certainly do this together:
[code language="powershell"]
#search through all .ps(m)1 files for instances of the word 'mySearchString'
$path = 'c:\scripts\powershell'
Get-ChildItem $path -Include ("*.ps1","*.psm1")) -Recurse |
     Select-String 'mySearchString' | select Path, Line, LineNumber
[/code]
While this does the job it doesn't follow my preferred workflow and is also not very quick when running it against a large set of files. I would prefer to have the ability to search and drill down a list of files within a Graphical User Interface just like Everything and then search through the filtered list of files using keyword(s)/pattern(s) and get back the search results within a reasonable time-frame.
Say hello to "File Searcher" (I didn't spend any time thinking about a catchy name):
![FileSearcher](https://powershellone.files.wordpress.com/2015/08/filesearcher.png?w=660)
The three text boxes at the top of the UI can be used to:




  1. Search for files using Everything command-line (es.exe)


  2. Search within the list of files for content by keyword (using a replacement for Select-String more on that below)


  3. Filter the results by keywords (across all columns). This can be done against the list of files and against the list of results (Path, Line, LineNumber)


Let's first look at two use cases. 
1. Assuming we want to search for some PowerShell files starting with "Posh-" across the whole hard drive:



	
  * After importing the module (Import-Module $path\FileSearcher.psm1) files can be searched using the textbox at the top of the window

	
  * Using 'posh-*.ps1' and hitting Enter as the search term will get us what we want

	
  * On my machine this results into a quite long list. I can scroll through the list to see whether I really want to search through all those files or further drill it down either by refining the initial search or using the 'filter results' textbox.
	  
  * For the example's sake let's assume I'd like to filter the result list to show only those entries that contain the word 'string' (within the full path)

	
  * Now I would like to search those files for instances of the word 'select'. Entering the keyword into the 3rd text-box filters the results as I type.

	
  * The result is a list of 'Path, Line, LineNumber' results that can be further filtered by using the 'filter results' text-box again

	
  * Double-clicking one of the entries will open the file in notepad++ (of course only if this is installed) putting the cursor on the respective line. (This works only of notepad++ is not already open)


![FilesearchExample1](https://powershellone.files.wordpress.com/2015/08/filesearchexample1.png?w=660)
2. A second use case are situations where I want to "pre-populate" the list of files via command-line instead of using the GUI. Here is how to do that:



	
  * Pipe a list of files into the FileSearcher function: 
[code language="powershell"]
Import-Module $path\FileSearcher.psm1
$path = 'c:\scripts\powershell'
Get-ChildItem $path -Include ("*.ps1","*.psm1")) -Recurse | FileSearcher
[/code]


	
  * Use the UI to further refine and/or search the list of files for contents by keyword



The content search functionality is realized through a custom cmdlet (Search-FileContent) implemented in F# based on the solution (I have only changed the original solution to accept an array of strings for the full paths) provided in [this blog post](http://blogs.msdn.com/b/fsharpteam/archive/2012/10/03/rethinking-findstr-with-f-and-powershell.aspx). This speeds up the performance significantly as compared to Select-String through the usage of parallel asynchronous tasks.
The UI also support some options:



	
  * For file search (through Everything) the "no Recurse" option is applied if the first search term is a path (using the parents:DEPTH option which requires an up-to-date Everything version) e.g. the search term 'c:\scripts .ps1' with the option enabled would only search for .ps1 files within the c:\scripts directory.

	
  * The content search offers options similar to the Select-String switches to treat the keyword not as a regular expression (SimpleMatch) or/and do a case sensitive search.


Dependencies:

	
  1. [Everything command line version](http://www.voidtools.com/downloads/) (requires the UI version to be installed,too) installed to 'C:\Program Files*\es\es.exe'

	
  2. The Search-FileContent cmdlet is implemented via the SearchFileContent.dll which can be downloaded from my [GitHub repository](https://github.com/DBremen/PowerShellScripts) and needs to reside in the same folder as the FileSearcher.psm1 file.

	
  3. Because the Search-FileContent cmdlet is written in F# it requires the FSharp.Core assembly to be present which can be downloaded and installed via the following PowerShell code:
[code language="powershell"]
$webclient = New-Object Net.WebClient
$url = 'http://download.microsoft.com/download/E/A/3/EA38D9B8-E00F-433F-AAB5-9CDA28BA5E7D/FSharp_Bundle.exe'
$webclient.DownloadFile($url, "$pwd\FSharp_Bundle.exe")
.\FSharp_Bundle.exe /install /quiet
[/code]


  4. The ability to open files from the file search content results via double-click with the cursor on the respective line requires [Notepad++](https://notepad-plus-plus.org/download/v6.8.1.html)

The FileSearcher module itself can be also downloaded from my [GitHub repository](https://raw.githubusercontent.com/DBremen/PowerShellScripts/master/functions/FileSearcher.psm1).
Please use the comment function if you have any feedback or suggestions on how to improve the tool.

![shareThoughts](https://powershellone.files.wordpress.com/2015/10/sharethoughts.jpg)


* * *


Photo Credit: [Robb North](https://www.flickr.com/photos/34815016@N02/4268390987/) via [Compfight](http://compfight.com) [cc](https://creativecommons.org/licenses/by/2.0/)
