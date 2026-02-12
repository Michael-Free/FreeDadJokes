Describe "Get-DadJoke" {

    BeforeAll {
        function script:Test-JokeAPI {
            param($Uri)
            return $true
        }

        function script:Request-DadJoke {
            param($Uri)
            return [PSCustomObject]@{
                Setup = "Default mock setup"
                Punchline = "Default mock punchline"
            }
        }

        Mock Test-JokeAPI { return $true } -ParameterFilter { $Uri -eq 'https://official-joke-api.appspot.com/random_joke' }
        Mock Request-DadJoke {
            return [PSCustomObject]@{
                Setup = "Test setup"
                Punchline = "Test punchline"
            }
        } -ParameterFilter { $Uri -eq 'https://official-joke-api.appspot.com/random_joke' }

        $ValidUri = "https://official-joke-api.appspot.com/random_joke"
    }

    Context "Function Dependencies" {
        It "Depends on Test-JokeAPI function" {
            Get-DadJoke

            Assert-MockCalled Test-JokeAPI -Times 1 -ParameterFilter {
                $Uri -eq 'https://official-joke-api.appspot.com/random_joke'
            }
        }

        It "Depends on Request-DadJoke function" {
            Get-DadJoke

            Assert-MockCalled Request-DadJoke -Times 1 -ParameterFilter {
                $Uri -eq 'https://official-joke-api.appspot.com/random_joke'
            }
        }
    }

    Context "Successful API Responses" {
        It "Returns setup and punchline as separate strings when API is available" {
            $testSetup = "Why don't scientists trust atoms?"
            $testPunchline = "Because they make up everything!"

            Mock Request-DadJoke {
                return [PSCustomObject]@{
                    Setup = $testSetup
                    Punchline = $testPunchline
                }
            } -ParameterFilter { $Uri -eq $ValidUri }

            $result = Get-DadJoke

            $result | Should -BeOfType [System.String]
            $result.Count | Should -Be 2
            $result[0] | Should -Be $testSetup
            $result[1] | Should -Be $testPunchline
        }

        It "Uses the hardcoded API endpoint" {
            Get-DadJoke

            Assert-MockCalled Test-JokeAPI -ParameterFilter {
                $Uri -eq 'https://official-joke-api.appspot.com/random_joke'
            } -Times 1

            Assert-MockCalled Request-DadJoke -ParameterFilter {
                $Uri -eq 'https://official-joke-api.appspot.com/random_joke'
            } -Times 1
        }

        It "Outputs the joke exactly as received from Request-DadJoke" {
            $testSetup = "What do you call a fake noodle?"
            $testPunchline = "An impasta!"

            Mock Request-DadJoke {
                return [PSCustomObject]@{
                    Setup = $testSetup
                    Punchline = $testPunchline
                }
            } -ParameterFilter { $Uri -eq $ValidUri }

            $result = Get-DadJoke

            $result[0] | Should -Be $testSetup
            $result[1] | Should -Be $testPunchline
        }

        It "Handles jokes with special characters" {
            $testSetup = "What's E.T. short for? (dad joke version)"
            $testPunchline = "He's only got little legs!"

            Mock Request-DadJoke {
                return [PSCustomObject]@{
                    Setup = $testSetup
                    Punchline = $testPunchline
                }
            } -ParameterFilter { $Uri -eq $ValidUri }

            $result = Get-DadJoke

            $result[0] | Should -Be $testSetup
            $result[1] | Should -Be $testPunchline
        }
    }

    Context "Error Handling" {
        It "Throws error when Test-JokeAPI returns false" {
            Mock Test-JokeAPI { return $false } -ParameterFilter { $Uri -eq $ValidUri }

            { Get-DadJoke } | Should -Throw "Test-JokeAPI error: API endpoint is unavailable or returned non-200 status code"
        }

        It "Does not call Request-DadJoke when Test-JokeAPI returns false" {
            Mock Test-JokeAPI { return $false } -ParameterFilter { $Uri -eq $ValidUri }
            Mock Request-DadJoke { } -ParameterFilter { $Uri -eq $ValidUri }

            try { Get-DadJoke } catch {}

            Assert-MockCalled Request-DadJoke -Times 0
        }

        It "Throws error when Request-DadJoke throws an exception" {
            $errorMessage = "API is currently unavailable"
            Mock Request-DadJoke {
                throw $errorMessage
            } -ParameterFilter { $Uri -eq $ValidUri }

            { Get-DadJoke } | Should -Throw "Request-Dadjoke Error: $errorMessage"
        }
    }

    Context "Output Format" {
        It "Returns exactly 2 lines of output on success" {
            Mock Request-DadJoke {
                return [PSCustomObject]@{
                    Setup = "Line 1"
                    Punchline = "Line 2"
                }
            } -ParameterFilter { $Uri -eq $ValidUri }

            $output = Get-DadJoke

            $output.Count | Should -Be 2
        }

        It "Outputs strings, not objects" {
            Mock Request-DadJoke {
                return [PSCustomObject]@{
                    Setup = "Test"
                    Punchline = "Test"
                }
            } -ParameterFilter { $Uri -eq $ValidUri }

            $output = Get-DadJoke

            $output[0] | Should -BeOfType [System.String]
            $output[1] | Should -BeOfType [System.String]
        }


        It "Outputs to the pipeline, not to host" {
            Mock Write-Host {} -ParameterFilter { $InputObject -eq $null } # Should not be called
            Mock Request-DadJoke {
                return [PSCustomObject]@{
                    Setup = "Test"
                    Punchline = "Test"
                }
            } -ParameterFilter { $Uri -eq $ValidUri }

            $output = Get-DadJoke

            Assert-MockCalled Write-Host -Times 0
            $output | Should -Not -BeNullOrEmpty
        }
    }


    Context "Edge Cases" {
        It "Handles empty setup from Request-DadJoke" {
            Mock Request-DadJoke {
                return [PSCustomObject]@{
                    Setup = ""
                    Punchline = "Valid punchline"
                }
            } -ParameterFilter { $Uri -eq $ValidUri }

            $result = Get-DadJoke

            $result[0] | Should -Be ""
            $result[1] | Should -Be "Valid punchline"
        }

        It "Handles empty punchline from Request-DadJoke" {
            Mock Request-DadJoke {
                return [PSCustomObject]@{
                    Setup = "Valid setup"
                    Punchline = ""
                }
            } -ParameterFilter { $Uri -eq $ValidUri }

            $result = Get-DadJoke

            $result[0] | Should -Be "Valid setup"
            $result[1] | Should -Be ""
        }

        It "Handles both setup and punchline being empty" {
            Mock Request-DadJoke {
                return [PSCustomObject]@{
                    Setup = ""
                    Punchline = ""
                }
            } -ParameterFilter { $Uri -eq $ValidUri }

            $result = Get-DadJoke

            $result[0] | Should -Be ""
            $result[1] | Should -Be ""
            $result.Count | Should -Be 2
        }
    }

}