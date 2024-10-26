
# 设置文件夹路径和输出Markdown文件名
$folderPath = "E:\AIdrawing\图片结果及参数\实验\shiyan2\2024-10-26" # 图片文件夹路径
$mdFilePath = "E:\AIdrawing\图片结果及参数\实验\实验.md" # 输出的Markdown文件路径
$relativePath=".\shiyan2\2024-10-26"

# 获取文件夹内的所有图片文件，按名称排序
$imageFiles = Get-ChildItem -Path $folderPath | Where-Object { $_.Extension -match "\.(jpg|png|gif)$" } | Sort-Object Name

# 读取现有Markdown文件内容
$markdownContent = Get-Content -Path $mdFilePath

# 创建一个新的数组用于存储修改后的行
$newMarkdownContent = @()
$insertPosition = $false
$imageIndex = 0

# 遍历每一行
foreach ($line in $markdownContent) {
    # 检查是否遇到插入标识
    if ($line -like "*KK*") {
        $insertPosition = $true
        Write-Host "检测到插入标识KK！"  # 输出检测到的提示
    }

    # 添加当前行到新的数组中
    $newMarkdownContent += $line

    # 如果处于插入位置且还有图片，则插入图片
    if ($insertPosition -and $imageIndex -lt $imageFiles.Count) {
        $image = $imageFiles[$imageIndex]
        $imageName = $image.Name
        $imagePath = "${relativePath}\${imageName}" # 生成相对路径
        $imageHtml = "<img src=`"$imagePath`" style=`"zoom:25%;`" />" # 生成HTML标签

        # 在最后一行的图片列插入图片
        $newMarkdownContent[-1] = $newMarkdownContent[-1] -replace '\|$', " $imageHtml |" # 在行尾插入图片
        $imageIndex++
    }
}

# 如果还有多余的图片，则作为新的表格行插入
while ($imageIndex -lt $imageFiles.Count) {
    $image = $imageFiles[$imageIndex]
    $imageName = $image.Name
    $imagePath = "${relativePath}\${imageName}" # 生成相对路径
    $imageHtml = "<img src=`"$imagePath`" style=`"zoom:25%;`" />" # 生成HTML标签

    # 插入新的表格行
    $newMarkdownContent += "|  |  |  |  |  | $imageHtml |"
    $imageIndex++
}

# 将修改后的Markdown内容写入文件
Set-Content -Path $mdFilePath -Value $newMarkdownContent

Write-Host "Markdown文件已更新:$mdFilePath"
