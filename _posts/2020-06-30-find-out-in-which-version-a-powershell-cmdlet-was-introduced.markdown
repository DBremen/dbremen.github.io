---
author: dirkbremen
comments: true
date: 2018-07-20 12:50:25+00:00
layout: post
link: https://powershellone.wordpress.com/2018/07/20/find-out-in-which-version-a-powershell-cmdlet-was-introduced/
slug: find-out-in-which-version-a-powershell-cmdlet-was-introduced
title: Find out in which version a PowerShell Cmdlet was introduced
wordpress_id: 1171
categories:
- PowerShell
---

![2364129390_4fe946df4a_m](https://powershellone.files.wordpress.com/2015/11/2364129390_4fe946df4a_m.jpg)
Some days ago [Thomas Rayner](http://twitter.com/MrThomasRayner) (whom I admire for his passion and consistency when it comes to sharing his knowledge) posted about the same topic on his [blog](https://workingsysadmin.com/finding-out-when-a-powershell-cmdlet-was-introduced/). He mentioned a method on how to utilize GitHub in order to find out the earliest Version a PowerShell Cmdlet was introduced. When I read the Thomas's post, I couldn't resist thinking about an option to automate the process. My first attempt was to check whether the information is already part of the help system or could be retrieved using Get-Command (using 'Expand-Archive' as an example):
[code language="powershell"]
Get-Command Expand-Archive | Format-List * | Out-String -Stream | 
     Where-Object {$_ -like '*version*'}
Get-Help Expand-Archive -Full | fl * | Out-String -Stream | 
     Where-Object {$_ -like '*version*'}
[/code]
While both commands return some information in relation to a version, in general, there is nothing telling us about the PowerShell version the Cmdlet was first introduced.
The next thought I had, looking at Get-Help was the online version.
[code language="powershell"]
Get-Help Expand-Archive -Online
[/code]
This command opens the default browser opening the HelpURI, which in this case looked like [https://docs.microsoft.com/en-us/powershell/module/Microsoft.PowerShell.Archive/Expand-Archive?**view=powershell-5.1**](https://docs.microsoft.com/en-us/powershell/module/Microsoft.PowerShell.Archive/Expand-Archive?view=powershell-5.1). See the last part of the URI? There seemed to be some hope following this route. The webpage features a drop-down where users can select a PowerShell version (3-6). Selecting Version 3 from the drop-down for the Expand-Archive help page brought me to this URI [https://docs.microsoft.com/en-us/powershell/module/Microsoft.PowerShell.Archive/Expand-Archive?**view=powershell-6&viewFallbackFrom=powershell-3.0**](https://docs.microsoft.com/en-us/powershell/module/Microsoft.PowerShell.Archive/Expand-Archive?view=powershell-6&viewFallbackFrom=powershell-3.0). Version 4 revealed a similar result, while the Version 5 URI did not contain the "viewFallback..." part. Similarly, when pasting a URI like [https://docs.microsoft.com/en-us/powershell/module/Microsoft.PowerShell.Archive/Expand-Archive?view=powershell-3.0](https://docs.microsoft.com/en-us/powershell/module/Microsoft.PowerShell.Archive/Expand-Archive?view=powershell-3.0) into the browser's address bar, it redirects automatically to the "viewFallback..." version. Great, there we have it, a pattern that can be automated :-):



  
  1. Construct the base help URI for a Cmdlet

  
  2. Loop through the PowerShell version in ascending order (3-6)

  
    
    1. Add the version part to the URI

    
    2. Invoke the web-request and capture the redirect target

    
    3. If the redirect target URI does not contain the "viewFallBack..." part.

    
      
      * We found the first PSVersion where the Cmdlet was introduced. Return the version

    
    
    4. Otherwise continue the loop until we find the first version, where the redirect target URI does not contain the "viewFallback..." part.

  

Here you go "Get-FirstPSVersion":
https://gist.github.com/f1e8d032a47459ee79939b306a406c6e

![shareThoughts](https://powershellone.files.wordpress.com/2015/10/sharethoughts.jpg)



* * *



Photo Credit: [sharkbait](https://www.flickr.com/photos/61417564@N00/2364129390/) via [Compfight](http://compfight.com) [cc](https://creativecommons.org/licenses/by-nc-sa/2.0/)
