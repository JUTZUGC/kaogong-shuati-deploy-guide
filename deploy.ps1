# 考公刷题 一键部署脚本（第三方指南）——按官方文档封装
# 官方文档：https://github.com/ERRRC/kaogong-shuati#readme
# 更新日期：2026-10-31
# 类型：script
$ErrorActionPreference = 'Stop'
Set-Location -Path $PSScriptRoot

if (-not (Get-Command git -ErrorAction SilentlyContinue)) { throw '需要先安装 Git' }
if (-not (Get-Command node -ErrorAction SilentlyContinue)) { throw '需要先安装 Node.js' }

New-Item -ItemType Directory -Force -Path .download | Out-Null
Set-Location -Path .download

git clone https://github.com/ERRRC/kaogong-shuati.git
Set-Location kaogong-shuati
node tools/reassemble-tiku.mjs
node server.mjs 3000
Write-Host "已启动：浏览器打开本地 3000 端口的刷题页"

Write-Host ''
$url = 'http://localhost:3000'
Write-Host "等待服务启动：$url"
$ready = $false
for ($i = 0; $i -lt 30; $i++) {
  try {
    Invoke-WebRequest -UseBasicParsing -Uri $url -TimeoutSec 3 | Out-Null
    $ready = $true
    break
  } catch {
    Start-Sleep -Seconds 2
  }
}
if (-not $ready) { throw "60 秒内未探测到 $url，请手动打开确认或查看日志" }
Write-Host '服务已就绪'
Write-Host '部署完成，浏览器访问 http://localhost:3000'
Write-Host '若结果异常或需要改配置，请参考官方文档：https://github.com/ERRRC/kaogong-shuati#readme'
