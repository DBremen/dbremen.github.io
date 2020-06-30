---
author: dirkbremen
comments: true
date: 2015-09-10 09:11:46+00:00
layout: post
link: https://powershellone.wordpress.com/2015/09/10/a-nicer-promptforchoice-for-the-powershell-console-host/
slug: a-nicer-promptforchoice-for-the-powershell-console-host
title: A nicer PromptForChoice for the PowerShell Console Host
wordpress_id: 508
categories:
- PowerShell
tags:
- GUI
---

![378322049_c01db2cbf5_m](https://powershellone.files.wordpress.com/2015/09/378322049_c01db2cbf5_m.jpg)
Sometimes it's not possible to fully automate a certain process and we need some input from the user(s) of the script in order to determine the further path of action. If this is based on a fixed set of choices the built-in PromptForChoice method can come to the rescue. Here is an example:
https://gist.github.com/778414455f932e1f9ac8
Running the code below in PowerShell ISE will produce the following result:

![PromptForChoiceISE](https://powershellone.files.wordpress.com/2015/09/promptforchoiceise.png)
Running the same from the PowerShell console though will not look as fancy:
![PromptForChoiceConsole](https://powershellone.files.wordpress.com/2015/09/promptforchoiceconsole.png)
The reason for the difference is that the underlying [PromptForChoice method](https://msdn.microsoft.com/en-us/library/system.management.automation.host.pshostuserinterface.promptforchoice%28v=vs.85%29.aspx) on the System.Management.Automation.Host.PSHostUserInterface is declared as an [abstract method](https://msdn.microsoft.com/en-us/library/aa664435%28v=vs.71%29.aspx). This basically means that the implementation details are up to the respective PowerShell host (as long as the method complies with the declaration).
As a result your script will not provide a consistent user experience across PowerShell hosts (e.g. ISE, Console). Because of this I wrote a little Windows.Form based helper function that provides the same features as PromptForChoice but will look the same across all PowerShell hosts:
https://gist.github.com/73d7999094e7ac342ad6
Using Get-Choice like this:
[code language="powershell" light="true"]
Get-Choice "Pick Something!" (echo Option1 Option2 Option3) 2
[/code]
Will look in both ISE and Console like that:

![GetChoice](https://powershellone.files.wordpress.com/2015/09/getchoice.png)
The most notable parts of the function are probably in the loop on lines 46-59. Where the buttons are created dynamically based on the options provided.:
[code language="powershell" firstline="46" highlight="47,48,49,50,51,52,53,54,55,56,57"]
foreach ($option in $Options){
        Set-Variable "button$index" -Value (New-Object System.Windows.Forms.Button)
        $temp = Get-Variable "button$index" -ValueOnly
        $temp.Size = New-Object System.Drawing.Size($buttonWidth,$buttonHeight)
        $temp.UseVisualStyleBackColor = $True
        $temp.Text = $option
        $buttonX = ($index + 1) * $spacing + $index * $buttonWidth
        $temp.Add_Click({ 
            $script:result = $this.Text; $form.Close() 
        })
        $temp.Location = New-Object System.Drawing.Point($buttonX,$buttonY)
        $form.Controls.Add($temp)
        $index++
}
[/code]
Similar to the way it works in PromptForChoice preceding a character from within the option values with an ampersand (e.g. Option &1) will make the button accessible via ALT-key + the letter (e.g. ALT + 1).
The function can also be found in my [GitHub repo](https://github.com/DBremen/PowerShellScripts).

![shareThoughts](https://powershellone.files.wordpress.com/2015/10/sharethoughts.jpg)


* * *


Photo Credit: [zachstern](https://www.flickr.com/photos/18382722@N00/378322049/) via [Compfight](http://compfight.com) [cc](https://creativecommons.org/licenses/by-nc-nd/2.0/)
