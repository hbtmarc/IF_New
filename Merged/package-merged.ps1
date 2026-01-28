param(
  [string]$Source = (Split-Path -Parent $MyInvocation.MyCommand.Path),
  [string]$OutZip = (Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Path) 'Merged.zip')
)

if (Test-Path $OutZip) { Remove-Item -Force $OutZip }
Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::CreateFromDirectory($Source, $OutZip)
Write-Host "Package created: $OutZip"
