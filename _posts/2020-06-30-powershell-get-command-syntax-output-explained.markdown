---
author: dirkbremen
comments: true
date: 2018-07-25 12:21:28+00:00
layout: post
link: https://powershellone.wordpress.com/2018/07/25/powershell-get-command-syntax-output-explained/
slug: powershell-get-command-syntax-output-explained
title: PowerShell Get-Command -Syntax output explained
wordpress_id: 1176
categories:
- PowerShell
tags:
- write-up
---

![40490984595_5e5a1461b6](https://powershellone.files.wordpress.com/2018/07/40490984595_5e5a1461b6.jpg)

In this post, I would like to provide a detailed explanation of the Get-Command -Syntax output. While the output is [documented](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_command_syntax?view=powershell-6) (the format used is actually called a syntax diagram) I found parts of it rather confusing.  

As an example throughout this post, we will use the output of the command:
[code language="powershell"]
Get-Command Select-Object -Syntax
[/code]
![GetCommandSyntax](https://powershellone.files.wordpress.com/2018/07/getcommandsyntax.png)
The output looks quite cryptic and terse (maybe even intimidating). I promise that you will (most likely) prefer this dense output over the more verbose output from Get-Help for Cmdlets you already know but just don't remember the exact syntax if you stick around until the end of this post.

Ok, as a first step we might want to make the output a bit more readable. I copied this from [Staffan Gustafsson](https://github.com/powercode) while watching the recording of his [excellent presentation on the Extended Type System](https://www.youtube.com/watch?v=DzjoJ-FiKTA&list=PLDCEho7foSor-XbwECkqpvAuyQ0CZFI9_&index=25) during the European 2018 PowerShell Conference. Staffan's idea is to split and indent the -Syntax output using regular expressions (If you read through the end your reward is a more advanced version of this):
[code language="powershell"]
(Get-Command -syntax Select-Object) -split ' (?=\[*-)' -replace '^[\[-]',  '   $0'
[/code]
![GetCommandSyntax2](https://powershellone.files.wordpress.com/2018/07/getcommandsyntax2.png)
Nice! This looks already much less scary. 
Now let's work through the details. Why do we see three separate outputs for one Cmdlet? While I don't want to go into all the nitty gritty details about this sub-topic here and now, I would like to say as much as that those three outputs represent three separate Parameter-Sets. Parameter-Sets enable control over which parameters can be used together and allow you to write a Cmdlet that can perform different actions for different scenarios (where each scenario is covered by a separate Parameter-Set). Some good resources on Parameter-Sets can be found [here](https://docs.microsoft.com/en-us/powershell/developer/cmdlet/cmdlet-parameter-sets), [here](https://www.jonathanmedd.net/2013/01/add-a-parameter-to-multiple-parameter-sets-in-powershell.html), and [here](https://mikefrobbins.com/2018/02/22/adding-multiple-parameter-sets-to-a-powershell-function/).

Looking at the first syntax line of the first Parameter-Set within the Select-Object output.:
![GetCommandSyntax3](https://powershellone.files.wordpress.com/2018/07/getcommandsyntax31.png)





  * The whole line describes the syntax of a **parameter.**

	
  * "Property" is the **parameter name**. Parameter names are always preceded by hyphens (same as if you use the Cmdlet).

	
  * The part of the syntax surrounded by angle brackets ("**<**Object []**>**") represents a **parameter value**. A parameter value is a placehholder for the input that the parameter takes. Parameter values are represented by their ([.NET](https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/keywords/built-in-types-table)) type (when using the Cmdlet you need to provide an actual **argument** in place of the .Net type). The brackets after the type name "<Object **[]**>" qualify the type as an [array](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_arrays?view=powershell-6) type.

	
  * Whole parameters and/or parameters names can be mandatory or optional.

	
  * A parameter (name + value)  surrounded by brackets indicates an optional parameter. All of Select-Object's parameters are optional.

[code language="powershell"]
#works just fine
Get-Process | Select-Object
[/code]
	
  * A parameter name (in addition to the brackets around the parameter or only) surrounded by brackets indicates an optional parameter. An optional parameter means that the parameter can be either used by position (omitting the Parameter and letting PowerShell use the position of the arguments to assign the values to parameters) or by name.
[code language="powershell"]
#by position (0)
Get-Process | Select-Object Handles
#and by name both work
Get-Process | Select-Object -Property Handles
[/code]
	
  * The parameters are listed in the order of their position (i.e. first positional parameter comes before the second positional parameter).
	
  * Parameters that do not accept input (i.e. have no parameter value) represent switch parameters.


In general there are 4 + 1 (for a Switch) possible variations:
<table style="border:1px solid black;" >
  <tr >
    #
    Syntax
    Description
  </tr>
  <tr >
    
<td style="border:1px solid black;padding:5px;" >1
</td>
    
<td style="border:1px solid black;padding:5px;" >[[-PARAMNAME] ]
</td>
    
<td style="border:1px solid black;padding:5px;" >An optional parameter that can be used by position or name.
</td>
  </tr>
  <tr >
    
<td style="border:1px solid black;padding:5px;" >2
</td>
    
<td style="border:1px solid black;padding:5px;" >[-PARAMNAME ]
</td>
    
<td style="border:1px solid black;padding:5px;" >An optional parameter that can only be used by name.
</td>
  </tr>
  <tr >
    
<td style="border:1px solid black;padding:5px;" >3
</td>
    
<td style="border:1px solid black;padding:5px;" >[-PARAMNAME] 
</td>
    
<td style="border:1px solid black;padding:5px;" >A required parameter that can be used by position or name.
</td>
  </tr>
  <tr >
    
<td style="border:1px solid black;padding:5px;" >4
</td>
    
<td style="border:1px solid black;padding:5px;" >-PARAMNAME 
</td>
    
<td style="border:1px solid black;padding:5px;" >A required parameter that can be used only by name:
</td>
  </tr>
  <tr >
    
<td style="border:1px solid black;padding:5px;" >5
</td>
    
<td style="border:1px solid black;padding:5px;" >[PARAMNAME]
</td>
    
<td style="border:1px solid black;padding:5px;" >A switch parameter (switches are always optional and can only be used by name)
</td>
  </tr>
</table>

Applying the above to the first line of Select-Object's syntax translates:
[[-Property]] 
into:



	
  * "Property" is an optional parameter

	
  * Its parameter name is also optional (works by name and position)

	
  * The position of the parameter is 0 (the first unnammed argument to the Cmdlet will be assigned to this parameter



You can double-check this by using Get-Help:
[code language="powershell"]
Get-Help Select-Object -Parameter Property
[/code]
And finally here is the code for the syntax "prettifier":
https://gist.github.com/5a9d2e300ae4534977e55e5f7b0240cc




![shareThoughts](https://powershellone.files.wordpress.com/2015/10/sharethoughts.jpg)



* * *



Photo Credit: [Jyrki Salmi](https://www.flickr.com/photos/47089990@N02/40490984595/) Flickr via [Compfight](http://compfight.com) [cc](https://creativecommons.org/licenses/by-nc-sa/2.0/)
