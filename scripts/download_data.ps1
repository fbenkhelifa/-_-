$ErrorActionPreference = 'Stop'

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot '..')
$rawRoot = Join-Path $repoRoot 'data\raw'
$tmpRoot = Join-Path $repoRoot '.tmp\downloads'

function Ensure-Directory {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    if (-not (Test-Path $Path)) {
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
    }
}

function Download-And-ExtractDataset {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Slug,
        [Parameter(Mandatory = $true)]
        [string]$WorkingDir
    )

    Ensure-Directory -Path $WorkingDir

    $existingZips = @()
    if (Test-Path $WorkingDir) {
        $existingZips = @(Get-ChildItem -Path $WorkingDir -File -Filter *.zip | Select-Object -ExpandProperty FullName)
    }

    Write-Host "Downloading Kaggle dataset: $Slug"
    kaggle datasets download -d $Slug -p $WorkingDir --force | Out-Null

    $allZips = @(Get-ChildItem -Path $WorkingDir -File -Filter *.zip)
    $newZip = $allZips |
        Where-Object { $existingZips -notcontains $_.FullName } |
        Sort-Object LastWriteTime -Descending |
        Select-Object -First 1

    if ($null -eq $newZip) {
        $newZip = $allZips | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    }

    if ($null -eq $newZip) {
        throw "No zip archive found after downloading '$Slug'."
    }

    $extractDir = Join-Path $WorkingDir ([System.IO.Path]::GetFileNameWithoutExtension($newZip.Name))
    if (Test-Path $extractDir) {
        Remove-Item -Path $extractDir -Recurse -Force
    }

    Expand-Archive -Path $newZip.FullName -DestinationPath $extractDir -Force
    return $extractDir
}

if (-not (Get-Command kaggle -ErrorAction SilentlyContinue)) {
    throw 'Kaggle CLI not found. Install it and configure ~/.kaggle/kaggle.json first.'
}

Ensure-Directory -Path $tmpRoot
Ensure-Directory -Path (Join-Path $rawRoot 'twitter')
Ensure-Directory -Path (Join-Path $rawRoot 'credit-score')
Ensure-Directory -Path (Join-Path $rawRoot 'weather-dataset')

# 1) Twitter sentiment files
$twitterExtract = Download-And-ExtractDataset -Slug 'jp797498e/twitter-entity-sentiment-analysis' -WorkingDir $tmpRoot
foreach ($fileName in @('twitter_training.csv', 'twitter_validation.csv')) {
    $sourceFile = Get-ChildItem -Path $twitterExtract -Recurse -File |
        Where-Object { $_.Name -ieq $fileName } |
        Select-Object -First 1

    if ($null -eq $sourceFile) {
        throw "Could not find '$fileName' in twitter dataset archive."
    }

    Copy-Item -Path $sourceFile.FullName -Destination (Join-Path $rawRoot "twitter\$fileName") -Force
}

# 2) Credit score notebook input
$creditExtract = Download-And-ExtractDataset -Slug 'parisrohan/credit-score-classification' -WorkingDir $tmpRoot
$creditTrain = Get-ChildItem -Path $creditExtract -Recurse -File |
    Where-Object { $_.Name -ieq 'train.csv' } |
    Select-Object -First 1

if ($null -eq $creditTrain) {
    throw "Could not find 'train.csv' in credit-score dataset archive."
}

Copy-Item -Path $creditTrain.FullName -Destination (Join-Path $rawRoot 'credit-score\train.csv') -Force

# 3) Weather image notebook input
$weatherExtract = Download-And-ExtractDataset -Slug 'jehanbhathena/weather-dataset' -WorkingDir $tmpRoot
$weatherDatasetDir = Get-ChildItem -Path $weatherExtract -Recurse -Directory |
    Where-Object { $_.Name -eq 'dataset' } |
    Select-Object -First 1

if ($null -eq $weatherDatasetDir) {
    throw "Could not find the 'dataset' directory in weather dataset archive."
}

$weatherTarget = Join-Path $rawRoot 'weather-dataset\dataset'
if (Test-Path $weatherTarget) {
    Remove-Item -Path $weatherTarget -Recurse -Force
}

Copy-Item -Path $weatherDatasetDir.FullName -Destination $weatherTarget -Recurse -Force

Write-Host 'Dataset bootstrap complete.'
Write-Host "Twitter files: $(Join-Path $rawRoot 'twitter')"
Write-Host "Credit train.csv: $(Join-Path $rawRoot 'credit-score\train.csv')"
Write-Host "Weather image folder: $weatherTarget"