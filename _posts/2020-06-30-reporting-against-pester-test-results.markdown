---
author: dirkbremen
comments: true
date: 2016-05-18 09:47:18+00:00
layout: post
link: https://powershellone.wordpress.com/2016/05/18/reporting-against-pester-test-results/
slug: reporting-against-pester-test-results
title: Reporting against Pester test results
wordpress_id: 1107
categories:
- PowerShell
---

![26464648144_721725d757_m](https://powershellone.files.wordpress.com/2016/05/26464648144_721725d757_m.jpg)
[Pester](https://github.com/pester/Pester/wiki/Pester) is (for very good reasons) getting more and more popular. If you don't know about Pester I would highly recommend you to start using it. Here are some good resources to learn about the framework:
	



  * [Test-Driven Development with Pester (June Blender) ](https://youtu.be/gssAtCeMOoo?list=PLDCEho7foSoruQ-gL5GJw-lRkASPJOukl)

	
  * [Pester in Action Part 1: Pester Basics ](https://www.youtube.com/watch?v=0h6mradGhYI)

	
  * [PowerShellMagazine articles about Pester](http://www.powershellmagazine.com/tag/pester/)



In this post, I assume that you have already some previous experience using Pester. Most of the articles and videos about Pester I've seen so far, do not go into much details about reporting on test results from Pester. Let's first see what the result could look like: 

![ReportUnitScreen](https://powershellone.files.wordpress.com/2016/05/reportunitscreen.png)
The screenshot above shows the output from [ReportUnit](http://relevantcodes.com/reportunit/), which can take the Pester NUnit XML output and turn it into a very nice HTML report.
Ok, having seen what could be done, we take a step back and see what is possible using the built-in Pester capabilities. Let's create some dummy functions and tests first:
[code language="powershell"]
$tempFolder = New-Item "$env:Temp\PesterTest" -ItemType Directory -force
foreach ($num in (1..10)){
    $functionTemplate =  @"
function Test$num {
    $num
}
"@ | Set-Content -Path (Join-Path $tempFolder "Test$num.ps1")
    $testTemplate = @"
`$here = Split-Path -Parent `$MyInvocation.MyCommand.Path
`$sut = (Split-Path -Leaf `$MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "`$here\`$sut"
Describe "Test$num" {
    It "Should output $num" {
        $(if ($Num -eq 8){
        "Test$num | Should Be 9"
        }else{
        "Test$num | Should Be $num"
        })
    }
}
"@ | Set-Content -Path (Join-Path $tempFolder "Test$num.Tests.ps1")
}
[/code]
With a few liens of code we created a folder (PesterTest) within the temp directory that contains 10 script files (Test1 - Test10.ps1) including a simple function that outputs a number in correspondence to the script number. We also created a very basic test against each script file which tests whether the function's output is correct. For good measure I've also added a bug into the Test8.ps1 script. 
Running Invoke-Pester against the folder without any additional arguments results in the default console output for Pester:

![PesterConsoleOutput](https://powershellone.files.wordpress.com/2016/05/pesterconsoleoutput.png)
While this looks nice, it's not good enough if you want to run this unattended/automated or if you have a very long list of tests in your test-suite. Using the '-PassThru' switch Parameter will make Pester return a rich object containing the detailed test results and also a lot of contextual information (error message, environment, stacktrace....) in addition to the console output:
[code language="powershell"]
$testResults = Invoke-Pester -PassThru
#display overall test-suite results
$testResults
#display specific tests within test suite
$testResults.TestResult
[/code]


![PesterObject](https://powershellone.files.wordpress.com/2016/05/pesterobject.png)
Pester can even do better, using the 'OutputFile' and 'OutputFormat' the result is turned into an XML in NUnit compatible format. The .xml file can be imported into tools like TeamCity in order to view test results in a human readable way. For people without access to full-fledged development tools, there is [ReportUnit](http://relevantcodes.com/reportunit/) an open source command line tool that automatically transforms the XML into a nice HTML report (see screenshot at the top of the post). Let's use PowerShell to download and extract ReportUnit.exe and run it against an output file generated by Pester:
[code language="PowerShell"]
#run the test-suite and generate the NUnit output file
Push-Location $tempFolder
Invoke-Pester -OutputFile report.xml -OutputFormat NUnitXml

#download and extract ReportUnit.exe
$url = 'http://relevantcodes.com/Tools/ReportUnit/reportunit-1.2.zip'
$fullPath = Join-Path $tempFolder $url.Split("/")[-1]
(New-Object Net.WebClient).DownloadFile($url,$fullPath)
(New-Object -ComObject Shell.Application).Namespace($tempFolder.FullName).CopyHere((New-Object -ComObject Shell.Application).Namespace($fullPath).Items(),16)
del $fullPath

#run reportunit against report.xml and display result in browser
& .\reportunit.exe report.xml
ii report.html
[/code]

Happy testing!

![shareThoughts](https://powershellone.files.wordpress.com/2015/10/sharethoughts.jpg)



* * *



Photo Credit: [Photosightfaces](https://www.flickr.com/photos/30595068@N06/26464648144/) via [Compfight](http://compfight.com) [cc](https://creativecommons.org/licenses/by-nc-sa/2.0/)
