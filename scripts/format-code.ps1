# Copyright (c) eBPF for Windows contributors
# SPDX-License-Identifier: MIT

# Simple code formatting script using clang-format

param(
    [switch]$Staged,
    [switch]$Quiet,
    [switch]$WhatIf,
    [string[]]$Files = @()
)

$root = git rev-parse --show-toplevel
if ($LASTEXITCODE -ne 0) {
    Write-Error "Not in a git repository"
    exit 1
}

# Check if clang-format is available
try {
    $clangFormatVersion = clang-format --version
    if (-not $Quiet) {
        Write-Host "Using: $clangFormatVersion"
    }
} catch {
    Write-Error "clang-format not found. Please install LLVM/Clang."
    exit 1
}

# Get files to format
$filesToFormat = @()
if ($Staged) {
    # Get staged files
    $stagedFiles = git diff --cached --name-only --diff-filter=ACMR
    foreach ($file in $stagedFiles) {
        if ($file -match '\.(c|cpp|h)$') {
            $filesToFormat += $file
        }
    }
} elseif ($Files.Count -gt 0) {
    # Use provided files
    foreach ($file in $Files) {
        if ($file -match '\.(c|cpp|h)$') {
            $filesToFormat += $file
        }
    }
} else {
    # Get all C/C++ files in the repository
    $allFiles = git ls-files
    foreach ($file in $allFiles) {
        if ($file -match '\.(c|cpp|h)$') {
            $filesToFormat += $file
        }
    }
}

if ($filesToFormat.Count -eq 0) {
    if (-not $Quiet) {
        Write-Host "No C/C++ files to format."
    }
    exit 0
}

$formattingNeeded = $false
foreach ($file in $filesToFormat) {
    $fullPath = Join-Path $root $file
    if (Test-Path $fullPath) {
        if ($WhatIf) {
            # Check if formatting would change the file
            $formatted = clang-format $fullPath
            $original = Get-Content $fullPath -Raw
            if ($original -ne $formatted) {
                $formattingNeeded = $true
                if (-not $Quiet) {
                    Write-Host "Would format: $file"
                }
            }
        } else {
            # Apply formatting
            clang-format -i $fullPath
            if (-not $Quiet) {
                Write-Host "Formatted: $file"
            }
        }
    }
}

if ($WhatIf -and $formattingNeeded) {
    exit 1
}

exit 0