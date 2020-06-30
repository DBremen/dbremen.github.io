---
author: dirkbremen
comments: true
date: 2015-03-09 11:11:56+00:00
layout: post
link: https://powershellone.wordpress.com/2015/03/09/powershell-format-table-views/
slug: powershell-format-table-views
title: PowerShell Format-Table Views
wordpress_id: 138
categories:
- PowerShell
tags:
- format
---

[![trere11](https://powershellone.files.wordpress.com/2015/03/7541170982_4df678da07_m.jpg)](https://powershellone.files.wordpress.com/2015/03/7541170982_4df678da07_m.jpg)

Format views are defined inside the *format.ps1xml files and represent named sets of properties per type which can be used with any of the Format-* cmdlets. In this post I will focus mainly on the views for the Format-Table cmdlet:

[code language="powershell"]
Get-Process | select -Last 5 | Format-Table
Get-Process | select -Last 5 | Format-Table -View StartTime
[/code]

[![screenShotFormatView1](https://powershellone.files.wordpress.com/2015/03/screenshotformatview1.png)](https://powershellone.files.wordpress.com/2015/03/screenshotformatview1.png) Retrieving the format views for a particular type can be accomplished by pulling out the information from the respective XML files like so:

[code language="powershell"]
function Get-FormatView{
[CmdletBinding()]
param(
[Parameter(Mandatory=$true,
ValueFromPipeline=$true,
Position=0)]
$TypeName
)
$formatFiles = dir $psHome -Filter *.format.ps1xml
if ($TypeName -isnot [string]){
$TypeName = $Input[0].PSObject.TypeNames[0]
}
$formatTypes = $formatFiles |
Select-Xml //ViewSelectedBy/TypeName |
where { $_.Node.'#text' -eq $TypeName }

foreach ($ft in $formatTypes) {
$formatType = $ft.Node.SelectSingleNode('../..')
$props = $formatType.Name, ($formatType | Get-Member -MemberType Property | where Name -like '*Control').Name
$formatType | select @{n='Name';e={$props[0]}},
@{n='Type';e={'Format View'}},
@{n='Cmdlet';e={'Format-' + $props[1].Replace('Control','')}}

}
}
[/code]

With this function the existing format views (for any of the Format-* cmdlets) can be easily discovered:

[code language="powershell"]
Get-Process | Get-FormatView | Format-Table -Auto
[/code]

Creating a new Format-Table view can be done using the Add-FormatTableView function defined below:

[code language="powershell"]
function Add-FormatTableView {
[CmdletBinding()]
param (
[Parameter(ValueFromPipeline=$true,Mandatory=$true)]
$inputObject,

[Parameter(Position=0)]
$Label,

[Parameter(Mandatory=$true,Position=1)]
$Property,

[Parameter(Position=2)]
[int]$Width=20,

[Parameter(Position=3)]
[Management.Automation.Alignment] $Alignment = 'Undefined',

[Parameter(Position=4)]
$ViewName = 'TableView'
)
$typeNames = $input | group { $_.PSTypeNames[0] } -NoElement | select -ExpandProperty Name
$table = New-Object Management.Automation.TableControl
$row = New-Object Management.Automation.TableControlRow
$index = 0
foreach ($prop in $property){
if ($Label.Count -lt $index+1){
$currLabel = $prop
}
else{
$currLabel = $Label[$index]
}
if ($Width.Count -lt $index+1){
$currWidth = @($Width)[0]
}
else{
$currWidth = $Width[$index]
}
if ($Alignment.Count -lt $index+1){
$currAlignment = @($Alignment)[0]
}
else{
$currAlignment = $Alignment[$index]
}
$col = New-Object Management.Automation.TableControlColumn $currAlignment, (New-Object Management.Automation.DisplayEntry $prop, 'Property')
$row.Columns.Add($col)
$header = New-Object Management.Automation.TableControlColumnHeader $currLabel, $currWidth, $currAlignment
$table.Headers.Add($header)
$index++
}
$table.Rows.Add($row)
$view = New-Object System.Management.Automation.FormatViewDefinition $ViewName, $table
foreach ($typeName in $typeNames){
$typeDef = New-Object System.Management.Automation.ExtendedTypeDefinition $TypeName
$typeDef.FormatViewDefinition.Add($view)
[Runspace]::DefaultRunspace.InitialSessionState.Formats.Add($typeDef)
}
$xmlPath = Join-Path (Split-Path $profile.CurrentUserCurrentHost)  ($ViewName + '.format.ps1xml')
Get-FormatData -TypeName $TypeNames | Export-FormatData -Path $xmlPath
Update-FormatData -PrependPath $xmlPath
$xmlPath
}
[/code]

Add-TableFormatView can be used to create custom table format views (you guessed it):

[code language="powershell"]
$fileName = Get-Process | Add-FormatTableView -Label ProcName, PagedMem, PeakWS -Property 'Name', 'PagedMemorySize', 'PeakWorkingSet' -Width 40 -Alignment Center -ViewName RAM
Get-Process | Format-Table -View RAM
#add this to the profile to have the format view available in all sessions
#Update-FormatData -PrependPath $fileName
[/code]

[![screenShotFormatTableView3](https://powershellone.files.wordpress.com/2015/03/screenshotformattableview3.png)](https://powershellone.files.wordpress.com/2015/03/screenshotformattableview3.png) This creates a custom format table view for the System.Diagnostics.Process type. The function determines the typename(s) based on the objects piped into it. Some details about the other parameters:



	
  * The Label property is optional if there is no label provided for a property the property name is used for the label.

	
  * The Width property is also optional and defaults to 20.

	
  * The Alginment can be defined per column/property or for all columns if only one alignment is specified, the default Alignment is 'Undefined'.

	
  * If the ViewName is not specified it defaults to 'TableView'. 'TableView' determine the default output format for the type (if no default is available) this can be handy to customize the output for custom objects.



The usage of the 'TableView' view name to modify custom object default output deserves another example:
[code language="powershell"]
#create a custom object array
$arr = @()
$obj = [PSCustomObject]@{FirstName='Jon';LastName='Doe'}
#add a custom type name to the object
$typeName = 'YouAreMyType'
$obj.PSObject.TypeNames.Insert(0,$typeName)
$arr += $obj
$obj = [PSCustomObject]@{FirstName='Pete';LastName='Smith'}
$obj.PSObject.TypeNames.Insert(0,$typeName)
$arr += $obj
$obj.PSObject.TypeNames.Insert(0,$typeName)
#add a default table format view
$arr | Add-FormatTableView -Label 'First Name', 'Last Name' -Property FirstName, LastName -Width 30 -Alignment Center
$arr 
#when using the object further down in the pipeline the property name must be used
$arr  | where "LastName" -eq 'Doe'
[/code]
[![screenShotFormatTableView4](https://powershellone.files.wordpress.com/2015/03/screenshotformattableview4.png)](https://powershellone.files.wordpress.com/2015/03/screenshotformattableview4.png)
This can come in handy for custom object output since the output is still an object and not a format it can be used further down the pipeline (using the property name and not the label).

Get-FromatView and Add-FormatTableView can be downloaded from my [GitHub repository](https://github.com/DBremen/PowerShellScripts).

![shareThoughts](https://powershellone.files.wordpress.com/2015/10/sharethoughts.jpg)


* * *


Photo Credit: [jDevaun.Photography](https://www.flickr.com/photos/34316967@N04/7541170982/) via [Compfight](http://compfight.com) [cc](https://creativecommons.org/licenses/by-nd/2.0/)
