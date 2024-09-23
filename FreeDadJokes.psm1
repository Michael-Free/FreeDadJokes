$uri = "https://official-joke-api.appspot.com/random_joke"
Invoke-RestMethod -Uri $Uri -Method Get | Select-Object setup, punchline
<#
Things i should do:
- Tesst for internet access - quiet
- test for access to api -quiet
- format the output line-by-line
#>
