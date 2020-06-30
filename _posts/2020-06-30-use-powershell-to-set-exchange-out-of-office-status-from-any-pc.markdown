---
author: dirkbremen
comments: true
date: 2016-02-11 17:09:35+00:00
layout: post
link: https://powershellone.wordpress.com/2016/02/11/use-powershell-to-set-exchange-out-of-office-status-from-any-pc/
slug: use-powershell-to-set-exchange-out-of-office-status-from-any-pc
title: Use PowerShell to set Exchange Out of Office status from any PC
wordpress_id: 998
categories:
- PowerShell
tags:
- outlook
---

![24549821590_a4ce2a15cd_m](https://powershellone.files.wordpress.com/2016/02/24549821590_a4ce2a15cd_m.jpg)
I'm sure this has also happened already several times to you. You finish up your work to start into your well deserved holidays and only after you arrive at home do you realize that you forgot about to set your "Out of Office"  status (considering that you actually do that). Usually, this would mean that you need to use your company device in order to connect back to work and set it up. If your company is running Exchange mail servers there is actually another option available which enables you to do the same from any PC that is connected to the Internet. The [EWS Managed API](https://msdn.microsoft.com/en-us/library/office/dd633710%28v=exchg.80%29.aspx) is the technology that enables this. 
I've written a module that uses the API in order to set an Out of Office message. The function has the following features:



	
  * Check whether the EWS Managed API is installed and offer an option to download and install in case it is not

	
  * Option to provide credentials (-ProvideCredentials switch) or use the current

	
  * A pop-up calendar to select the duration of the absence.

	
  * Automatic calculation of the return date based on the next business day after the duration end date

	
  * A custom OOTO message including start and return date (based on next business day after duration end date) and your Outlook signature (the signature is copied from your work PC ($env:APPDATE\Microsoft\Outlook\Signatures\) if available or should be within the same location as the module)

	
  * The function also creates an appointment in your Outlook based on the provided start and end date


Usage:
[code language="powershell"]
Import-Module Set-OOTO
Set-OOTO 'email@domain.com' -ExchangeVersion Exchange2007_SP1 -ProvideCredential
[/code]
I've added my email and [Exchange server version](https://support.office.com/en-us/article/Determine-the-version-of-Microsoft-Exchange-Server-my-account-connects-to-cac9769b-39e7-4a74-8a0d-994bca37aa7a) as default parameters to the function (if you are using Exchange 2007SP3 you can also need to use Exchange2007_SP1 as the value for the ExchangeVersion parameter (this took me quite a while to figure out)). Other than that you can of course modify the function with your own custom message and additional features (please share).
I'm posting the code below including helper functions to set the appointment and the calendar window. The code can also be downloaded from my [GitHub repo](https://github.com/DBremen/PowerShellScripts):
https://gist.github.com/a9fd2db545f0d59aebe6



![shareThoughts](https://powershellone.files.wordpress.com/2015/10/sharethoughts.jpg)



* * *



Photo Credit: [nousku](https://www.flickr.com/photos/85352038@N00/24549821590/) via [Compfight](http://compfight.com) [cc](https://creativecommons.org/licenses/by-nc/2.0/)
