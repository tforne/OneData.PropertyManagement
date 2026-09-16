[CmdletBinding()]
param(
    [switch]$Force,
    [string]$CompilerPath
)

$ErrorActionPreference = 'Stop'

$packageVersion = '1.1.0'
$targetFramework = 'net8.0'
$alLanguageExtensionVersion = '17.0.2273547'
$repositoryRoot = Split-Path -Parent $PSScriptRoot
$outputDirectory = Join-Path $repositoryRoot '.alcops'
$packageUri = "https://api.nuget.org/v3-flatcontainer/alcops.analyzers/$packageVersion/alcops.analyzers.$packageVersion.nupkg"
$stagingDirectory = Join-Path ([System.IO.Path]::GetTempPath()) ("alcops-" + [System.Guid]::NewGuid())
$archivePath = Join-Path $stagingDirectory 'alcops.analyzers.nupkg'
$extractDirectory = Join-Path $stagingDirectory 'extracted'
$compilerDependencyName = 'Microsoft.Dynamics.Nav.Analyzers.Common.dll'

if (Test-Path -LiteralPath $outputDirectory) {
    if (-not $Force) {
        throw "ALCops is already restored at '$outputDirectory'. Re-run with -Force to restore it again."
    }

    Remove-Item -Recurse -Force -LiteralPath $outputDirectory
}

try {
    New-Item -ItemType Directory -Path $stagingDirectory | Out-Null
    Invoke-WebRequest -Uri $packageUri -OutFile $archivePath
    [System.IO.Compression.ZipFile]::ExtractToDirectory($archivePath, $extractDirectory)

    $analyzerSource = Join-Path $extractDirectory "lib\\$targetFramework"
    if (-not (Test-Path -LiteralPath $analyzerSource)) {
        throw "The ALCops package $packageVersion does not contain analyzers for $targetFramework."
    }

    New-Item -ItemType Directory -Path $outputDirectory | Out-Null
    Copy-Item -Path (Join-Path $analyzerSource '*') -Destination $outputDirectory -Recurse

    if ($CompilerPath) {
        $dependencyCandidates = Get-ChildItem -LiteralPath $CompilerPath -Recurse -File -Filter $compilerDependencyName
    }
    else {
        $extensionDirectory = Join-Path $env:USERPROFILE ".vscode\\extensions\\ms-dynamics-smb.al-$alLanguageExtensionVersion"
        $dependencyCandidates = Get-ChildItem -LiteralPath $extensionDirectory -Recurse -File -Filter $compilerDependencyName
    }

    if (@($dependencyCandidates).Count -ne 1) {
        throw "Expected exactly one $compilerDependencyName. Provide -CompilerPath pointing to the AL compiler directory."
    }

    Copy-Item -LiteralPath $dependencyCandidates[0].FullName -Destination $outputDirectory
    Set-Content -LiteralPath (Join-Path $outputDirectory 'version.txt') -Value $packageVersion -NoNewline

    Write-Host "Restored ALCops $packageVersion ($targetFramework) to $outputDirectory"
}
finally {
    if (Test-Path -LiteralPath $stagingDirectory) {
        Remove-Item -Recurse -Force -LiteralPath $stagingDirectory
    }
}
