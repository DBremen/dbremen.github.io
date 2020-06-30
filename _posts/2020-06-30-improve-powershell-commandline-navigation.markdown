---
author: dirkbremen
comments: true
date: 2015-03-03 20:28:03+00:00
layout: post
link: https://powershellone.wordpress.com/2015/03/03/improve-powershell-commandline-navigation/
slug: improve-powershell-commandline-navigation
title: Improve PowerShell commandline navigation
wordpress_id: 103
categories:
- PowerShell
tags:
- command line navigation
---

[![tree10](https://powershellone.files.wordpress.com/2015/03/3120502536_3ea77acd08_m.jpg)](https://powershellone.files.wordpress.com/2015/03/3120502536_3ea77acd08_m.jpg)

This post is about improving PowerShell in order to ease navigation on the commandline. There are some pretty cool solutions out there which I have added to my profile to be able to move around quicker:



	
  * [Jump-Location](https://github.com/tkellogg/Jump-Location)

	
  * [Go-Shell](https://github.com/cameronharp/Go-Shell)

	
  * [bd (Quickly Go Back To A Directory)](http://www.dougfinke.com/blog/index.php/2013/09/02/powershell-quickly-go-back-to-a-directory/)



Another one, that I came up with is in order to move down directory paths quickly similar to 'cd ..':
[code language="powershell"]
$ExecutionContext.SessionState.InvokeCommand.CommandNotFoundAction={
      param($CommandName,$CommandLookupEventArgs)
      #if the command is only dots
      if ($CommandName -match '^\.+$'){
            $CommandLookupEventArgs.CommandScriptBlock={
                  for ($counter=0;$counter -lt $CommandName.Length;$counter++){
                        Set-Location ..
                  }
            }.GetNewClosure()
      }
}
[/code]

Adding those lines to your profile (I believe v3 is required for this to work) will enable you to move down directory paths quickly by using just dots where the number of dots determines how many levels you move down the folder hierarchy. If you are for example within "PS>c:\test1\test2\test3\test4" the command "..." will move you down 3 levels to "PS>c:\test1". 

![shareThoughts](https://powershellone.files.wordpress.com/2015/10/sharethoughts.jpg)


* * *


photo credit: [dusk tusks](http://www.flickr.com/photos/28801512@N00/3120502536) via [photopin](http://photopin.com) [(license)](https://creativecommons.org/licenses/by-nc/2.0/)
