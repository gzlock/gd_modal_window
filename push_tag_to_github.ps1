# 推送最后的 tag 到远程
$lastTag = git describe --tags --abbrev=0
git push origin $lastTag