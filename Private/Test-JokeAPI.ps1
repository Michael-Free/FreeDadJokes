<#
.SYNOPSIS
Tests the availability and responsiveness of a dad joke API endpoint.

.DESCRIPTION
The Test-JokeAPI function performs a HEAD request to verify if a dad joke API endpoint is reachable and responsive.
It checks for HTTP status code 200 to determine if the API is available. This function is useful for validating
API endpoints before making actual joke requests.

.PARAMETER Uri
The API endpoint URL to test. This parameter is mandatory.

.PARAMETER Timeout
The timeout duration in seconds for the web request. Default is 30 seconds.

.INPUTS
None. You cannot pipe input to this function.

.OUTPUTS
System.Boolean
Returns $true if the API endpoint is reachable and returns HTTP status 200.
Returns $false if the API is unreachable, times out, or returns an error status.

.EXAMPLE
PS C:\> Test-JokeAPI -Uri "https://official-joke-api.appspot.com/random_joke"
True

This example tests if the dad joke API endpoint is available.

.EXAMPLE
PS C:\> Test-JokeAPI -Uri "https://icanhazdadjoke.com/" -Timeout 10 -Verbose
VERBOSE: Testing Joke API endpoint: https://icanhazdadjoke.com/
VERBOSE: API responded with status code: 200
VERBOSE: Joke API is available and responding
True

This example tests the API with a 10-second timeout and shows verbose output.

.EXAMPLE
PS C:\> $apiStatus = Test-JokeAPI -Uri "https://invalid-api.example.com/"
Joke API Route Unavailable: Unable to connect to the remote server
PS C:\> $apiStatus
False

This example shows the function returns $false when the API endpoint is unreachable.

.NOTES
Author: Michael Free
Date Created: February 10, 2024
Module Name: FreeDadJokes
#>
function Test-JokeAPI {
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param(
        [Parameter(Mandatory=$false)]
        [string]$Uri,

        [Parameter(Mandatory=$false)]
        [int]$Timeout = 30
    )

    if (-not $Uri) {
        throw [System.ArgumentException]::new("Uri parameter is required. You must provide an API endpoint URL to test.")
    }

    try {
        Write-Verbose "Testing Joke API endpoint: $Uri"

        $params = @{
            Uri = $Uri
            Method = 'HEAD'
            UseBasicParsing = $true
            TimeoutSec = $Timeout
            ErrorAction = 'Stop'
        }

        $response = Invoke-WebRequest @params
        Write-Verbose "API responded with status code: $($response.StatusCode)"

        if ($response.StatusCode -ne 200) {
            throw "Joke API returned unexpected status code: $($response.StatusCode)"
        }

        Write-Verbose "Joke API is available and responding"
        return $true
    }
    catch {
        Write-Error "Joke API Route Unavailable: $($_.Exception.Message)"
        return $false
    }
}
