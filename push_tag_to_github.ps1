# 读取最后的 tag
try {
    $lastTag = git describe --tags --abbrev=0
    Write-Host "The last tag is: $lastTag"
} catch {
    Write-Host "No tags found in the repository."
    $lastTag = "None"
}

# 等待交互，提示输入版本号，提示内容中包含最后的 tag 以供参考
$version = Read-Host "Enter the version number (e.g., v1.0.0):"

# 验证版本号格式
if (-not $version -or $version -notmatch "^v[0-9]+\\.[0-9]+\\.[0-9]+$") {
    Write-Host "Invalid version number format. Please use the format vX.Y.Z (e.g., v1.0.0)."
    exit 1
}

# 检查是否存在重复的标签
if (git tag --list $version) {
    Write-Host "The tag $version already exists. Please use a different version number."
    exit 1
}

# 创建新的 tag
try {
    git tag $version
    Write-Host "Tag $version created successfully."
} catch {
    Write-Host "Failed to create tag $version."
    exit 1
}

# 推送最后的 tag 到远程
try {
    git push origin $version
    Write-Host "Tag $version pushed to remote successfully."
} catch {
    Write-Host "Failed to push tag $version to remote."
    exit 1
}