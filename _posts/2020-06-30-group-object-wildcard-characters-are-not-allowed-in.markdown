---
author: dirkbremen
comments: true
date: 2015-02-10 23:59:50+00:00
layout: post
link: https://powershellone.wordpress.com/2015/02/10/group-object-wildcard-characters-are-not-allowed-in/
slug: group-object-wildcard-characters-are-not-allowed-in
title: Group-Object "Wildcard characters are not allowed in ..."
wordpress_id: 9
categories:
- PowerShell
tags:
- error
---

[![tree2](https://powershellone.files.wordpress.com/2015/02/8167579865_c9b2a52899_m.jpg)](https://powershellone.files.wordpress.com/2015/02/8167579865_c9b2a52899_m.jpg)

I recently came across a situation where I wanted to group a custom object based on a property that contained a question mark.

[code language="powershell" light="true"]
[PSCustomObject]@{"test?"="test"} |
     group 'test?'
[/code]

Running the above resulted in the error message "group : Wildcard characters are not allowed in "test?".". To make Group-Object work with the property name that contains a wildcard character the property name needs to be escaped either manually by preceding the wildcard character by "`" (e.g. "test`?") or utilizing the related .net method.

[code language="powershell" light="true"]
[PSCustomObject]@{"test?"="test"} |
     group [Management.Automation.WildcardPattern]::Escape('test?'))
[/code]

![shareThoughts](https://powershellone.files.wordpress.com/2015/10/sharethoughts.jpg)


* * *


photo credit: [the tree II](http://www.flickr.com/photos/20375052@N00/8167579865) via [photopin](http://photopin.com) [(license)](https://creativecommons.org/licenses/by-nc-nd/2.0/)
