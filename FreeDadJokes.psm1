#$uri = "https://official-joke-api.appspot.com/random_joke"
#Invoke-RestMethod -Uri $Uri -Method Get | Select-Object setup, punchline

function Get-DadJoke() {
    $jokeAPI = "https://official-joke-api.appspot.com/random_joke"

    $testJokeAPI = Invoke-WebRequest -Uri $jokeAPI -Method HEAD -UseBasicParsing
    if (-not $testJokeAPI.StatusCode -eq 200) {
        throw 'Joke API Route Unavailable'
    }

    $dadJoke = Invoke-RestMethod -Uri $jokeAPI -Method Get
    if (-not ($dadJoke | Get-Member -Name 'setup') -and -not ($dadJoke | Get-Member -Name 'punchline')) {
        throw 'setup and punchline object unavailabe in response'
    }
}

