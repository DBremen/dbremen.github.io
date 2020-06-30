---
author: dirkbremen
comments: true
date: 2016-02-25 19:15:26+00:00
layout: post
link: https://powershellone.wordpress.com/2016/02/25/fix-clipboard-is-not-working-restart-process-with-powershell/
slug: fix-clipboard-is-not-working-restart-process-with-powershell
title: 'Fix: Clipboard is not working + Restart-Process with PowerShell'
wordpress_id: 1053
categories:
- PowerShell
- Troubleshooting
---

![24460391384_1668f05155_m](https://powershellone.files.wordpress.com/2016/02/24460391384_1668f05155_m.jpg)
Sometimes it happens that the clipboard stops working. The routine of copy and paste we all rely on so many times a day suddenly refuses to do its job. The reason this happens is usually an application blocking the keyboard, making it impossible for other applications to get access to the clipboard. In order to fix this, one needs to find out which application is the culprit and either stop or restart the respective process in order to "free up" the clipboard. 
I put together a small PowerShell function (Clear-Clipboard), that does just that:

![clipboardBlocking](https://powershellone.files.wordpress.com/2016/02/clipboardblocking.png)



	
  1. It identifies the process that currently blocks the clipboard (Using [GetOpenClipboardWindow](https://msdn.microsoft.com/en-us/library/windows/desktop/ms649044%28v=vs.85%29.aspx) and [GetWindowThreadProcessId](https://msdn.microsoft.com/en-us/library/windows/desktop/ms633522%28v=vs.85%29.aspx) API calls)

	
  2. Opens a small GUI offering options to either stop or restart the process


Other than the mentioned Clear-Clipboard function. I'm also sharing Restart-Process as a separate function as it might be useful at times. Both can be downloaded from my [GitHub repository](https://github.com/DBremen/PowerShellScripts/tree/master/functions).

https://gist.github.com/985cf4c0eaee0383e7f2



![shareThoughts](https://powershellone.files.wordpress.com/2015/10/sharethoughts.jpg)



* * *



Photo Credit: [Andi Campbell-Jones](https://www.flickr.com/photos/91333108@N02/24460391384/) via [Compfight](http://compfight.com) [cc](https://creativecommons.org/licenses/by-nc-sa/2.0/)
