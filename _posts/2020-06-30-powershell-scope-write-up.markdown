---
author: dirkbremen
comments: true
date: 2015-02-22 21:10:20+00:00
layout: post
link: https://powershellone.wordpress.com/2015/02/22/powershell-scope-write-up/
slug: powershell-scope-write-up
title: PowerShell scope write-up
wordpress_id: 42
categories:
- PowerShell
tags:
- write-up
---

[![tree 5](https://powershellone.files.wordpress.com/2015/02/6011915969_f73657ef96_m.jpg)](https://powershellone.files.wordpress.com/2015/02/6011915969_f73657ef96_m.jpg)

I have seen and experienced myself quite some confusion and frustration around the application and understanding of scope using PowerShell. This is an attempt to write up a summary of the different aspects of how PowerShell handles scope which hopefully helps some people to understand it better.

TOC:
Definition and purpose of scope
Lexical vs. dynamic scoping
Types of scope
Scoping rules
Scope modifiers
Dot sourcing
Remote sessions and scope
Modules and scope
Recommendations



## ↑ Definition and purpose of scope


The scope of an object is the region of the program in which it is accessible. All objects have a scope that defines (from) where the name of the object can be used to refer to it.

Scopes help to protect objects from being unintentionally modified and also to avoid the risk of a name collision between two identically named objects.

Within PowerShell the following objects support scope:



	
  * Variables

	
  * Aliases

	
  * Functions

	
  * PowerShell Drives




## ↑ Lexical vs. dynamic scoping


PowerShell uses dynamic scoping as compared to most of the other languages that use lexical scoping. What is the difference? Lexical scope means that the scope is defined by the environment where an object was created. Dynamic scope means to use the environment where the object is called. An example should help to illustrate this:

[code language="powershell"]
$foo = 3
function Out-Foo { $foo }
function Set-Foo{
    $foo = 5
    Out-Foo
}
Out-Foo
Set-Foo
Out-Foo 
[/code]

Running the example in PowerShell will output 3 5 3. Running a similar example within a programming language that is using lexical scoping will output 3 3 3. Lexical scoping treats the foo variable as having only one instance within the global scope. The dynamic scoping in PowerShell makes the modified value of foo that is set within the Set-Foo function available to the Out-Foo function.



## ↑ Types of scope


A new scope is created by:



	
  * running a script or function

	
  * creating a remote session

	
  * or by starting a new instance of PowerShell


When a new scope is created it will act as a child scope of the scope from where it was created. A child scope is created with a set of items. It includes all the items that have the AllScope option plus some variables that can be used to customize the scope, such as MaximumFunctionCount.


### Global


All scopes are child scopes of the global scope (i.e. the mother of all scopes). Global is the scope that is in effect when PowerShell starts including Automatic variables, preference variables and the variables, aliases, and functions that are in the active profile. Items in global scope are visible everywhere.


### Local


Only available in scripts or functions. Default scope for variables and aliases within scripts or functions.


### Script


This scope is created while a script file runs. Items in script scope are visible everywhere inside the script and inside any scripts called within the parent script. Default scope for functions within scripts. Using the script scope modifier permits access to objects in the parent script scope.


### Private


Items in private scope are not visible outside of the current scope. Private scope can be used to create a private version of an item with the same name in another scope. The Option parameter of the New-Variable, New-Alias can be used to set the value of the Option property to Private.


### AllScope


Variables and aliases have an Option property that can take a value of AllScope. Items that have the AllScope property become part of any child scopes. Changes to the item in any scope affect all the scopes in which the variable is defined.


### Numbered Scopes


A scope can be referred to by a number that describes the relative position of one scope to another. Scope 0 represents the current, or local, scope. Scope 1 indicates the immediate parent scope. Scope 2 indicates the parent of the parent scope, and so on.



## ↑ Scoping rules





	
  1. An item included in a scope is visible in the scope in which it was created and in any child scope, unless it is within private scope.

	
  2. The parent scope cannot access variables, which are defined in a child scope.

	
  3. An item created within a scope can be changed only in the scope in which it was created, unless one explicitly specifies a different scope by using a scope modifier. The only exception to this rule are aliases and variables that are created with the AllScope (link) option

	
  4. If you create an item in a scope, and the item shares its name with an item in a different scope, the original item might be hidden under the new item. But, it is not overridden or changed. In other words, if a child scope attempts to modify a parent scope element without using the special syntax, a new element of the same name is created within the child scope, and the child scope effectively “loses” access to the parent scope element of that name.


Some examples:

[code language="powershell"]
#foo has global scope if pasted to the console but script scope if run from within a script
$foo = 'I am global'
function bar { 
  #will read the global foo variable
  $foo 
  #will create a new variable $foo within the local scope since the child scope cannot modify the global foo variable
   $foo = 'I am local to the function'
   #access the local variable
   $foo
}
$foo
bar
$foo
<#output
I am global
I am global
I am local to the function
I am global
#>
[/code]


[code language="powershell" highlight="5"]
$foo = 'I am global'
function bar { 
  $foo 
  #access the global/script scope by using a scope modifier
  $script:foo = 'Me too'
  #same as above using Get-Variable
  Get-Variable foo –Scope Script -ValueOnly
  $foo
}
$foo
bar
$foo
<#output
I am global
I am global
I am global
I am global
I am global
#>
[/code]



## ↑ Scope modifiers


Scope modifiers (global, local, private, and script.) can be used for variables and functions:

[code language="powershell" light="true"]
function private:myFunction {}
$script:myVar
[/code]

To find the items in a particular scope, use the Scope parameter of Get-Variable or Get-Alias. Use Get-Item to get the functions in a particular. Get-Item does not have a scope parameter but it returns all functions within the scope it is called from.



## ↑ Dot sourcing


A script or function can be added to the current scope by using dot sourcing. This will in effect make any functions, aliases, and variables that the script creates available in the current scope.

For example, to run the Sample.ps1 script from the C:\Scripts directory in the local scope, use the following command:
. C:\Scripts\sample.ps1

I would recommend using modules instead of dot sourcing in most of the cases but actually use it myself quite often in order to have a main function at the top of the script:
[code language="powershell"]
Function main {
	Function one
	Function two
}
Function one {
	“helper function”
}
Function two {
	“Another helper function”
}
#dot source the main function in order to make it “see” the other functions
. main
[/code]



## ↑ Remote sessions and scope


A remote session has its own global scope, but a session is not a child scope of the session in which it was created. Child scopes within a remote session can be created by running a script.
To pass on an “external” variable into a remote session scriptBlock the $using qualifier can be utilized:
[code language="powershell"]
$foo = ‘test’
Invoke-Command –ComputerName bar	{
  $dir = 'c:\' + $using:foo
  Get-ChildItem	 $dir
}
[/code]



## ↑ Modules and scope


Variables and Aliases in a module are by default not accessible outside the module (This can be controlled using Export-ModuleMember). The privacy of a module behaves like a scope, but adding a module to a session does not change the scope. And, the module does not have its own scope, although the scripts in the module do have their own scope. 



### Visibility


The Visibility property of a variable or alias determines whether it can be seen outside the container, such as a module, in which it was created. Visibility works for containers in the same way that the Private value of the Option property works for scopes.
The Visibility property takes can be set to either Private or Public. Items that have private visibility can be viewed and changed only in the container in which they were created. Because Visibility is designed for containers, it works differently in a scope. If you create an item that has private visibility in the global scope, you cannot view or change the item in any scope. If you try to view or change the value of a variable that has private visibility, Windows PowerShell returns an error message.
One can use the New-Variable and Set-Variable cmdlets to create a  variable that has private visibility.



## ↑ Recommendations


1. Try to avoid using scope modifiers in order to modify items in a parent scope.
  a. Better pass the item into a function through an argument by reference
  [code language="powershell"]
$foo = 'some value'
function bar ([ref]$myFoo){
    #instead of $script:foo = 'new value'
    $myFoo.Value = 'new value'
}
$foo
bar ([ref]$foo)
$foo

<#output
some value
new value
#>
[/code]
2.  Use Set-Strict in order to prohibit references to uninitialized variables (see Get-Help Set-StrictMode for details)
3.  Use modules instead of dot sourcing (see .dot sourcing for an exception)

![shareThoughts](https://powershellone.files.wordpress.com/2015/10/sharethoughts.jpg)


* * *


photo credit: [Standing out from the Crowd.](http://www.flickr.com/photos/30880820@N07/6011915969) via [photopin](http://photopin.com) [(license)](https://creativecommons.org/licenses/by-nc-sa/2.0/)
