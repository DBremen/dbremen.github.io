---
author: dirkbremen
comments: true
date: 2015-10-13 14:26:42+00:00
layout: post
link: https://powershellone.wordpress.com/2015/10/13/powershell-tricks-use-show-command-to-add-a-simple-gui-to-your-functions/
slug: powershell-tricks-use-show-command-to-add-a-simple-gui-to-your-functions
title: PowerShell tricks - Use Show-Command to add a simple GUI to your functions
wordpress_id: 682
categories:
- PowerShell
tags:
- GUI
- tricks
---

![211707_b06dae339d_m](https://powershellone.files.wordpress.com/2015/10/211707_b06dae339d_m.jpg)
The [Show-Command cmdlet](https://technet.microsoft.com/en-us/library/hh849915.aspx) has been introduced in PowerShell Version 3 and is very useful to help discovering and learning more about PowerShell cmdlets and their respective parameters (also built into the ISE as the Show-Command Add-on).:
[code language="powershell"]
#Discover commands by running Show-Command without parameters
Show-Command
#Run Show-Command for a specific cmdlet
Show-Command Get-ChildItem
[/code]
Show-Command can be also utilized for your own functions in order to provide your users with a simple GUI as it builds a graphical user interface for the provided function on the fly. Show-Command displays:



	
  * A drop-down for parameters that use the ValidateSet option

	
  * A check-box for switch parameters

	
  * A text box for any other type of parameter

	
  * An asterisk behind the parameter name in case the parameter is mandatory (the mandatory parameters are also enforced by disabling the run/copy buttons until the mandatory parameter is provided)

	
  * Each parameter set is displayed on a separate tab


Below is an example showing the features mentioned above using the NoCommonParameter switch to hide those parameters and PassThru in combination with Invoke-Expression in order to run the function with the chosen parameters (I couldn't get this working otherwise):
https://gist.github.com/c5ffad6e6e80411275f4

![Show-MyCommand](https://powershellone.files.wordpress.com/2015/10/show-mycommand.png)
Limitations of this approach are:



	
  * No enforcement for any other advanced function parameter option (e.g. ValidatePattern). The error message is displayed on the command prompt after clicking Run.

	
  * No option to disable/change the built-in functionality (e.g. disable buttons at the bottom, change minimum height)

        
  * No sophisticated options for specific parameter types (e.g. browse for files)


What are the GUI options you like to you use for your functions?
Update: I've added a [follow-up post](https://powershellone.wordpress.com/2015/10/22/show-commandgui-an-enhanced-show-command-for-powershell/) with a new function that removes the disadvantages mentioned above
![shareThoughts](https://powershellone.files.wordpress.com/2015/10/sharethoughts.jpg)


* * *


Photo Credit: [Sun Spiral](https://www.flickr.com/photos/51035587720@N01/211707/) via [Compfight](http://compfight.com) [cc](https://creativecommons.org/licenses/by-nc-sa/2.0/)
