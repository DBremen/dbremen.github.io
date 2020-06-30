---
author: dirkbremen
comments: true
date: 2015-03-06 15:24:50+00:00
layout: post
link: https://powershellone.wordpress.com/2015/03/06/powershell-propertysets-and-format-views/
slug: powershell-propertysets-and-format-views
title: PowerShell Property Sets
wordpress_id: 114
categories:
- PowerShell
---

[![tree11](https://powershellone.files.wordpress.com/2015/03/3708696947_04516e63c5_m.jpg)](https://powershellone.files.wordpress.com/2015/03/3708696947_04516e63c5_m.jpg)


### What are PowerShell Property sets and how can they be used?


Property sets are named groups of properties for certain types that can be used through Select-Object. The property sets are defined in the *types*.ps1xml files that can be found in the $pshome directory. Most of the types have default property sets defined as DefaultDisplayPropertertySet within the PSStandardMembers MemberSet. Those determine the list of properties shown when an object of that type is output. An example:

[code language="powershell"]
$process = (Get-Process)[0]
$process.PSStandardMembers.DefaultDisplayPropertySet.ReferencedPropertyNames
$process | Format-List
[/code]

[![screenShotPropertySet1](https://powershellone.files.wordpress.com/2015/03/screenshotpropertyset1.png)](https://powershellone.files.wordpress.com/2015/03/screenshotpropertyset1.png)

The list of default properties for a type can be modified by using Update-TypeData:

[code language="powershell"]
$process = (Get-Process)[0]
$typeName = $process.PSTypeNames[0]
Update-TypeData -TypeName $typeName -DefaultDisplayPropertySet Handles, Name, ID -Force
$process | Format-List
[/code]

[![screenShotPropertySet](https://powershellone.files.wordpress.com/2015/03/screenshotpropertyset5.png)](https://powershellone.files.wordpress.com/2015/03/screenshotpropertyset5.png)

Some types have additional property sets defined that can be used with Select-Object:

[code language="powershell"]
Get-Process | select PSConfiguration -Last 5 | Format-Table -Auto
[/code]

[![screenShotPropertySet2](https://powershellone.files.wordpress.com/2015/03/screenshotpropertyset2.png)](https://powershellone.files.wordpress.com/2015/03/screenshotpropertyset2.png)

The properties displayed when using the 'PSConfiguration' property set are defined in the types.ps1xml file but can be also accessed through Get-Member:

[code language="powershell"]
Get-Process | Get-Member -MemberType PropertySet
[/code]

Property sets can also be added dynamically to any object instance by using Add-Member:

[code language="powershell"]
$ps = Get-Process
$ps | Add-Member -MemberType PropertySet 'Test' ('Path', 'Product', 'Company', 'StartTime')
$ps | select Test
[/code]

Adding a property set to a type is unfortunately not as easy as just calling Update-TypeData, since the MemberType PropertySet is not supported:

[code language="powershell"]
$typeName = (Get-Process).GetType().FullName
Update-TypeData -TypeName $typeName -MemberType PropertySet -MemberName 'Test' -Value $props
Get-Process | select Test -First 5
[/code]

[![screenShotPropertySet6](https://powershellone.files.wordpress.com/2015/03/screenshotpropertyset6.png)](https://powershellone.files.wordpress.com/2015/03/screenshotpropertyset6.png)

That does of course not mean it's impossible, but it involves creating the appropriate type.ps1xml file 'manually':

[code language="powershell"]
function Add-PropertySet{
     <#    
    .SYNOPSIS
        Function to create property sets
    .DESCRIPTION
        Property sets are named groups of properties for certain types that can be used through Select-Object.
        The function adds a new property set to a type via a types.ps1xml file.
	.PARAM inputObject
		The object or collection of objects where the property set is added
	.PARAM propertySetName
		The name of the porperty set
	.EXAMPLE
		$fileName = dir | Add-PropertySet Testing ('Name', 'LastWriteTime', 'CreationTime')
        dir | Get-Member -MemberType PropertySet
        dir | select Testing
        #add this to the profile to have the property set available in all sessions
        Update-TypeData -PrependPath $fileName
	.EXAMPLE
		Get-Process | Add-PropertySet RAM ('Name', 'PagedMemorySize', 'PeakWorkingSet')
        Get-Process | select RAM
    #>
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline=$true,Mandatory=$true)]
        $inputObject,
    
        [Parameter(Mandatory=$true,Position=0)]
        $propertySetName,

        [Parameter(Mandatory=$true,Position=1)]
        $properties
    )
    $propertySetXML = "<Types>`n"
    $groupTypes = $input | group { $_.PSTypeNames[0] } -AsHashTable
    foreach ($entry in $groupTypes.GetEnumerator()) {
        $typeName = $entry.Key
        $propertySetXML += @"
    <Type>
        <Name>$typeName</Name>
        <Members>
            <PropertySet>
                <Name>$propertySetName</Name>
                <ReferencedProperties>
                    $($properties | foreach { 
                        "<Name>$_</Name>"    
                    })
                </ReferencedProperties>
            </PropertySet>
        </Members>
    </Type>
"@
    } 
    $propertySetXML += "`n</Types>"
    $xmlPath = Join-Path (Split-Path $profile.CurrentUserCurrentHost)  ($propertySetName + '.types.ps1xml')
    ([xml]$propertySetXML).Save($xmlPath)    
    Update-TypeData -PrependPath $xmlPath
    $xmlPath
}
[/code]

With Add-PropertySet property sets can also be easily added to types:

[code language="powershell"]
Get-Process | Add-PropertySet RAM ('Name', 'PagedMemorySize', 'PeakWorkingSet')
Get-Process | select RAM -First 3 | Format-Table -Auto
Get-Process | Get-Member -MemberType PropertySet
[/code]

[![screenShotPropertySet7](https://powershellone.files.wordpress.com/2015/03/screenshotpropertyset72.png)](https://powershellone.files.wordpress.com/2015/03/screenshotpropertyset72.png)

The property set is by default only available for the current PowerShell session. In order to have the property set available for every session the Update-TypeData call with the return value from the Add-PropertySet function (the types.ps1xml are created within the same directory as the profile and prefixed with the propertySetName) needs to be added to the profile:

[code language="powershell"]
#add this to your profile
Update-TypeData -PrependPath PATHRETURNEDFROMADD-PROPERTYSET
[/code]

Add-PropertySet including full help can be download from [my GitHub repository](https://github.com/DBremen/PowerShellScripts/blob/master/functions/Add-PropertySet.ps1).

![shareThoughts](https://powershellone.files.wordpress.com/2015/10/sharethoughts.jpg)


* * *


photo credit: [Happy Lazy Saturday](http://www.flickr.com/photos/41864721@N00/3708696947) via [photopin](http://photopin.com) [(license)](https://creativecommons.org/licenses/by-nc-sa/2.0/)
