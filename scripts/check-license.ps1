# Copyright (c) eBPF for Windows contributors
# SPDX-License-Identifier: MIT

# This script checks files for required license headers

param(
    [string[]]$Files = @()
)

$license = @(
    "Copyright (c) eBPF for Windows contributors",
    "SPDX-License-Identifier: MIT"
)

$root = git rev-parse --show-toplevel
if ($LASTEXITCODE -ne 0) {
    Write-Error "Not in a git repository"
    exit 1
}

# Read ignore patterns
$ignoreFile = Join-Path $root "scripts" ".check-license.ignore"
$ignorePatterns = @()
if (Test-Path $ignoreFile) {
    Get-Content $ignoreFile | ForEach-Object {
        $line = $_.Trim()
        if ($line -and -not $line.StartsWith("#")) {
            $ignorePatterns += $line
        }
    }
}

function Should-Ignore($file) {
    foreach ($pattern in $ignorePatterns) {
        if ($file -match $pattern) {
            return $true
        }
    }
    return $false
}

# Get files to check
$filesToCheck = @()
if ($Files.Count -gt 0) {
    foreach ($file in $Files) {
        if (Test-Path $file) {
            $relativePath = Resolve-Path $file -Relative
            $relativePath = $relativePath -replace "^\.\\", ""
            if (-not (Should-Ignore $relativePath)) {
                $filesToCheck += $relativePath
            }
        }
    }
} else {
    # Get all files tracked by Git
    $gitFiles = git ls-files
    foreach ($file in $gitFiles) {
        if (-not (Should-Ignore $file)) {
            $filesToCheck += $file
        }
    }
}

$failures = 0
foreach ($file in $filesToCheck) {
    $fullPath = Join-Path $root $file
    if (Test-Path $fullPath) {
        $firstFourLines = Get-Content $fullPath -Head 4
        $content = $firstFourLines -join "`n"
        
        $hasAllLicenseLines = $true
        foreach ($licenseLine in $license) {
            if ($content -notmatch [regex]::Escape($licenseLine)) {
                $hasAllLicenseLines = $false
                break
            }
        }
        
        if (-not $hasAllLicenseLines) {
            Write-Host $file
            $failures++
        }
    }
}

exit $failures