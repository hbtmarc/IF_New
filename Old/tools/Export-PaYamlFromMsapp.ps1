[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$MsappPath,

    [Parameter(Mandatory = $true)]
    [string]$RepoPath,

    [string]$TargetSrc = "canvas\\Src"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Resolve-FullPath {
    param([string]$Path)
    return (Resolve-Path -LiteralPath $Path).Path
}

if (-not (Test-Path -LiteralPath $MsappPath -PathType Leaf)) {
    throw "MsappPath not found: $MsappPath"
}

if (-not (Test-Path -LiteralPath $RepoPath -PathType Container)) {
    throw "RepoPath not found: $RepoPath"
}

$repoFull = Resolve-FullPath -Path $RepoPath
$targetRoot = Join-Path $repoFull $TargetSrc
if (-not (Test-Path -LiteralPath $targetRoot -PathType Container)) {
    New-Item -ItemType Directory -Force -Path $targetRoot | Out-Null
}

$tempRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("pa_yaml_" + [System.Guid]::NewGuid().ToString("N"))
$tempZip = Join-Path $tempRoot "app.zip"
$extractRoot = Join-Path $tempRoot "extracted"

New-Item -ItemType Directory -Path $tempRoot, $extractRoot -Force | Out-Null

try {
    Copy-Item -LiteralPath $MsappPath -Destination $tempZip -Force
    Expand-Archive -Path $tempZip -DestinationPath $extractRoot -Force

    $sourcePath = $null
    $priority1 = Join-Path $extractRoot "src\\Src"
    if (Test-Path -LiteralPath $priority1 -PathType Container) {
        $sourcePath = $priority1
    }

    if (-not $sourcePath) {
        $priority2 = Join-Path $extractRoot "src"
        if (Test-Path -LiteralPath $priority2 -PathType Container) {
            $hasYaml = Get-ChildItem -LiteralPath $priority2 -Filter *.pa.yaml -File -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
            if ($hasYaml) {
                $sourcePath = $priority2
            }
        }
    }

    if (-not $sourcePath) {
        $appYaml = Get-ChildItem -LiteralPath $extractRoot -Filter "App.pa.yaml" -File -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($appYaml) {
            $sourcePath = $appYaml.DirectoryName
        }
    }

    if (-not $sourcePath) {
        Write-Error "App.pa.yaml not found in extracted package. Extracted root: $extractRoot"
        $topEntries = Get-ChildItem -LiteralPath $extractRoot -Force | Select-Object -First 20 -ExpandProperty Name
        if ($topEntries) {
            Write-Host "Top-level entries:"
            $topEntries | ForEach-Object { Write-Host " - $_" }
        }
        throw "Unable to locate .pa.yaml source directory."
    }

    if ($sourcePath.EndsWith([System.IO.Path]::DirectorySeparatorChar) -or $sourcePath.EndsWith([System.IO.Path]::AltDirectorySeparatorChar)) {
        $sourcePath = $sourcePath.TrimEnd([System.IO.Path]::DirectorySeparatorChar, [System.IO.Path]::AltDirectorySeparatorChar)
    }

    $componentSource = Join-Path $sourcePath "Component"
    if (Test-Path -LiteralPath $componentSource -PathType Container) {
        $componentTarget = Join-Path $targetRoot "Component"
        if (-not (Test-Path -LiteralPath $componentTarget -PathType Container)) {
            New-Item -ItemType Directory -Force -Path $componentTarget | Out-Null
        }
    }

    $files = Get-ChildItem -LiteralPath $sourcePath -Filter *.pa.yaml -File -Recurse -ErrorAction SilentlyContinue
    if (-not $files) {
        throw "No .pa.yaml files found under source path: $sourcePath"
    }

    $copied = New-Object System.Collections.Generic.List[string]
    foreach ($file in $files) {
        $relative = $file.FullName.Substring($sourcePath.Length).TrimStart([System.IO.Path]::DirectorySeparatorChar, [System.IO.Path]::AltDirectorySeparatorChar)
        $destPath = Join-Path $targetRoot $relative
        $destDir = Split-Path -Parent $destPath
        if (-not (Test-Path -LiteralPath $destDir -PathType Container)) {
            New-Item -ItemType Directory -Force -Path $destDir | Out-Null
        }
        Copy-Item -LiteralPath $file.FullName -Destination $destPath -Force
        $copied.Add($relative)
    }

    Write-Host "Copied files:"
    foreach ($rel in ($copied | Sort-Object)) {
        Write-Host " - $rel"
    }
    Write-Host ("Total: {0}" -f $copied.Count)
}
finally {
    if (Test-Path -LiteralPath $tempRoot) {
        Remove-Item -LiteralPath $tempRoot -Recurse -Force
    }
}
