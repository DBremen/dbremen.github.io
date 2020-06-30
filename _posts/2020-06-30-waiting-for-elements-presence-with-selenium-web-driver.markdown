---
author: dirkbremen
comments: true
date: 2015-02-12 22:39:17+00:00
layout: post
link: https://powershellone.wordpress.com/2015/02/12/waiting-for-elements-presence-with-selenium-web-driver/
slug: waiting-for-elements-presence-with-selenium-web-driver
title: Waiting for elements presence with Selenium Web driver
wordpress_id: 17
categories:
- PowerShell
tags:
- web automation
---

[![tree3](https://powershellone.files.wordpress.com/2015/02/5901654605_cf104d5f37_m.jpg)](https://powershellone.files.wordpress.com/2015/02/5901654605_cf104d5f37_m.jpg)

[Selenium](http://www.seleniumhq.org/) is a great way to automate browsers for testing or scraping purposes. One thing that is missing when using the driver via PowerShell is an easy way to specify an explicit wait for methods on the driver. This is useful if you would like to call a method on an element but don't know whether the element has been loaded yet:

[code language="powershell" highlight="9"]
#load the web driver dll
Add-Type -path c:\WebDriver.dll
#initiate a driver
$script:driver = New-Object OpenQA.Selenium.Chrome.ChromeDriver
#specify an implicit wait interval
$null = $driver.Manage().Timeouts().ImplicitlyWait((New-TimeSpan -Seconds 5))
#browse to a website
$driver.Url = 'https://www.google.com'
$driver.FindElementByName('q')
#potential error message if element hasn't been loaded yet
$driver.Close()
$driver.Dispose()
$driver.Quit()
[/code]

One workaround would be to just adding a 'sleep 10', but this is not a very elegant solution. Since we also don't know for how long to wait. Another approach (probably also not the most elegant solution, but the best that I came up with so far. It turns out that there actually is another probably more elegant approach available (see below for more details)) is to use a little helper function like this:

[code language="powershell"]
function isElementPresent($locator,[switch]$byClass,[switch]$byName){
    try{
        if($byClass){
            $null=$script:driver.FindElementByClassName($locator)
        }
        elseif($byName){
            $null=$script:driver.FindElementByName($locator)
        }
        else{
            $null=$script:driver.FindElementById($locator)
        }
        return $true
    }
    catch{
        return $false
    }
}
[/code]
There is another approach available using the webdriver's built-in capabilities. With this, one can specify a time in seconds the webdriver will wait for the element's presence before throwing an exception (openqa.selenium.TimeoutException):
[code language="powershell"]

function waitForElement($locator, $timeInSeconds,[switch]$byClass,[switch]$byName){
    #this requires the WebDriver.Support.dll in addition to the WebDriver.dll
    Add-Type -Path C:\WebDriver.Support.dll
    $webDriverWait = New-Object OpenQA.Selenium.Support.UI.WebDriverWait($script:driver, $timeInSeconds)
    try{
        if($byClass){
            $null = $webDriverWait.Until([OpenQA.Selenium.Support.UI.ExpectedConditions]::ElementIsVisible( [OpenQA.Selenium.by]::ClassName($locator)))
        }
        elseif($byName){
            $null = $webDriverWait.Until([OpenQA.Selenium.Support.UI.ExpectedConditions]::ElementIsVisible( [OpenQA.Selenium.by]::Name($locator)))
        }
        else{
            $null = $webDriverWait.Until([OpenQA.Selenium.Support.UI.ExpectedConditions]::ElementIsVisible( [OpenQA.Selenium.by]::Id($locator)))
        }
        return $true
    }
    catch{
        return "Wait for $locator timed out"
    }
}
[/code]

With this in place we can more or less avoid unnecessary wait time and also the potential for error when trying to access an element that is not loaded yet:

[code language="powershell" light="true" highlight="1,2,3,4"]
while(!(isElementPresent 'q' -byName)){
    sleep 1
}
$driver.FindElementByName('q')
[/code]
or 
[code language="powershell" light="true" highlight="1"]
waitForElement 'q' 10 -byName
[/code]

![shareThoughts](https://powershellone.files.wordpress.com/2015/10/sharethoughts.jpg)


* * *


photo credit: [I paint my own reality](http://www.flickr.com/photos/33363480@N05/5901654605) via [photopin](http://photopin.com) [(license)](https://creativecommons.org/licenses/by-nc-sa/2.0/)
