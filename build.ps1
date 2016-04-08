cls

Remove-Module [p]sake

# find psake path

$psakeModule=(Get-ChildItem(".\packages\psake*\tools\psake.psm1")).FullName | Sort-Object $_ | select -Last 1

# Import psake
Import-Module $psakeModule

Invoke-psake   `
-buildFile .\Build\default.ps1 `
 -taskList Test `
 -properties @{
					"buildConfiguration"="Debug"
					"buildPlatform"="Any CPU"
				} `
 -parameters @{"solutionFile"="..\psake.sln"}

 Write-Host "Build Exit Code: $LastExitCode"

 exit $LastExitCode
