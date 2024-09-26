function Get-DadJoke() {
  <#
  .SYNOPSIS
      Get a Random Dad Joke on the command line.

  .DESCRIPTION
      This function retrieves a random dad joke from the internet.

  .EXAMPLE
      Get-DadJoke

      This example retrieves a random dad joke.

  .NOTES
      Author:         Michael Free

  .OUTPUTS
        System.String. This function outputs two lines of text to the console.
  #>
  $jokeAPI = 'https://official-joke-api.appspot.com/random_joke'

  $testJokeAPI = Invoke-WebRequest -Uri $jokeAPI -Method HEAD -UseBasicParsing
  if (-not $testJokeAPI.StatusCode -eq 200) {
    throw 'Joke API Route Unavailable'
  }

  $dadJoke = Invoke-RestMethod -Uri $jokeAPI -Method Get
  if (-not ($dadJoke | Get-Member -Name 'setup') -and -not ($dadJoke | Get-Member -Name 'punchline')) {
    throw 'setup and punchline object unavailabe in response'
  }
  Write-Output $dadJoke.setup
  Write-Output $dadJoke.punchline
}
