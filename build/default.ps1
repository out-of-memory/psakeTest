properties {

   $testMessage='Execute Test!'
	$cleanMessage='Execute Clean!'
	$compileMessage='Execute Compile!'
	$solutionDirectory=(Get-Item $solutionFile).DirectoryName
	$outputDirectory="$solutionDirectory\.build"
	$tempDirectory="$outputDirectory\temp"
	$buildConfiguration="Release"
	$buildPlatform="Any CPU"

}

FormatTaskName "`r`n`r`n -----------------Executing Task {0}---------------"
task default -depends Test

task Init -description "Create build output folder structure" -requiredVariables outputDirectory, tempDirectory, solutionFile, buildConfiguration,buildPlatform {
	
	#check build variables

	Assert -conditionToCheck ("Debug", "Release" -contains $buildConfiguration) `
		   -failureMessage "$buildConfiguration is not a valid build configuration. Please provide either 'Debug' or 'Release'"

	Assert -conditionToCheck ("x86", "x64", "Any CPU" -contains $buildPlatform) `
		   -failureMessage "$buildPlatform is not a valid build platform. Please provide either of one x86, x64, Any CPU"


	# remove .build if exist

	if(Test-Path $outputDirectory){
	
		Write-Host "Removing .build path"
		Remove-Item $outputDirectory\* -Force -Recurse
		Remove-Item $outputDirectory -Force -Recurse

	}

	Write-Host "creating base output folder .build"
	New-Item $outputDirectory -ItemType Directory | Out-Null
	New-Item $tempDirectory -ItemType Directory | Out-Null
}

task Clean -description "Cleaning the files"{
Write-Host $cleanMessage
}

task Compile -depends Init  -description "Compiling the files"{
Write-Host $compileMessage
	Exec {msbuild $solutionFile /p:Configuration=$buildConfiguration /p:Platform=$buildPlatform /p:OutDir=$tempDirectory}
}

task Test -depends Compile, Clean  -description "Testing the files"{
Write-Host $testMessage
}