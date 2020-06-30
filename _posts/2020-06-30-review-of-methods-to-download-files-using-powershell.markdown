---
author: dirkbremen
comments: true
date: 2015-10-27 13:56:49+00:00
layout: post
link: https://powershellone.wordpress.com/2015/10/27/review-of-methods-to-download-files-using-powershell/
slug: review-of-methods-to-download-files-using-powershell
title: Review of methods to download files using PowerShell
wordpress_id: 660
categories:
- PowerShell
tags:
- download
- write-up
---

![557483263_190baee82f_m](https://powershellone.files.wordpress.com/2015/10/557483263_190baee82f_m.jpg)
The goal of this post is to review and compare different methods to download files using PowerShell. As part of the review I would like to share (in addition to the inline source code you can also download a module ([Get-FileMethods](https://raw.githubusercontent.com/DBremen/PowerShellScripts/master/functions/Get-FileMethods.psm1)) that contains all functions via GitHub) some wrapper functions that follow the same pattern:



	
  * function name = Get-FileMETHODNAME

	
  * Parameters:

          

        <table >
        <tr >NameDescription</tr>
        <tr >
<td style="border:1px solid black;padding:3px;" >url
</td>
<td style="border:1px solid black;padding:3px;" >URL to download from
</td></tr>
        <tr >
<td style="border:1px solid black;padding:3px;" >destinationFolder
</td>
<td style="border:1px solid black;padding:3px;" >Defaults to "$env:USERPROFILE\Downloads"
</td></tr>
        <tr >
<td style="border:1px solid black;padding:3px;" >includeStats
</td>
<td style="border:1px solid black;padding:3px;" >Switch parameter if specified the function will output stats for comparison purpose
</td></tr>
        </table>

	
  * If possible the function implements a progress bar including:
    * Remaining time (hh:mm:ss)
    * Elapsed time (hh:mm:ss)
    * Average download speed (Mb/s)/li>
    * Total download size (formatted according to size KB/MB/GB)
    * Currently downloaded size (formatted according to size KB/MB/GB)


  * After the download has finished the downloaded file is automatically unblocked

	
  * Provided that the includeStats is used the function outputs its name, the size of the file downloaded, and the time it took to download the file (the time is not representative and comparable as I'm currently using a quite bad 3G connection)

The following methods are compared and reviewed:
        <table >
        <tr >MethodFunction Name(s)</tr>
        <tr >
<td style="border:1px solid black;padding:3px;" >1. Invoke-WebRequest
</td>
<td style="border:1px solid black;padding:3px;" >Get-FileInvokeWebRequest
</td></tr>
        <tr >
<td style="border:1px solid black;padding:3px;" >2. Microsoft.VisualBasic.Devices.Network
</td>
<td style="border:1px solid black;padding:3px;" >Get-FileVB
</td></tr>
	<tr >
<td style="border:1px solid black;padding:3px;" >3. System.Net.WebClient
</td>
<td style="border:1px solid black;padding:3px;" >Get-FileWCSynchronous, Get-FileWCAsynchronous
</td></tr>
	<tr >
<td style="border:1px solid black;padding:3px;" >4. Background Intelligent Transfer Service
</td>
<td style="border:1px solid black;padding:3px;" >Get-FileBitsTransferSynchronous, Get-FileBitsTransferAsynchronous
</td></tr>
</table>

**Get-FileSize filter**
This is a little helper to convert file size units based on the number of actual bytes in a file, which I make use of within all the download functions:
https://gist.github.com/260d138d2e48ea06f0fb





## ↑Invoke-WebRequest


[Invoke-WebRequest](https://technet.microsoft.com/en-us/library/hh849901.aspx) is a built-in cmdlet  (since version 3) that can be used (amongst many other things) to download files. 
**Function:**
https://gist.github.com/ecff01498bcea7f4b311
**Test:**
[code language="powershell"]
$url = 'http://speedtest.reliableservers.com/10MBtest.bin'
Get-FileInvokeWebRequest $url -includeStats
[/code]
**Result:**


We get a built-in progress bar showing only the currently downloaded bytes and the download of 10MB took around 1 minute:


![ProgressInvokeWebRequest](https://powershellone.files.wordpress.com/2015/10/progressinvokewebrequest.png)


![resultInvokeWebRequest](https://powershellone.files.wordpress.com/2015/10/resultinvokewebrequest.png)



## ↑Microsoft.VisualBasic.Devices.Network





[The DownloadFile method](https://msdn.microsoft.com/en-us/library/ms127882%28v=vs.110%29.aspx) of the Network class within the Microsoft.VisualBasic.Devices Namespace is an oldie but goldie from VisualBasic which can be also used (once the respective assembly is loaded) from within PowerShell:

**Function:**
https://gist.github.com/506ef86d0525b0eaf6ab
**Test:**
[code language="powershell"]
$url = 'http://speedtest.reliableservers.com/10MBtest.bin'
Get-FileVB $url -includeStats
[/code]
**Result:**


This method also contains a built-in progress bar which pops up in a separate window but doesn't contain any additional information.  The download of 10MB took 17 seconds:


![progressBarVB](https://powershellone.files.wordpress.com/2015/10/progressbarvb.png)

![resultVB](https://powershellone.files.wordpress.com/2015/10/resultvb.png)



## ↑System.Net.WebClient





The [WebClient](https://msdn.microsoft.com/en-us/library/system.net.webclient%28v=vs.110%29.aspx) class provides two different means to download files. One works in synchronous mode ([DownloadFile](https://msdn.microsoft.com/en-us/library/ez801hhe%28v=vs.110%29.aspx)) and one in asynchronous mode ([DownloadFileAsync](https://msdn.microsoft.com/en-us/library/ms144196%28v=vs.110%29.aspx)). The difference between the two is, that in synchronous mode the execution of further commands halts until the download has finished while in asynchronous mode the execution continues since the download happens in the background (on another thread). Let's first have a look at the synchronous one.

**Function:**
https://gist.github.com/40602ad8342bd20b2ddf
**Test:**
[code language="powershell"]
$url = 'http://speedtest.reliableservers.com/10MBtest.bin'
Get-FileWCSynchronous $url -includeStats
[/code]
**Result:**


No progress bar (and no way to add one) and the download of 10MB took 35 seconds:





![resultWCSync](https://powershellone.files.wordpress.com/2015/10/resultwcsync.png)
Now the asynchronous version. The helper function is this time a bit more involved to get a proper progress bar by plugging into the respective events:

**Function:**
https://gist.github.com/425ad80bc0fb7d4ffd46
**Test:**

[code language="powershell"]
$url = 'http://speedtest.reliableservers.com/10MBtest.bin'
Get-FileWCAsynchronous $url -includeStats
[/code]



**Result:**


This time we can add a custom progress bar including current and overall download speed and time. The download of 10MB took 33 seconds this time:


![DownloadWCAsyncProgressbar](https://powershellone.files.wordpress.com/2015/10/downloadwcasyncprogressbar.png)

[![resultVB](https://powershellone.files.wordpress.com/2015/10/resultvb.png)](https://powershellone.files.wordpress.com/2015/10/resultvb.png)

![GetFileWCAsync_Result](https://powershellone.files.wordpress.com/2015/10/getfilewcasync_result.png)


## 




## ↑Background Intelligent Transfer Service





[Background Intelligent Transfer Service](https://technet.microsoft.com/en-us/magazine/ff382721.aspx) (short BITS) is built into Windows since Windows 7. It is a file-transfer service designed to transfer files using only idle network bandwidth therefore BITS does not use all available bandwidth, so you can use it to download large files without affecting other network applications. BITS transfers are also very reliable and can continue when users change network connections or restart their computers. Therefore MS makes use of this technology to download Windows Updates (try _Get-BitsTransfer -AllUsers | Select -ExpandProperty FileList_ to see a list of currently running BITS jobs). While BITS also provides a command-line interface...
[code language="vb"]
bitsadmin /transfer ajob http://speedtest.reliableservers.com/10MBtest.bin %USERPROFILE%\Desktop\10MBtest.bin
[/code]
... its use is deprecated since Windows 8. Instead the use of the BITS PowerShell module is encouraged. Similar to the WebClient class BITS also provides the user with a synchronous and asynchronous download method. Again we first take a look at the synchronous version:

**Function:**
https://gist.github.com/e14cbf8c336a074048ab
**Test:**
[code language="powershell"]
$url = 'http://speedtest.reliableservers.com/10MBtest.bin'
Get-FileBitsTransferSynchronous $url -includeStats
[/code]



**Result:**


This method provides a built-in progress bar but without much information. The download of 10MB took 1 minute 26 seconds which can be improved by specifying 'Foreground' to the 'Priority' paramater:


![BitsSync_progressbar](https://powershellone.files.wordpress.com/2015/10/bitssync_progressbar.png)
![BitsSync_Result](https://powershellone.files.wordpress.com/2015/10/bitssync_result.png)


## 


Again similar to WebClient the asynchronous mode provides means to add a custom progress bar. This time by using the properties of the job object:

**Function:**
https://gist.github.com/628099150687d0e7e5d0
**Test:**

[code language="powershell"]
$url = 'http://speedtest.reliableservers.com/10MBtest.bin'
Get-FileBitsTransferAsynchronous $url -includeStats
[/code]



**Result:**


Also with the async mode for BITS we can add a custom progress bar including current and overall download speed and time. The download of 10MB took exactly the same as using BITS in synchronous mode (00:01:25):


![BitsAsync_progressbar](https://powershellone.files.wordpress.com/2015/10/bitsasync_progressbar.png)
![BitsAsync_result](https://powershellone.files.wordpress.com/2015/10/bitsasync_result.png)


## 




## Conclusion


All methods have their advantages and disadvantages and the choice of course also depends on the actual task at hand (e.g. are we downloading a small file from the command prompt or are we downloading multiple files as part of a bigger scripts) and personal preferences. 
The most versatile is the BITS asynchronous mode since it provides everything the other methods also provide plus the ability to run the download in the background using only idle network bandwidth and also options to pause and resume the download.

![shareThoughts](https://powershellone.files.wordpress.com/2015/10/sharethoughts.jpg)


* * *


Photo Credit: [Nicolas Valentin](https://www.flickr.com/photos/37809637@N00/557483263/) via [Compfight](http://compfight.com) [cc](https://creativecommons.org/licenses/by-nc-sa/2.0/)
