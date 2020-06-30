---
author: dirkbremen
comments: true
date: 2015-03-12 06:49:33+00:00
layout: post
link: https://powershellone.wordpress.com/2015/03/12/how-to-convert-excel-97-03-xls-to-new-format-xlsx-using-office-file-converter-ofc-exe/
slug: how-to-convert-excel-97-03-xls-to-new-format-xlsx-using-office-file-converter-ofc-exe
title: How to convert Excel 97-03 (.xls) to new format (.xlsx) using office file converter
  (ofc.exe)
wordpress_id: 155
categories:
- Excel
- PowerShell
---

[![tree13](https://powershellone.files.wordpress.com/2015/03/14392657138_d873870bd8_m.jpg)](https://powershellone.files.wordpress.com/2015/03/14392657138_d873870bd8_m.jpg)

Usually one would use something like the code below in order to convert Excel 97-03 (.xls) files to the new format (.xlsx) via PowerShell through the Excel COM Interop interface:
[code language="powershell"]
function Remove-ComObject {
 # Requires -Version 2.0
 [CmdletBinding()]
 param()
 end {
         Start-Sleep -Milliseconds 500
         [Management.Automation.ScopedItemOptions]$scopedOpt = 'ReadOnly, Constant'
         Get-Variable -Scope 1 | where {
             $_.Value.PSTypenames -contains 'System.__ComObject' -and -not ($scopedOpt -band $_.Options)
         } | Remove-Variable -Scope 1 -Verbose:([Bool]$PSBoundParameters['Verbose'].IsPresent)
         [GC]::Collect()
     }
}

function Convert-XLStoXLSX($inputXLS, [switch]$keep){
	Add-Type -AssemblyName Microsoft.Office.Interop.Excel
	$xlFormat=[Microsoft.Office.Interop.Excel.XLFileFormat]::xlWorkbookDefault
	#remove old output file if existent
	$outputXLSX=[IO.Path]::ChangeExtension($inputXLS,'xlsx')
	if (test-path "$outputXLSX"){Remove-Item "$outputXLSX" -Force}
	$xl = New-Object -com "Excel.Application"
	$xl.displayalerts = $False 
        $xl.ScreenUpdating = $False
	$wb = $xl.workbooks.open($inputXLS) 
	$ws = $wb.worksheets.Item(1)
	$wb.SaveAs($outputXLSX,$xlFormat) 
	$wb.Close()
	$xl.Quit()
	Remove-ComObject
        if (!$keep){
	     Remove-Item $inputXLS -Force
        }
}
[/code]

In my case since I've switched to Excel 2013 the above method (and actually all excel automation via COM Interop) is much slower than compared to Excel 2010. This caused me to look for alternative methods on how to automatically convert Excel files from the old format to the new format. The first promising candidate I found was excelcnv.exe, which comes as part of the office installation and can be found under 'C:\Program Files (x86)\Microsoft Office\Office14' (replace 14 with the appropriate version number). This is a tool to convert between old and new Excel format and vice versa. Here are some lines of PowerShell that utilize excelcnv.exe:
[code language="powershell"]
function ConvertTo-XLSX($xlsFile){
    $xlsxFile = [IO.PATH]::ChangeExtension($xlsFile,'xlsx')
    Start-Process -FilePath 'C:\Program Files (x86)\Microsoft Office\Office14\excelcnv.exe' -ArgumentList "-nme -oice ""$xlsxFile"" ""$xlsFile"""
}
#usage
ConvertTo-XLSX "$env:USERPROFILE\Desktop\Book1.xls"
[/code]
While this converted the file successfully it also popped up a dialog after running it to convert multiple files that Excel did not launch correctly and asking whether to start in SafeMode. Not really something I was willing to accept.
The next option I came across was the Office File Converter (ofc.exe) which comes as part of [Office Migration Planning Manager](http://www.microsoft.com/en-ie/download/details.aspx?id=11454) (OMPM). It requires you to install the [Microsoft Office Compatibility Pack for Word, Excel, and PowerPoint File Formats](https://www.microsoft.com/en-us/download/details.aspx?id=33298). Ofc.exe can be used to convert any of the older office formats (i.e. ppt, doc, xls) to the new format details about the usage can be found [here](https://technet.microsoft.com/en-us/library/cc179019%28v=office.14%29.aspx). The settings are controlled via an .ini file (ofc.ini). For my purpose I wanted it to convert all .xls files in a folder of my choice to .xlsx keeping the same file name and using the same folder without having to manually modify the .ini file for every conversion.
Those are the steps to setup ofc.exe to do just that through a PowerShell script:



	
  1. Download and install the [Microsoft Office Compatibility Pack for Word, Excel, and PowerPoint File Formats](http://www.microsoft.com/en-us/download/details.aspx?id=3)

        
  2. Download [OMPM](http://www.microsoft.com/en-ie/download/details.aspx?id=11454)

        
  3. Extract the OMPM download (comes as a self extracting archive)

        
  4. Copy the 'Tools' folder to a location of your choice (the script assumes C:\Scripts\ps1)

        
  5. Optionally: Rename the file ofc.ini in the Tools folder to something else (e.g. ofc_default.ini in order to keep it as a reference


Having the setup described above in place allows us to use PowerShell to create the .ini with the appropriate settings on the fly in order to instruct ofc.exe to copy the files .xlsx to the same folder along with some other default settings. The .xls files are deleted unless the -keep switch is used.:
[code language="powershell"]
function ConvertTo-XLSX($xlsFolder, [switch]$keep){
    $ofcFolder = 'C:\Scripts\ps1\Tools'
    $xlsxFile = [IO.PATH]::ChangeExtension($xlsFile,'xlsx')
@"
[RUN]
LogDestinationPath=$env:Temp
TimeOut=300
[ConversionOptions]
FullUpgradeOnOpen=1
MacroControl=0
CABLogs=1
[FoldersToConvert]
fldr=$xlsFolder
[ConversionInfo]
SourcePathTemplate=$('*\' * $xlsFolder.Split('\').Count)
DestinationPathTemplate=$xlsFolder
"@ | Out-File "$ofcFolder\ofc.ini"
    & "$ofcFolder\ofc.exe" "$ofcFolder\ofc.ini"
    if (!$keep){
        Get-ChildItem "$xlsFolder\*.xls" -recurse | Remove-Item
    }
}
[/code]
The conversion through ofc.exe runs faster on my system than using the COM interop method, in addition, ofc also has the ability to convert office files within nested folder structures up to 10 level deep.

![shareThoughts](https://powershellone.files.wordpress.com/2015/10/sharethoughts.jpg)


* * *


Photo Credit: [x1klima](https://www.flickr.com/photos/69743899@N07/14392657138/) via [Compfight](http://compfight.com) [cc](https://creativecommons.org/licenses/by-nd/2.0/)
