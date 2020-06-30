---
author: dirkbremen
comments: true
date: 2015-11-16 14:48:21+00:00
layout: post
link: https://powershellone.wordpress.com/2015/11/16/wmi-query-filters-with-powershell-syntax-instead-of-wql/
slug: wmi-query-filters-with-powershell-syntax-instead-of-wql
title: WMI query filters with PowerShell syntax instead of WQL
wordpress_id: 897
categories:
- PowerShell
tags:
- AST
- Proxy
- WMI
---

![2465120031_ebb0a49e45_m](https://powershellone.files.wordpress.com/2015/11/2465120031_ebb0a49e45_m.jpg)
PowerShell comes already with tight integration to [WMI](https://msdn.microsoft.com/en-us/library/aa384642%28v=vs.85%29.aspx) with its built-in Get-WmiObject and Get-CimInstance cmdlets. One of the things that people already familiar with PowerShell syntax bothers about WMI is that it comes with its very own query language [WQL](https://msdn.microsoft.com/en-us/library/aa394606%28v=vs.85%29.aspx). While WQL is very similar to SQL. Wouldn't it be nicer if we could use the same operators and wild-card patterns we are already familiar with?
Well, for myself the answer is Yes:

![PowerShellInsteadOfWQL](https://powershellone.files.wordpress.com/2015/11/powershellinsteadofwql1.png)
Let's first build a proof of concept before creating a proxy function for Get-WmiObject. We can make us of the (newer) [PowerShell parser](https://msdn.microsoft.com/en-us/library/system.management.automation.language.parser.parseinput%28v=vs.85%29.aspx) to identify the different elements of the Filter for conversion and the [WildcardPattern.ToWql](https://msdn.microsoft.com/en-us/library/system.management.automation.wildcardpattern.towql%28v=vs.85%29.aspx) method to convert the wild-card pattern for the LIKE operator:
https://gist.github.com/c4f207a38eae079e9469

All it takes are 35 lines of code to implement the functionality.
Now that we have the proof of concept working we can go ahead and dynamically create the proxy functions for Get-WmiObject and Get-CimInstance to keep it simple we just add an additional parameter (PowerShellFilter) that takes the PowerShell syntax, converts the PowerShell to WQL and passes it on to the 'Filter' parameter without worrying about adding an additional parameter set to mutually exclude the 'Filter' and 'PowerShellFilter' parameters. After retrieving the code for the proxy command using the command meta data we need to add the statements for the new parameter (considering the same parameter sets as for the existing 'Filter' parameter) at the the top of the param statement and insert the additional logic between the following lines (e.g. Get-WmiObject)...
[code language="powershell" firstline="115" highlight="118,119"]
if ($PSBoundParameters.TryGetValue('OutBuffer', [ref]$outBuffer))
{
$PSBoundParameters['OutBuffer'] = 1
}
$wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand('Microsoft.PowerShell.Management\Get-WmiObject', [System.Management.Automation.CommandTypes]::Cmdlet)
[/code]
... before creating the new function based on a script block made of the updated code:
https://gist.github.com/0b168d96e0a5b362f4f7

Putting the above into your profile (You can read [here](http://www.computerperformance.co.uk/powershell/powershell_profile_ps1.htm) and [here](http://blogs.technet.com/b/heyscriptingguy/archive/2012/05/21/understanding-the-six-powershell-profiles.aspx) on how to work with profiles) will enable you to use PowerShell syntax with Get-WmiObject and Get-CimInstance:
[code language="powershell"]
$state = 'Running'
Get-WmiObject -Class Win32_Service -PowerShellFilter {Name -like '*srv*' -and State -eq $state}
Get-CimInstance -ClassName Win32_Service -PowerShellFilter {Name -like '*srv*' -and State -eq 'Running'}
[/code]
How do you like PowerShell syntax to query WMI?

![shareThoughts](https://powershellone.files.wordpress.com/2015/10/sharethoughts.jpg)



* * *



Photo Credit: [Svedek](https://www.flickr.com/photos/49583217@N00/2465120031/) via [Compfight](http://compfight.com) [cc](https://creativecommons.org/licenses/by-nc-nd/2.0/)
