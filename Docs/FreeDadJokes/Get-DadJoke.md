---
document type: cmdlet
external help file: FreeDadJokes-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FreeDadJokes
ms.date: 02/10/2026
PlatyPS schema version: 2024-05-01
title: Get-DadJoke
---

# Get-DadJoke

## SYNOPSIS

Retrieves and displays a random dad joke from a predefined API.

## SYNTAX

### __AllParameterSets

```
Get-DadJoke
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

The Get-DadJoke function fetches a random dad joke from a hardcoded API endpoint
(official-joke-api.appspot.com) and displays it in a readable format.
It first tests the API availability using Test-JokeAPI, then retrieves the joke
using Request-DadJoke.
The joke is output as two separate lines: setup and punchline.

## EXAMPLES

### EXAMPLE 1

Get-DadJoke
Why don't scientists trust atoms?
Because they make up everything!

This example shows the basic usage of Get-DadJoke.

### EXAMPLE 2

$jokeLines = Get-DadJoke
PS C:\> $jokeLines[0]
Why don't scientists trust atoms?
PS C:\> $jokeLines[1]
Because they make up everything!

This example captures the output as an array of strings.

## PARAMETERS

## INPUTS

### None. You cannot pipe input to this function.

{{ Fill in the Description }}

## OUTPUTS

### System.String
Outputs two strings to the pipeline: the joke setup followed by the punchline.

{{ Fill in the Description }}

## NOTES

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


## RELATED LINKS

{{ Fill in the related links here }}

