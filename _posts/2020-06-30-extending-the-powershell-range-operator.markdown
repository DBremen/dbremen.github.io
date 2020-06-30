---
author: dirkbremen
comments: true
date: 2015-03-15 20:09:45+00:00
layout: post
link: https://powershellone.wordpress.com/2015/03/15/extending-the-powershell-range-operator/
slug: extending-the-powershell-range-operator
title: Extending the PowerShell range operator
wordpress_id: 186
categories:
- PowerShell
---

[![tree15](https://powershellone.files.wordpress.com/2015/03/395546632_dfe050d0b6_m.jpg)](https://powershellone.files.wordpress.com/2015/03/395546632_dfe050d0b6_m.jpg)

The PowerShell range operator '..' can be used to create lists of sequential numbers with an increment (or decrement) of one:
[code language="powershell"]
1..5
-1..-5
[/code]
This is quite handy. Wouldn't it be even better if it would also support stepwise lists (FIRST, SECOND..LAST similar to Haskell where the step width is determined by the first and the second list entry), day, month and letter ranges? :
[code language="powershell"]
monday..wednesday
march..may
#range of numbers from 2 to 15 with steps of 3 (5 - 2)
2:5..15
#range of numbers from 1 to 33 with steps of .2 (1.2 - 1)
1:1.2..33
#range of letters from a to z
a..z
#range of letters from Z to A
Z..A
#range of numbers from -2 to 1024 with steps of 6 (4 - -2)
-2:4..1kb
[/code]
At least I though it would be. 
While PowerShell does not support something like language extensions in order to change the behavior of the range operator directly, it is possible to get this working (admittedly it feels a bit like a hack) by overriding the <del>'PreCommandLookupAction' event. The 'PreCommandLookupAction' event is triggered after the current line is parsed but before PowerShell attempts to find a matching command.</del>
I've encountered timed out IntelliSense/tab completion issues with the custom 'PreCommandLookupAction' therefore, I've updated the solution to use the 'CommandNotFoundAction' instead. The CommandNotFoundAction is triggered if PowerShell cannot find a command (who would have thought)
[code language="powershell"]

$ExecutionContext.SessionState.InvokeCommand.CommandNotFoundAction={
	param($CommandName,$CommandLookupEventArgs)
	#if the command consists of two dots with leading trailing words optionally containing (:,.) + leading -
	if ($CommandName -match '^(-*\w+[:.]*)+\.\.(-*\w+)+$'){
		$CommandLookupEventArgs.StopSearch = $true
		#associate new command
		$range = $CommandName.replace('get-','')
		$CommandLookupEventArgs.CommandScriptBlock={
			#no step specified
			if ($range -notlike '*:*') { 
				#check for month name or day name range
				$monthNames=(Get-Culture).DateTimeFormat.MonthNames
				$dayNames=(Get-Culture).DateTimeFormat.DayNames
				$enum=$null
				if ($monthNames -contains $range.Split("..")[0]){$enum=$monthNames}
				elseif ($dayNames -contains $range.Split("..")[0]){$enum=$dayNames}
				if ($enum){
					$start,$end=$range -split '\.{2}'
					$start=$enum.ToUpper().IndexOf($start.ToUpper()) 
					$end=$enum.ToUpper().IndexOf($end.ToUpper())
					$change=1
					if ($start -gt $end){ $change=-1 }
					while($start -ne $end){
						$enum[$start]
						$start+=$change
					}
					$enum[$end]
					return
				}
				#check for character range
				if ([char]::IsLetter($range[0])){
					[char[]][int[]]([char]$range[0]..[char]$range[-1])
					return
				}
				Invoke-Expression $range
				return 
			}
			$range = $range.Split(':')
			$step=$range[1].SubString(0,$range[1].IndexOf("..")) - $range[0]
			#use invoke-expression to support kb,mb.. and scientific notation e.g. 4e6
			[decimal]$start=Invoke-Expression $range[0]
			[decimal]$end=Invoke-Expression ($range[1].SubString($range[1].LastIndexOf("..")+2))
			$times=[Math]::Truncate(($end-$start)/$step)
			$start
			for($i=0;$i -lt $times ;$i++){
				($start+=$step)
			}
			
		}.GetNewClosure()
	}
}
[/code]
Adding the code to your profile will make the "extended" range operator version available in all PowerShell sessions. 
I've also create a separate Get-Range function which can be downloaded from my [Github repository](https://raw.githubusercontent.com/DirkBremen/PowerShellScripts/master/functions/Get-Range.ps1).

![shareThoughts](https://powershellone.files.wordpress.com/2015/10/sharethoughts.jpg)


* * *


Photo Credit: [zachstern](https://www.flickr.com/photos/18382722@N00/395546632/) via [Compfight](http://compfight.com) [cc](https://creativecommons.org/licenses/by-nc-nd/2.0/)
