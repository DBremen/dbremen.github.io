function build ($NotebookName,$Title, $Excerpt){
    $parentFolder = $path = $PSScriptRoot
    Push-Location $parentFolder
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

build AutoExtract.ipynb "Use PowerShell to monitor a folder and extract downloaded .zip files" "Use PowerShell to monitor a download folder as a background task and smartly extract .zip files automatically as you download them."