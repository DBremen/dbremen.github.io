---
author: dirkbremen
comments: true
date: 2016-02-24 10:03:57+00:00
layout: post
link: https://powershellone.wordpress.com/2016/02/24/fix-chrome-wont-start-or-taking-a-long-time-to-start/
slug: fix-chrome-wont-start-or-taking-a-long-time-to-start
title: 'Fix: Chrome won''t start or taking a long time to start'
wordpress_id: 1034
categories:
- Troubleshooting
---

![25187751746_7369950f8d_m](https://powershellone.files.wordpress.com/2016/02/25187751746_7369950f8d_m.jpg)

Two simple, yet not intuitive solutions to solve two quite annoying Chrome problems (worked for me on Windows 10 and Windows 8).


#### 1. Chrome browser refuses to launch



**Solution:** Reset the winsock catalog (see [https://support.microsoft.com/en-us/kb/811259](https://support.microsoft.com/en-us/kb/811259) and [https://technet.microsoft.com/en-us/library/cc753591%28v=ws.10%29.aspx](https://technet.microsoft.com/en-us/library/cc753591%28v=ws.10%29.aspx) for more details).:



	
  1. Open an elevated command prompt (see [here](http://www.tenforums.com/tutorials/2790-elevated-command-prompt-open-windows-10-a.html))


  2. Type: `**netsh winsock reset**` and hit Enter

	
  3. Restart your PC





#### 2. Chrome takes a very long time to launch:



**Solution:** Disable hardware acceleration:



	
  1. Open chrome and type `**chrome://settings**` into the address bar and hit Enter

	
  2. Scroll down and click "Show advanced setttings..."

	
  3. Scroll further down and **untick** the box next to "Use hardware accelartion when available"




![shareThoughts](https://powershellone.files.wordpress.com/2015/10/sharethoughts.jpg)



* * *



Photo Credit: [Dakiny](https://www.flickr.com/photos/55658968@N00/25187751746/) via [Compfight](http://compfight.com) [cc](https://creativecommons.org/licenses/by-nc-nd/2.0/)
