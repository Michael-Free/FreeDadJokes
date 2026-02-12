Describe "Request-DadJoke" {

    BeforeAll {
        $ValidUri = "https://official-joke-api.appspot.com/random_joke"
        $InvalidUri = "https://broken-link.com"
    }

    Context "Parameter Validation" {
        It "Requires the Uri parameter" {
            { Request-DadJoke } | Should -Throw "*Uri parameter is required*"
        }
    }

    Context "Successful API Responses" {
        It "Returns a custom object with Setup and Punchline properties when API call succeeds" {
            $mockResponse = [PSCustomObject]@{
                setup = "Why did the scarecrow win an award?"
                punchline = "Because he was outstanding in his field!"
            }
            Mock Invoke-RestMethod { return $mockResponse }

            $Result = Request-DadJoke -Uri $ValidUri

            $Result | Should -BeOfType [PSCustomObject]
            $Result.PSObject.Properties.Name | Should -Contain 'Setup'
            $Result.PSObject.Properties.Name | Should -Contain 'Punchline'
            $Result.Setup | Should -Be "Why did the scarecrow win an award?"
            $Result.Punchline | Should -Be "Because he was outstanding in his field!"
       }

        It "Uses the GET method to retrieve the joke" {
            Mock Invoke-RestMethod {
                return [PSCustomObject]@{
                    setup = "Test setup"
                    punchline = "Test punchline"
                }
            }

            $null = Request-DadJoke -Uri $ValidUri

            Assert-MockCalled Invoke-RestMethod -ParameterFilter {
                $Method -eq 'GET'
            } -Times 1
        }
    }

    Context "Error Handling and Invalid Responses" {
        It "Returns false when a network exception occurs" {
            Mock Invoke-RestMethod {
                throw [System.Net.WebException]::new("*Name or service not known*")
            }
            $Result = Request-DadJoke -Uri $InvalidUri
            $Result | Should -Be $false
        }

        It "Returns false when API response is missing setup property" {
            $mockResponse = [PSCustomObject]@{
                punchline = "Because they make up everything!"
                id = "12345"
            }
            Mock Invoke-RestMethod { return $mockResponse }
            $Result = Request-DadJoke -Uri $ValidUri
            $Result | Should -Be $false
        }

        It "Returns false when API response is missing punchline property" {
            $mockResponse = [PSCustomObject]@{
                setup = "Why don't scientists trust atoms?"
                id = "12345"
            }
            Mock Invoke-RestMethod { return $mockResponse }
            $Result = Request-DadJoke -Uri $ValidUri
            $Result | Should -Be $false
        }

        It "Returns false when API response is empty/null" {
            Mock Invoke-RestMethod { return $null }
            $Result = Request-DadJoke -Uri $ValidUri
            $Result | Should -Be $false
        }

        It "Returns false when API response is not an object" {
            Mock Invoke-RestMethod { return "Not an object, just a string" }
            $Result = Request-DadJoke -Uri $ValidUri
            $Result | Should -Be $false
        }

        It "Handles API response with setup but empty punchline" {
            $mockResponse = [PSCustomObject]@{
                setup = "Why did the chicken cross the road?"
                punchline = ""
            }
            Mock Invoke-RestMethod { return $mockResponse }

            $Result = Request-DadJoke -Uri $ValidUri

            $Result | Should -BeOfType [PSCustomObject]
            $Result.Setup | Should -Be "Why did the chicken cross the road?"
            $Result.Punchline | Should -Be ""
        }

        It "Handles API response with empty setup but valid punchline" {
            $mockResponse = [PSCustomObject]@{
                setup = ""
                punchline = "Because they make up everything!"
            }
            Mock Invoke-RestMethod { return $mockResponse }

            $Result = Request-DadJoke -Uri $ValidUri

            $Result | Should -BeOfType [PSCustomObject]
            $Result.Setup | Should -Be ""
            $Result.Punchline | Should -Be "Because they make up everything!"
        }
    }

    Context "Verbose Output" {
        It "Outputs verbose messages when -Verbose is used" {
            Mock Invoke-RestMethod {
                return [PSCustomObject]@{
                    setup = "Test setup"
                    punchline = "Test punchline"
                }
            }

            $verboseOutput = Request-DadJoke -Uri $ValidUri -Verbose 4>&1
            $verboseString = $verboseOutput | Out-String

            $verboseString | Should -Not -BeNullOrEmpty
            $verboseString | Should -Match "Requesting Joke API endpoint"
            $verboseString | Should -Match "setup and punchline objects found"
        }
    }
}