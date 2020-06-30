---
author: dirkbremen
comments: true
date: 2015-08-27 21:25:39+00:00
layout: post
link: https://powershellone.wordpress.com/2015/08/27/fix-battery-icon-andor-volume-control-missing-from-windows-10-taskbar/
slug: fix-battery-icon-andor-volume-control-missing-from-windows-10-taskbar
title: 'Fix: Battery Icon  and/or Volume Control Missing From Windows 10 Taskbar'
wordpress_id: 453
categories:
- Troubleshooting
tags:
- error
---

![tree](https://powershellone.files.wordpress.com/2015/08/8645219964_7584567b8b_m.jpg)
I came across a rather weird problem today where my taskbar was missing the icons for the volume control and battery meter:
![Capture](https://powershellone.files.wordpress.com/2015/08/capture.png)
My first attempt to fix this was to check the related system settings:



	
  1. Open the run dialog (Windows-key + R) and type 'ms-settings:notifications'

	
  2. Click on 'Turn system icons on or off'

	
  3. In my case the sliders for both Volume and Power were disabled at the off position


If you find yourself in the same situation the following might help you, too:
As an alternative you can click here to jump to the bottom of the post for a PowerShell solution that will modify the respective registry keys instead of applying the changes via group policy settings



	
  1. Open the run dialog (Windows-key + R) and type 'gpedit.msc' _Note: The Local Group Policy Editor is not available in all windows versions [here](http://www.askvg.com/how-to-enable-group-policy-editor-gpedit-msc-in-windows-7-home-premium-home-basic-and-starter-editions/) is a link to a post that claims to bring it to all versions of Windows 7, which you can try out at your own risk on Windows 10._

	
  2. Navigate to: User Configuration -> Administrative Templates -> Start Menu and Taskbar

	
  3. Configure the policies for 'Remove the battery meter' and 'Remove the volume control icon' to be **Disabled**


 
    1. Double-click each entry


    2. Select the radio-button next to Disabled


    3. Click Apply and OK




For the changes to take affect you can either restart your PC or just restart windows explorer. One way to achieve the latter is through PowerShell (at least to have one PowerShell command in this post :-) ). Just use the command 
[code language="powershell" light="true"]
kill -n explorer
[/code]
This will end the explorer.exe task and restart automatically. As an alternative if you don't know your way around in PowerShell you could type the following into the run dialog:
[code language="powershell" light="true"]
powershell -exe bypass -nop -command "&{kill -n explorer}"
[/code]


**PowerShell only solution**
The following commands need to be executed from an elevated PowerShell window ([How to open an elevated PowerShell prompt in Windows 10](http://www.thewindowsclub.com/how-to-open-an-elevated-powershell-prompt-in-windows-10))
[code language="powershell"]
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer -Name HideSCAVolume -Value 0
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer -Name HideSCAPower -Value 0
kill -n explorer
[/code]
![shareThoughts](https://powershellone.files.wordpress.com/2015/10/sharethoughts.jpg)


* * *


Photo Credit: [Indigo Skies Photography](https://www.flickr.com/photos/61048402@N08/8645219964/) via [Compfight](http://compfight.com) [cc](https://creativecommons.org/licenses/by-nc-nd/2.0/)
