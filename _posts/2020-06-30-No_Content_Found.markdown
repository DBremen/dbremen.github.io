---
author: dirkbremen
comments: true
date: 2020-06-30 20:47:37.823721
layout: post
link: https://powershellone.wordpress.com/?p=1251
published: false
slug: No Content Found
title: Convert remote time to local time with ArgumentCompleter and ArgumentTransformation
  attributes
wordpress_id: 1251
categories:
- PowerShell
tags:
- write-up
---

![49990561648_48431fa362_e](https://powershellone.files.wordpress.com/2020/06/49990561648_48431fa362_e.jpg)
This article was inspired and is based on the concepts developed by Tobias Weltner (I learned a lot PowerShell concepts from Tobias already) in his excellent series of [posts](https://powershell.one/powershell-internals/attributes/primer) on PowerShell attributes.
I would like to share a function that I have created to be able to convert a date and time from a remote time zone to a local time zone. While the functionality is essentially a one liner it presented a nice use case for utlizing an [ArgumentCompleter attribute](https://docs.microsoft.com/en-us/dotnet/api/system.management.automation.argumentcompleterattribute?view=powershellsdk-7.0.0) and an [ArgumentTransformation attribute](https://powershell.one/powershell-internals/attributes/transformation)
Let's first look at the ArgumentCompleter attribute. The function (ConvertTo-LocalTime) has two Parameters:
<table >

  <tr >
    Name
    Description
  </tr>

<tbody >
  <tr >
    
<td >DateTime
</td>
    
<td >The DateTime to be converted to the local time.
</td>
  </tr>
  <tr >
    
<td >RemoteTimeZone
</td>
    
<td >The time zone for which the provided DateTime should be converted.
</td>
  </tr>
</tbody>
</table>

For the RemoteTimeZone parameter I would like to be able to auto-complete the argument based on a time zone's display name. Where the display names are provided by the (I believe this was introduced in Windows 10) Get-TimeZone function:
![argumentCompleter](https://powershellone.files.wordpress.com/2020/06/argumentcompleter-2.gif)
This can be accomplished with the following piece of code in the Param block (note that an ArgumentCompleter can also be defined in its own class for re-use (see the [article](https://powershell.one/powershell-internals/attributes/custom-attributes#custom-argument-completers) from Tobias on this topic), since this ArgumentCompleter is quite trivial I decided against this, but use the approach further down for the argument transformation attribute.)  of the function:
https://gist.github.com/DBremen/ea32b027dc5c3fe5ace555bbfab1066e
The [ArgumentCompleter attribute](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/register-argumentcompleter?view=powershell-7) expects a ScriptBlock that takes 5 parameters (see line 5) those are used to pass information from the command parser to the ScriptBlock:
<table >

  <tr >
    Name
    Description
  </tr>

<tbody >
  <tr >
    
<td >commandName
</td>
    
<td >This parameter is set to the name of the command for which the script block is providing tab completion.
</td>
  </tr>
  <tr >
    
<td >parameterName
</td>
    
<td >This parameter is set to the parameter whose value requires tab completion.
</td>
  </tr>
<tr >
    
<td >wordToComplete
</td>
    
<td >This parameter is set to value the user has provided before they pressed Tab. Your script block should use this value to determine tab completion values.
</td>
  </tr>
<tr >
    
<td >commandAst
</td>
    
<td >This parameter is set to the Abstract Syntax Tree (AST) for the current input line.
</td>
  </tr>
<tr >
    
<td >fakeBoundParameters
</td>
    
<td >This parameter is set to a hashtable containing the $PSBoundParameters for the cmdlet, before the user pressed Tab.
</td>
  </tr>
</tbody>
</table>

We are only using the argument of the $wordToComplete parameter that represents the current text which is entered when using the function and pressing TAB or CTRL+Space to auto-complete. 
After filtering the time zones based on the provided partial argument (lines 6-8) we just need to return the completion result. The [System.Management.Automation.CompletionResult constructor](https://docs.microsoft.com/en-us/dotnet/api/system.management.automation.completionresult.-ctor?view=powershellsdk-7.0.0) has the following parameters:
<table >

  <tr >
    Name
    Description
  </tr>

<tbody >
  <tr >
    
<td >completionText
</td>
    
<td >the text to be used as the auto completion result
</td>
  </tr>
  <tr >
    
<td >listItemText
</td>
    
<td >The text to be displayed in a list
</td>
  </tr>
<tr >
    
<td >resultType
</td>
    
<td >CompletionResultType
</td>
  </tr>
<tr >
    
<td >toolTip
</td>
    
<td >The text for the tooltip with details to be displayed about the object
</td>
  </tr>
</tbody>
</table>
  
By using the time zone's Id as the completion text and the DisplayName as the listItemText and toolTip arguments, we accomplish a search by the time zone's DisplayName while using the time zone's Id as the actual completion result.
ArgumentCompleter's are super useful to extend the user experience of any Cmdlet. Make sure to read the super detailed and useful [articles](https://powershell.one/powershell-internals/attributes/primer) from Tobias on this topic.
For the DateTime parameter, I would like to be able to provide arguments that PowerShell cannot automatically convert to an [datetime] object. For that, we can use the static [ParseExact](https://docs.microsoft.com/en-us/dotnet/api/system.datetime.parseexact?redirectedfrom=MSDN&view=netframework-4.8#overloads) method of the DateTime object:
https://gist.github.com/DBremen/595a23adfbe876c809397a89f8697952

In order to use this for a parameter within an advanced PowerShell function, we need to define a custom argument transformation attribute (ATA). In comparison to the built-in validation attributes (e.g. [ValidateSet()], [ValidateScript({)],..) that only determine whether the input is valid or not, an ATA attribute can actually turn invalid input into valid input by changing it. Similar to some built-in attributes, custom ATAs can also accept arguments (e.g. [ValidateSet("sun", "moon", "earth")]) 
In the ConvertTo-LocalTime function I want to utilize this to be able to provide additional date format strings representing valid inputs (a bunch of them are just hard-coded inside the function's body). Here is what the custom ATA looks like (again see Tobias' [article](https://powershell.one/powershell-internals/attributes/transformation#custom-transformation-attributes) for a detailed walkthrough):
https://gist.github.com/DBremen/962daf185f2e12900f39ac0349d85132
The new ATA can be used by either adding the class to any script. Or via putting the class into a separate file (either .ps1 or .psm1) and importing it by adding a using statement on the first line of the your script (make sure to read [this](https://jamesone111.wordpress.com/2020/04/02/including-powershell-classes-in-modules-a-quick-round-up/) and [this](https://info.sapien.com/index.php/scripting/scripting-classes/import-powershell-classes-from-modules) article on the gotchas of this approach.) Especially the part mentioned in the first link, where the full name of the class needs to be used, including the "Attribute" suffix, took  me quite a while to figure out. The ATA can be added to any variable definition not only to parameters inside an advanced function. As an example (the example use the class name w/o the Attribute suffix, remember to add this in case you run into problems):
https://gist.github.com/DBremen/a328c26d4461c747a95fedfb9cc3bc56

Here is the full code of the ConvertTo-LocalTimeZone function (it's also part of my [PowerShellScripts](https://github.com/DBremen/PowerShellScripts) repository on GitHub
https://gist.github.com/DBremen/dd44cf02bdc7a0421e0db0d47478dd39



https://powershell.one/powershell-internals/attributes/auto-completion
https://powershell.one/powershell-internals/attributes/custom-attributes


![shareThoughts](https://powershellone.files.wordpress.com/2015/10/sharethoughts.jpg)



* * *



Photo Credit: [Ignacio Ferre](https://www.flickr.com/photos/104656857@N06/49990561648/) Flickr via [Compfight](http://compfight.com) [cc](https://creativecommons.org/licenses/by-nc-nd/2.0/)
