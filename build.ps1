function build ($NotebookName,$Title, $Excerpt){
    $parentFolder = $path = $PSScriptRoot
    Push-Location $parentFolder
    $nbFilePath = Join-Path $parentFolder $NoteBookName
    #remove the unnecessary script parts that .net interactive notebooks adds
    $json = Get-Content $nbFilePath | convertfrom-json
    $codeCells = $json.cells.where{$_.cell_type -eq 'Code'}
    $codeCells.foreach{
	    try{
		    $_.outputs[0].data.psobject.properties.Remove('text/html')
	    }catch{}
    }
    $json | convertto-json -depth 100 | Set-Content $nbFilePath
    (Get-Content $nbFilePath -Raw).Replace("`r`n","`n") | Set-Content $nbFilePath -Force
    #for random unicode chars that nb2md complains about
    $text = Get-Content $nbFilePath -Raw
    $char = [char]0x9d
    $text = $text -replace $char,''
    $Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
    [System.IO.File]::WriteAllLines($nbFilePath, $text, $Utf8NoBomEncoding)
    nbdev_nb2md $NotebookName | Out-String
    $mdName = ([IO.Path]::ChangeExtension($NotebookName,'md'))
    $markdownFilePath = Join-Path $parentFolder $mdName
    $text = Get-Content $markdownFilePath  -Raw
    $imgPath = Join-Path (Split-Path $markdownFilePath) ([System.IO.Path]::GetFileNameWithoutExtension($markdownFilePath))
    $images = dir ($imgPath + '_files\att_[0-9]*.png')
    foreach ($image in $images){
        $toReplace = [regex]::Match($text,'!\[image\.png]\(attachment:[0-9a-f]{8}-.*\.png\)').Value
        $newPath = (Split-path (Split-path $image.FullName) -leaf) + '/' + ($image.Name)
        $replacement = '![image.png](' + $newPath + ')'
        $text = $text.Replace($toReplace, $replacement)
    }
    $text = $text -replace '^(!.*]\()(\w+_files/)', '$1/images/$2'
    $text = [regex]::replace($text, '^(!.*\]\()(\w+_files/)','$1/images/$2','Multiline')
    $slug = @"
---
title: "$Title"
excerpt: "$Excerpt"
tags: 
  - code
  - powershell
---
"@
    $slug | Set-Content $markdownFilePath
    $text | Add-Content $markdownFilePath -NoNewline
    $newName = (Get-Date).ToString('yyyy-MM-dd') + '-' + $mdName
    move $markdownFilePath "$parentFolder\_posts\$newName"
    move ("$parentFolder\" + $NotebookName.replace('.ipynb','') + "_files") "$parentFolder\images"
    del $NotebookName
}

build graphtheory2.ipynb "Graph theory with PowerShell - part 2" "This is part two of 'Graph theory with PowerShell', focussing on 'Small World Graphs', with PowerShell based on (Chapter 3) of the execellent book Think Complexity 2e by Allen B. Downey."