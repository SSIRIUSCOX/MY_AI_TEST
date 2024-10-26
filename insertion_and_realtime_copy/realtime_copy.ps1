$sourceFile = "E:\AIdrawing\图片结果及参数\实验\实验.md"
$destinationFile = "E:\AIdrawing\图片结果及参数\实验\实验_realtime_copy.md"

# 检查源文件是否存在
if (-Not (Test-Path $sourceFile)) {
    Write-Host "源文件不存在"
    exit
}

# 如果目标文件不存在，则创建它
if (-Not (Test-Path $destinationFile)) {
    New-Item -Path $destinationFile -ItemType File -Force
    Write-Host "目标文件已创建：$destinationFile"
}

# 设置上次修改时间
$lastWriteTime = (Get-Item $sourceFile).LastWriteTime

while ($true) {
    # 获取当前文件的最后修改时间
    $currentWriteTime = (Get-Item $sourceFile).LastWriteTime

    # 如果文件被修改，复制内容
    if ($currentWriteTime -ne $lastWriteTime) {
        Copy-Item $sourceFile $destinationFile -Force
        $lastWriteTime = $currentWriteTime
        Write-Host "已复制内容到 $destinationFile"
    }

    # 暂停一段时间，避免过于频繁的检查
    Start-Sleep -Seconds 5
}
