---
author: dirkbremen
comments: true
date: 2015-11-23 14:38:53+00:00
layout: post
link: https://powershellone.wordpress.com/2015/11/23/simplified-syntax-for-calculated-properties-with-select-object/
slug: simplified-syntax-for-calculated-properties-with-select-object
title: Simplified syntax for calculated Properties with Select-Object
wordpress_id: 943
categories:
- PowerShell
tags:
- Proxy
---

![3798238251_59749f23cb_m](https://powershellone.files.wordpress.com/2015/11/3798238251_59749f23cb_m.jpg)

Following on my journey in an attempt to make PowerShell work exactly the way I would like it to work I had a look into the syntax for calculated properties with Select-Object. Calculated properties for Select-Object are basically syntactic <del>accidents</del> sugar to add custom properties to objects on the fly (examples are taken from [here](https://technet.microsoft.com/en-us/library/ff730948.aspx)):
[code language="powershell"]
Get-ChildItem | Select-Object Name, CreationTime,  @{Name="Kbytes";Expression={$_.Length / 1Kb}}
Get-ChildItem | Select-Object Name, @{Name="Age";Expression={ (((Get-Date) - $_.CreationTime).Days) }}
[/code]
Looking at the [documentation](https://technet.microsoft.com/en-us/library/hh849895.aspx) for Select-Object we can see that the syntax for the calculated properties on the Property parameter permits different key names and value type combinations as valid arguments:
<table >
<tr >[TYPE]KEYNAME 1[TYPE]KEYNAME 2Example</tr>
<tr >
<td style="border:1px solid black;padding:3px;" >[STRING]Name
</td>
<td style="border:1px solid black;padding:3px;" >[STRING]Expression
</td>
<td style="border:1px solid black;padding:3px;" >@{Name="Kbytes";Expression="Static value"}
</td></tr>
<tr >
<td style="border:1px solid black;padding:3px;" >[STRING]Name
</td>
<td style="border:1px solid black;padding:3px;" >[SCRIPTBLOCK]Expression
</td>
<td style="border:1px solid black;padding:3px;" >@{Name="Kbytes";Expression={$_.Length / 1Kb}}
</td></tr>
<tr >
<td style="border:1px solid black;padding:3px;" >[STRING]Label
</td>
<td style="border:1px solid black;padding:3px;" >[STRING]Expression
</td>
<td style="border:1px solid black;padding:3px;" >@{Label="Kbytes";Expression="Static value"}
</td></tr>
<tr >
<td style="border:1px solid black;padding:3px;" >[STRING]Label
</td>
<td style="border:1px solid black;padding:3px;" >[SCRIPTBLOCK]Expression
</td>
<td style="border:1px solid black;padding:3px;" >@{Label="Kbytes";Expression={$_.Length / 1Kb}}
</td></tr>
</table>
Most of the people already familiar with PowerShell also know that the parameter can acceptsabbreviated key names, too. E.g. just using the first letter:
[code language="powershell"]
Get-ChildItem | Select-Object Name, CreationTime,  @{n="Kbytes";e={$_.Length / 1Kb}}
Get-ChildItem | Select-Object Name, @{n="Age";e={ (((Get-Date) - $_.CreationTime).Days) }}
[/code]
What I find confusing about this syntax is the fact that we need two key/value pairs in order to actually provide a name and a value. In my humble opinion it would make more sense if the Property parameter syntax for calculated properties would work the following way:
[code language="powershell"]
Get-ChildItem | Select-Object Name, CreationTime,  @{Kbytes={$_.Length / 1Kb}}
Get-ChildItem | Select-Object Name, @{Age={ (((Get-Date) - $_.CreationTime).Days) }}
[/code]
Let's see how this could be implemented with a little test function:
https://gist.github.com/d33f3851cc54e2d5cfbf

Now we can go ahead and create the proxy function to make Select-Object behave the same way.
First we will need to retrieve the scaffold for the proxy command. The following will copy the same to the clip board:
[code language="powershell"]
$Metadata = New-Object System.Management.Automation.CommandMetaData (Get-Command Select-Object)
$proxyCmd = [System.Management.Automation.ProxyCommand]::Create($Metadata) | clip
[/code]
Below is the code of the full proxy command highlighting the modified lines (as compared to the scaffold code):
[code language="powershell" highlight="64,65,66,67,68,69,70,71,72,73,74,75,76,77,78"]
function Select-Object{
    [CmdletBinding(DefaultParameterSetName='DefaultParameter', HelpUri='http://go.microsoft.com/fwlink/?LinkID=113387', RemotingCapability='None')]
    param(
        [Parameter(ValueFromPipeline=$true)]
        [psobject]
        ${InputObject},

        [Parameter(ParameterSetName='SkipLastParameter', Position=0)]
        [Parameter(ParameterSetName='DefaultParameter', Position=0)]
        [System.Object[]]
        ${Property},

        [Parameter(ParameterSetName='SkipLastParameter')]
        [Parameter(ParameterSetName='DefaultParameter')]
        [string[]]
        ${ExcludeProperty},

        [Parameter(ParameterSetName='DefaultParameter')]
        [Parameter(ParameterSetName='SkipLastParameter')]
        [string]
        ${ExpandProperty},

        [switch]
        ${Unique},

        [Parameter(ParameterSetName='DefaultParameter')]
        [ValidateRange(0, 2147483647)]
        [int]
        ${Last},

        [Parameter(ParameterSetName='DefaultParameter')]
        [ValidateRange(0, 2147483647)]
        [int]
        ${First},

        [Parameter(ParameterSetName='DefaultParameter')]
        [ValidateRange(0, 2147483647)]
        [int]
        ${Skip},

        [Parameter(ParameterSetName='SkipLastParameter')]
        [ValidateRange(0, 2147483647)]
        [int]
        ${SkipLast},

        [Parameter(ParameterSetName='IndexParameter')]
        [Parameter(ParameterSetName='DefaultParameter')]
        [switch]
        ${Wait},

        [Parameter(ParameterSetName='IndexParameter')]
        [ValidateRange(0, 2147483647)]
        [int[]]
        ${Index})

    begin
    {
        try {
            $outBuffer = $null
            if ($PSBoundParameters.TryGetValue('OutBuffer', [ref]$outBuffer))
            {
                $PSBoundParameters['OutBuffer'] = 1
            }
            #only if the property array contains a hashtable property
            if ( ($Property | where { $_ -is [System.Collections.Hashtable] }) ) {
                $newProperty = @()
                foreach ($prop in $Property){
                    if ($prop -is [System.Collections.Hashtable]){
                        foreach ($htEntry in $prop.GetEnumerator()){
                           $newProperty += @{n=$htEntry.Key;e=$htEntry.Value}
                        }
                    }
                    else{
                        $newProperty += $prop
                    }
                }
                $PSBoundParameters.Property = $newProperty
            }
            $wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand('Microsoft.PowerShell.Utility\Select-Object', [System.Management.Automation.CommandTypes]::Cmdlet)
            $scriptCmd = {& $wrappedCmd @PSBoundParameters }
            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($PSCmdlet)
        } catch {
            throw
        }
    }

    process
    {
        try {
            $steppablePipeline.Process($_)
        } catch {
            throw
        }
    }

    end
    {
        try {
            $steppablePipeline.End()
        } catch {
            throw
        }
    }

}
[/code]
Putting the above into your profile (You can read [here](http://www.computerperformance.co.uk/powershell/powershell_profile_ps1.htm) and [here](http://blogs.technet.com/b/heyscriptingguy/archive/2012/05/21/understanding-the-six-powershell-profiles.aspx) on how to work with profiles) will make the modified Select-Object available in every session. 
What do you think of the syntax for calculated properties?

![shareThoughts](https://powershellone.files.wordpress.com/2015/10/sharethoughts.jpg)



* * *



Photo Credit: [ChrisK4u](https://www.flickr.com/photos/32302858@N08/3798238251/) via [Compfight](http://compfight.com) [cc](https://creativecommons.org/licenses/by-nd/2.0/)
