<#
.SYNOPSIS
Retrieves a dad joke from the specified API endpoint.

.DESCRIPTION
The Request-DadJoke function calls a dad joke API and returns a structured joke object.
The function validates the API response to ensure it contains the expected 'setup' and 'punchline' properties.
If the API call fails or returns an unexpected format, the function returns $false and writes an error.

.PARAMETER Uri
The API endpoint URL to request the dad joke from. This parameter is mandatory.

.PARAMETER Timeout
The timeout duration in seconds for the web request. Default is 30 seconds.

.INPUTS
None. You cannot pipe input to this function.

.OUTPUTS
System.Management.Automation.PSCustomObject
Returns a custom object with 'Setup' and 'Punchline' properties if successful.

System.Boolean
Returns $false if the API call fails or returns an unexpected format.

.EXAMPLE
PS C:\> $joke = Request-DadJoke -Uri "https://official-joke-api.appspot.com/random_joke"
PS C:\> $joke

Setup      : Why don't scientists trust atoms?
Punchline  : Because they make up everything!

This example retrieves a random dad joke from the specified API.
This is the only API this has been tested on.

.EXAMPLE
PS C:\> $joke = Request-DadJoke -Uri "https://invalid-api.example.com/"
Requesting Dad Joke Error: Unable to connect to the remote server

This example shows what happens when the API endpoint is unreachable.

.NOTES
Author: Michael Free
Date Created: February 10, 2024
Module Name: FreeDadJokes
#>
function Request-DadJoke {
  [CmdletBinding()]
  [OutputType([PSCustomObject], ParameterSetName = 'Success')]
  [OutputType([System.Boolean], ParameterSetName = 'Failure')]
  param(
    [Parameter(Mandatory = $false)]
    [string]$Uri,

    [Parameter(Mandatory = $false)]
    [int]$Timeout = 30
  )

  if (-not $Uri) {
    throw [System.ArgumentException]::new('Uri parameter is required. You must provide an API endpoint URL to test.')
  }

  try {
    Write-Verbose "Requesting Joke API endpoint: $Uri"

    $params = @{
      Uri         = $Uri
      Method      = 'GET'
      TimeoutSec  = $Timeout
      ErrorAction = 'Stop'
    }

    $dadJoke = Invoke-RestMethod @params

    if ($null -eq $dadJoke) {
      Write-Error "Requesting Dad Joke Error: setup and punchline objects unavailable in response from $Uri (response was null)"
      return $false
    }

    $hasSetup = $dadJoke.PSObject.Properties.Name -contains 'setup'
    $hasPunchline = $dadJoke.PSObject.Properties.Name -contains 'punchline'

    if (-not $hasSetup -or -not $hasPunchline) {
      Write-Error "Requesting Dad Joke Error: setup and punchline objects unavailable in response from $Uri"
      return $false
    }

    Write-Verbose "setup and punchline objects found in response from $Uri"

    $dadJokeObject = [PSCustomObject]@{
      Setup     = $dadJoke.setup
      Punchline = $dadJoke.punchline
    }

    return $dadJokeObject
  }
  catch [System.Net.WebException] {
    if ($_.Exception.Response -and $_.Exception.Response.StatusCode -eq [System.Net.HttpStatusCode]::NotFound) {
      Write-Error 'Requesting Dad Joke Error: Joke API endpoint returned 404 Not Found. The joke endpoint may be unavailable.'
      return $false
    }
    else {
      Write-Error "Requesting Dad Joke Error: $($_.Exception.Message)"
      return $false
    }
  }
  catch {
    Write-Error "Requesting Dad Joke Error: $($_.Exception.Message)"
    return $false
  }
}
