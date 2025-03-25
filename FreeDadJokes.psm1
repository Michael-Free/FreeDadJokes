function Get-DadJoke {
  <#
    .SYNOPSIS
      Get stupid Dad Jokes on the Powershell commandline!
    
    .DESCRIPTION
      Unleash the ultimate arsenal of eye-rolling, groan-inducing stupidity right from your command line! This 
      PowerShell command fetches classic dad jokes guaranteed to make coworkers sigh, friends question your 
      humour, and children regret asking.
    
      Perfect for when you need a laugh—or at least to inflict one on others
    
    .PARAMETER None
      No parameters are required for this command.
    
    .INPUTS
      None. You cannot pipe objects to Get-DadJoke.
    
    .OUTPUTS
      The function outputs the setup and punchline of a Dad joke in two lines of text.
    
    .EXAMPLE
      Get-DadJoke
    
      This command will return two lines of output. The leadup, and the joke.
    
    .NOTES
        Author      : Michael Free
        Date        : 2025-03-22
        License     : Free Custom License (FCL) v1.0
        Copyright   : 2025, Michael Free. All Rights Reserved.
    
    .LINK
      https://github.com/Michael-Free/FreeDadJokes
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
