# Builds dist/fable-skill.zip — the uploadable claude.ai skill package.
# Run from anywhere: powershell -NoProfile -ExecutionPolicy Bypass -File claude-web-skill/build.ps1

$ErrorActionPreference = "Stop"
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$repo = Split-Path -Parent $here
$stage = Join-Path $env:TEMP "fable-skill-stage"
$dest = Join-Path $stage "fable"

if (Test-Path $stage) { Remove-Item -Recurse -Force $stage }
New-Item -ItemType Directory -Force $dest | Out-Null

Copy-Item (Join-Path $here "SKILL.md") $dest
Copy-Item (Join-Path $repo "FABLE-MODE.md") $dest
Copy-Item (Join-Path $repo "FABLE-MODE-MINI.md") $dest
Copy-Item -Recurse (Join-Path $repo "FABLE-PACKS") (Join-Path $dest "FABLE-PACKS")
Copy-Item -Recurse (Join-Path $repo "FABLE-EXAMPLES") (Join-Path $dest "FABLE-EXAMPLES")

$out = Join-Path $repo "dist"
New-Item -ItemType Directory -Force $out | Out-Null
$zip = Join-Path $out "fable-skill.zip"
if (Test-Path $zip) { Remove-Item -Force $zip }

# Compress-Archive stores Windows-style backslash separators in zip entry
# names, which violates the ZIP spec and gets rejected by claude.ai's skill
# uploader ("Zip file contains path with invalid characters"). Build the
# archive directly with System.IO.Compression so entries use forward slashes.
Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem
$zipStream = [System.IO.File]::Open($zip, [System.IO.FileMode]::Create)
$archive = [System.IO.Compression.ZipArchive]::new($zipStream, [System.IO.Compression.ZipArchiveMode]::Create)
Get-ChildItem -Path $stage -Recurse -File | ForEach-Object {
    $relativePath = $_.FullName.Substring($stage.Length + 1).Replace('\', '/')
    [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($archive, $_.FullName, $relativePath, [System.IO.Compression.CompressionLevel]::Optimal) | Out-Null
}
$archive.Dispose()
$zipStream.Dispose()

Remove-Item -Recurse -Force $stage
Write-Host "Built: $zip"
Write-Host "Upload it at claude.ai -> Settings -> Capabilities -> Skills -> Upload skill."
