---
author: dirkbremen
comments: true
date: 2015-10-07 21:08:50+00:00
layout: post
link: https://powershellone.wordpress.com/2015/10/07/expanding-aliases-in-powershell-ise-or-any-powershell-file/
slug: expanding-aliases-in-powershell-ise-or-any-powershell-file
title: Expanding aliases in PowerShell ISE or any PowerShell file
wordpress_id: 646
categories:
- PowerShell
tags:
- AST
- ISE
---

![393790664_da5b0ddb12_m](https://powershellone.files.wordpress.com/2015/10/393790664_da5b0ddb12_m.jpg)
Further extending my PowerShell ISE module ([ISEUtils](https://github.com/DBremen/ISEUtils)) I've added a function to convert aliases either in the currently active ISE file or (in case a a path is provided) within any PowerShell file (that way the function can be also used from the PowerShell Console) to their respective definitions. 
Aliases are very useful when working interactively, since they help saving extra keystrokes when you just want to get things done fast. At the same time if we are speaking about production code where readability, and easy comprehension of the code are much more important the usage of aliases should be avoided ( read [here](http://blogs.technet.com/b/heyscriptingguy/archive/2012/04/21/when-you-should-use-powershell-aliases.aspx) for a good article on best practices for PowerShell alias usage). 
With the Expand-Alias function you can get the best of both worlds. Writing clearer code while avoiding extraneous keystrokes. For the code samples in my blog posts I'm also using aliases quite a lot, but would like to start using the new function from now on.
Below is the source code for Expand-Alias:
https://gist.github.com/9db6632423d673ff18f6
Usage:


	
  1. If the function is called without any parameter it will expand all aliases within the current ISE file.

	
  2. Providing a full-path to the path parameter will expand all aliases within the respective PowerShell file instead.



Adding the following lines to your PowerShell profile (you can read [here](http://www.computerperformance.co.uk/powershell/powershell_profile_ps1.htm) and [here](http://blogs.technet.com/b/heyscriptingguy/archive/2012/05/21/understanding-the-six-powershell-profiles.aspx) on how to work with profiles) will automatically load the function and add an item to the AddOn menu to call it on every ISE startup:
[code language="powershell"]
$FULLPATHTOEXPANDALIAS = 'c:\expand-alias.ps1'
. $FULLPATHTOEXPANDALIAS
$null  = $psISE.CurrentPowerShellTab.AddOnsMenu.Submenus.Add('Expand-Alias', { Expand-Alias }, 'CTRL+SHIFT+X')
[/code]

![shareThoughts](https://powershellone.files.wordpress.com/2015/10/sharethoughts.jpg)


* * *



Photo Credit: [Martin Gommel](https://www.flickr.com/photos/71325969@N00/393790664/) via [Compfight](http://compfight.com) [cc](https://creativecommons.org/licenses/by-nc-nd/2.0/)
