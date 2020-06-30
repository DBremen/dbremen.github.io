---
author: dirkbremen
comments: true
date: 2015-08-24 15:24:40+00:00
layout: post
link: https://powershellone.wordpress.com/2015/08/24/add-a-default-code-template-to-the-powershell-ise/
slug: add-a-default-code-template-to-the-powershell-ise
title: Add a default code template to the PowerShell ISE
wordpress_id: 424
categories:
- PowerShell
tags:
- ISE
---

![tree](https://powershellone.files.wordpress.com/2015/08/7103078055_eabf5ec1cd_m.jpg)
Some of the 3rd party PowerShell editors offer already built-in support for a default code template where the content of the code template replaces the default blank sheet for every new tab as a starting point for new scripts. 
While the PowerShell ISE does not provide this functionality out-of-the-box, it can be quite easily added through the $psISE object model by registering a custom action for the $psise.CurrentPowerShellTab.Files 'CollectionChanged' event. This event is triggered whenever a tab is closed or opened:
https://gist.github.com/ae270d78e2a469398ddf
After pasting and running the above code inside the ISE we first need to create the template. The code template is required to be located at "MyDocuments\WindowsPowerShell\ISETemplate.ps1" it can be created and/or edited using the Edit-ISETemplate function. Once the ISETemplate.ps1 contains some text. Every new tab should now be pre-filled with the content of the code template file. 
In order to make this persistent the code should be added to your profile. You can find the path(s) to your profile by running '$profile | select *'. I personally favor the 'CurrentUserAllHosts' profile since I don't want to maintain multiple profile files. Host specific code can be added by using conditions like:
[code language="powershell"]
if ($host.Name -eq 'Windows PowerShell ISE Host'){
#ISE specific code here
}
elseif ($host.Name -eq 'ConsoleHost'){
#console specific code here
}
[/code]
I've also added this functionality to [my ISE Add-On](https://github.com/DBremen/ISEUtils) over on GitHub.

![shareThoughts](https://powershellone.files.wordpress.com/2015/10/sharethoughts.jpg)


* * *


Photo Credit: [flavijus](https://www.flickr.com/photos/8094551@N03/7103078055/) via [Compfight](http://compfight.com) [cc](https://creativecommons.org/licenses/by-nc-sa/2.0/)
