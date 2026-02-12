Describe "Test-JokeAPI" {

    BeforeAll {
        $ValidUri = "https://official-joke-api.appspot.com/random_joke"
        $InvalidUri = "https://broken-link.com"
    }

    Context "Connectivity and Status Codes" {

        It "Returns True when the API returns Status 200" {
            Mock Invoke-WebRequest {
                return [PSCustomObject]@{ StatusCode = 200 }
            }

            $Result = Test-JokeAPI -Uri $ValidUri

            $Result | Should -Be $true
        }

        It "Returns False when the API returns a 404 Not Found" {
            Mock Invoke-WebRequest {
                return [PSCustomObject]@{ StatusCode = 404 }
            }

            $Result = Test-JokeAPI -Uri $InvalidUri 2>$null

            $Result | Should -Be $false
        }

        It "Returns False when a network exception occurs (e.g., DNS failure)" {
            Mock Invoke-WebRequest {
                throw [System.Net.WebException]::new("The remote name could not be resolved")
            }

            $Result = Test-JokeAPI -Uri "http://this-does-not-exist.local" 2>$null

            $Result | Should -Be $false
        }
    }

    Context "Internal Logic and Parameters" {

        It "Uses the HEAD method to minimize bandwidth" {
            Mock Invoke-WebRequest { return [PSCustomObject]@{ StatusCode = 200 } }

            $null = Test-JokeAPI -Uri $ValidUri

            Assert-MockCalled Invoke-WebRequest -ParameterFilter {
                $Method -eq 'HEAD'
            }
        }

        It "Correctly passes the custom Timeout value" {
            Mock Invoke-WebRequest { return [PSCustomObject]@{ StatusCode = 200 } }
            $CustomTimeout = 10

            $null = Test-JokeAPI -Uri $ValidUri -Timeout $CustomTimeout

            Assert-MockCalled Invoke-WebRequest -ParameterFilter {
                $TimeoutSec -eq 10
            }
        }

        It "Requires the Uri parameter" {
            { Test-JokeAPI } | Should -Throw "*Uri parameter is required*"
        }
    }
}