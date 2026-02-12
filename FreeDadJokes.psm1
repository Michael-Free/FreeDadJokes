<#
.SYNOPSIS
Free Dad Jokes on the Powershell command-line!

.DESCRIPTION
This is one of the silliest powershell modules I have ever built. It was built during naptimes when I was on paternity leave...

With this module, you'll be able to scale eye-rolling, groan-inducing jokes at a scale that was never possible before!

.PARAMETER None
This module script does not accept parameters directly. Functions within the module have their own parameters.

.INPUTS
None. This module script does not accept pipeline input.

.OUTPUTS
None. This module script outputs the module manifest and exports functions.

.EXAMPLE
PS C:\> Import-Module .\FreeDadJokes.psm1
PS C:\> Get-DadJoke
Why don't scientists trust atoms?
Because they make up everything!

This example shows how to import the module and use the Get-DadJoke function.

.NOTES
Author: Michael Free
Date Created: February 10, 2024
Module Name: FreeDadJokes

FUNCTIONS:
- Get-DadJoke     : Gets and displays a dad joke

DEPENDENCIES:
- PowerShell 5.1 or later
- Internet access for API calls
- No additional modules required

API SUPPORT:
The module currently supports:
- https://official-joke-api.appspot.com/random_joke (default)
#>

foreach ($folder in @('Private', 'Public')) {
  $root = Join-Path -Path $PSScriptRoot -ChildPath $folder
  if (Test-Path -Path $root) {
    Write-Verbose "processing folder $root"
    $files = Get-ChildItem -Path $root -Filter '*.ps1'
    $files | Where-Object { $_.Name -notlike '*.Tests.ps1' } |
      ForEach-Object {
        Write-Verbose "Dot-sourcing $($_.Name)"
        . $_.FullName
      }
  }
}
$exportedFunctions = (Get-ChildItem -Path (Join-Path $PSScriptRoot 'Public') -Filter '*.ps1').BaseName
Export-ModuleMember -Function $exportedFunctions

foreach ($folder in @('Private', 'Public')) {
  $root = Join-Path -Path $PSScriptRoot -ChildPath $folder
  if (Test-Path -Path $root) {
    Write-Verbose "processing folder $root"
    $files = Get-ChildItem -Path $root -Filter '*.ps1'
    $files | Where-Object { $_.Name -notlike '*.Tests.ps1' } |
      ForEach-Object {
        Write-Verbose "Dot-sourcing $($_.Name)"
        . $_.FullName
      }
  }
}
$exportedFunctions = (Get-ChildItem -Path (Join-Path $PSScriptRoot 'Public') -Filter '*.ps1').BaseName
Export-ModuleMember -Function $exportedFunctions

