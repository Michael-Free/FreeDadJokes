<#
.SYNOPSIS
Retrieves and displays a random dad joke from a predefined API.

.DESCRIPTION
The Get-DadJoke function fetches a random dad joke from a hardcoded API endpoint
(official-joke-api.appspot.com) and displays it in a readable format.
It first tests the API availability using Test-JokeAPI, then retrieves the joke
using Request-DadJoke. The joke is output as two separate lines: setup and punchline.

.PARAMETER None
This function does not accept any parameters.

.INPUTS
None. You cannot pipe input to this function.

.OUTPUTS
System.String
Outputs two strings to the pipeline: the joke setup followed by the punchline.

.EXAMPLE
PS C:\> Get-DadJoke
Why don't scientists trust atoms?
Because they make up everything!

This example shows the basic usage of Get-DadJoke.

.EXAMPLE
PS C:\> $jokeLines = Get-DadJoke
PS C:\> $jokeLines[0]
Why don't scientists trust atoms?
PS C:\> $jokeLines[1]
Because they make up everything!

This example captures the output as an array of strings.

.NOTES
Author: Michael Free
Date Created: February 10, 2024
Module Name: FreeDadJokes

DEPENDENCIES:
- This function depends on Test-JokeAPI and Request-DadJoke functions.
- Ensure both dependent functions are loaded before using Get-DadJoke.

API INFORMATION:
- Uses: https://official-joke-api.appspot.com/random_joke
- This is a free, no-authentication-required API.
- The API returns JSON with 'setup' and 'punchline' properties.

ERROR HANDLING:
- The function will throw an error if either Test-JokeAPI or Request-DadJoke fails.
- Consider adding a fallback mechanism or cached jokes for offline scenarios.
#>
function Get-DadJoke {
  $dadJokeApi = 'https://official-joke-api.appspot.com/random_joke'

  # Test-JokeAPI returns $true/$false, it doesn't throw
  if (Test-JokeAPI -Uri $dadJokeApi) {
    try {
      $dadJoke = Request-DadJoke -Uri $dadJokeApi
      Write-Output "$($dadJoke.Setup)"
      Write-Output "$($dadJoke.Punchline)"
    }
    catch {
      throw "Request-Dadjoke Error: $($_.Exception.Message)"
    }
  }
  else {
    # Test-JokeAPI returned $false, but we don't have an exception here
    throw 'Test-JokeAPI error: API endpoint is unavailable or returned non-200 status code'
  }
}
