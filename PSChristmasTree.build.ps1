#Requires -Modules InvokeBuild

<#
.SYNOPSIS
    Build script (https://github.com/nightroman/Invoke-Build)
.DESCRIPTION
    This script contains the tasks for building the 'PSChristmasTree' PowerShell module
#>

param (
    [ValidateSet("Release", "Debug", "", IgnoreCase = $true)]$Configuration = "Debug",
	[ValidateSet("Major", "Minor", "Build", "Revision", IgnoreCase = $true)]$Type = "Revision",
    [Parameter(Mandatory=$false)][String]$NugetAPIKey,
	[Parameter(Mandatory=$false)][Switch]$ExportAlias
)

Set-StrictMode -Version Latest

#Define global variables before running tasks
Enter-Build {
	$Script:BuildDependenciesFile = Join-Path -Path $BuildRoot -ChildPath "build.dependencies.psd1"
	
	$Script:ModuleName = 'PSChristmasTree'
    $Script:ModuleSourcePath = Join-Path -Path $BuildRoot -ChildPath $ModuleName
    $Script:ModuleManifestFile = Join-Path -Path $ModuleSourcePath -ChildPath "$ModuleName.psd1"
	$Script:ModuleVersion = (Test-ModuleManifest -Path $ModuleManifestFile).Version
	$Script:ModuleVersionString = "$($ModuleVersion.Major).$($ModuleVersion.Minor).$($ModuleVersion.Build).$($ModuleVersion.Revision)"
	
	$Script:ModuleSourcePrivatePath = Join-Path -Path $ModuleSourcePath -ChildPath 'Private'
	$Script:ModuleSourcePublicPath = Join-Path -Path $ModuleSourcePath -ChildPath 'Public'
	$Script:ModuleSourceLocalesPath = Join-Path -Path $ModuleSourcePath -ChildPath 'locales'

    $Script:NuspecPath = Join-Path -Path $ModuleSourcePath -ChildPath "$ModuleName.nuspec"
    $Script:BuildOutputPath  = Join-Path -Path $BuildRoot -ChildPath 'Build'
	$Script:ModuleBuildPath = "$BuildOutputPath\$Configuration\$ModuleName\$ModuleVersionString"
	$Script:ModuleBuildFile = Join-Path -Path $ModuleBuildPath -ChildPath "$ModuleName.psm1"
	$Script:ModuleManifestBuildFile = Join-Path -Path $ModuleBuildPath -ChildPath "$ModuleName.psd1"

	
	$Script:ModuleBuildZipPath = "$BuildOutputPath\$Configuration\$ModuleName\"
	$Script:ModuleBuildZipFile = Join-Path -Path $ModuleBuildZipPath -ChildPath "$ModuleName-v$ModuleVersionString.zip"
	
}

# Install project build dependencies
task Init {
	# Set default values for installing dependencies
	$parameters = @{
		Force = $true
	}

	$dependencies = Import-PowerShellDataFile -Path $BuildDependenciesFile

	# Replace default values of parameters with those contained in the dependencies file
	if ($dependencies.ContainsKey('PSDependOptions')) {
		# We redefine Scope value if it exists in PSDependOptions
		if ($dependencies.PSDependOptions.ContainsKey('Scope') -and ![string]::IsNullOrWhiteSpace($dependencies.PSDependOptions.Scope)) {
			$parameters.Scope = $dependencies.PSDependOptions.Scope
		}
		# We redefine Repository value if it exists in PSDependOptions Parameters
		if ($dependencies.PSDependOptions.ContainsKey('Parameters')) {
			if ($dependencies.PSDependOptions.Parameters.ContainsKey('Repository') -and ![string]::IsNullOrWhiteSpace($dependencies.PSDependOptions.Parameters.Repository)) {
				$parameters.Repository = $dependencies.PSDependOptions.Parameters.Repository
			}
			if ($dependencies.PSDependOptions.Parameters.ContainsKey('SkipPublisherCheck') -and [bool]$dependencies.PSDependOptions.Parameters.SkipPublisherCheck) {
				$parameters.SkipPublisherCheck = $true
			}
		}
	}

	# Remove PSDependOptions from the hashtable to have only modules
	$dependencies.Remove('PSDependOptions')

	# If the dependencies are not installed, parse the version in the dependencies file to install it
	foreach($dependency in $dependencies.GetEnumerator()) {
		Write-Verbose -Message "Initializing Module $($dependency.Name)"
		if (-not(Get-Module -Name $dependency.Name -ListAvailable)) {
			Write-Warning "Module '$($dependency.Name)' is missing or out of date. Installing module now."
			$paramDependency = $parameters
			$paramDependency.Name = $dependency.Name
			# If the version is specific, parse semantic versioning
			if ($dependency.Value -inotmatch ".*latest|.*\*") {
				$versionMatches = [Regex]::Matches($dependency.Value, "\d+(?:\.\d+){2}(?:\.\d+)?$")[0].Value;
				$version = $versionMatches;
				if ($dependency.Value -imatch "<(=?).*") {
					$paramDependency.MaximumVersion = $version
				}
				if ($dependency.Value -imatch ">(=?).*") {
					$paramDependency.MinimumVersion = $version
				}
				if ($dependency.Value -imatch "^(\^|=|\d)") {
					$paramDependency.RequiredVersion = $version
				}
			}
			Install-Module @paramDependency
		}
	}
}

task Analyze {
    try {
		$parameters = @{
			Path = $ModuleSourcePublicPath
			Profile = "$ModuleSourcePath\PSScriptAnalyzerSettings.psd1"
			Recurse = $true
		}
		
        Write-Verbose -Message "Running PSScriptAnalyzer on Public functions"
        $publicResults = Invoke-ScriptAnalyzer @parameters
		
        Write-Verbose -Message "Running PSScriptAnalyzer on Private functions"
		$parameters.Path = $ModuleSourcePrivatePath	
		$privateResults = Invoke-ScriptAnalyzer @parameters
		
		if ($publicResults -Or $privateResults) {
			$publicResults | Format-List
			$privateResults | Format-List
			throw 'There was PSScriptAnalyzer violation(s). See test results for more information.'
		}
    }
    catch {
        throw "Couldn't run Script Analyzer"
    }
}

task Test {
	Write-Verbose -Message "Running Pester Tests"

	# Get-ChildItem parameters
	$parameters = @{
		Path    = $ModuleSourcePath
		Recurse = $true
		Include = "*.Tests.ps1"
	}
	$testFiles = Get-ChildItem @parameters
	
	# Pester parameters
	$parameters = @{
		Path     = $testFiles
		PassThru = $true
	}
	$results = Invoke-Pester @parameters

    if($results.FailedCount -gt 0){
		$results | Format-List
        throw "$($results.FailedCount) Tests failed. Build cannot continue!"
    }
}

task Build {

	Remove-Item $ModuleBuildPath -Recurse -Force -ErrorAction SilentlyContinue

	Write-Verbose -Message "Creating module version folder: $ModuleBuildPath."
    try {
        New-Item -Path $ModuleBuildPath -ItemType Directory
    }
    catch {
        throw "Failed creating the new temp module folder: $ModuleBuildPath"
    }

    Write-Verbose -Message "Generating the Module Manifest for temp build and generating new Module File"
    try {
        Copy-Item -Path $ModuleManifestFile -Destination $ModuleBuildPath
        New-Item -Path $ModuleBuildFile -ItemType File
    }
    catch {
        throw "Failed copying Module Manifest from: $ModuleManifestFile to $ModuleBuildPath or Generating the new psm file."
    }

    Write-Verbose -Message "Updating Module Manifest with Public Functions"
    $publicFunctions = Get-ChildItem -Path "$ModuleSourcePublicPath\*.ps1"
    $privateFunctions = Get-ChildItem -Path "$ModuleSourcePrivatePath\*.ps1"
    try {
        Write-Verbose -Message "Appending Public functions to the psm file"
        $functionsToExport = New-Object -TypeName System.Collections.ArrayList
        foreach($function in $publicFunctions.Name){
            write-Verbose -Message "Exporting function: $(($Function.split('.')[0]).ToString())"
            $functionsToExport.Add(($function.split('.')[0]).ToString())
        }
        Update-ModuleManifest -Path $ModuleManifestBuildFile -FunctionsToExport $FunctionsToExport -RequireLicenseAcceptance
    }
    catch {
		Write-Error $_
        throw "Failed updating Module manifest with public functions"
    }
    Write-Verbose -Message "Building the .psm1 file"
    Write-Verbose -Message "Appending Public Functions"
    Add-Content -Path $ModuleBuildFile -Value "### --- PUBLIC FUNCTIONS --- ###"
    foreach($function in $publicFunctions.Name){
        try {
            Write-Verbose -Message "Updating the .psm1 file with function: $($Function)"
            $content = Get-Content -Raw -Path "$ModuleSourcePublicPath\$($Function)"
			if ($content -match '<#(\w|\W)*#>') { 
			  $comment = $Matches[0]
			  $contentWithoutComment = $content.replace($comment,'')
			  $regex = [Regex] "(?<=\).){(?=\s)"
			  $content = $regex.Replace($contentWithoutComment, [string]::Join([System.Environment]::Newline, '{', $comment), 1)
			}
            Add-Content -Path $ModuleBuildFile -Value "#region - $Function"
            Add-Content -Path $ModuleBuildFile -Value $content
            if($exportAlias.IsPresent){
                $aliasSwitch = $false
                $sel = Select-String -Path "$ModuleSourcePublicPath\$($Function)" -Pattern "CmdletBinding" -Context 0,1
                $Mylist = $Sel.ToString().Split([Environment]::NewLine)
                foreach($S in $Mylist){
                    if($S -match "Alias"){
                        $Alias = (($S.split(":")[2]).split("(")[1]).split(")")[0]
                        Write-Verbose -Message "Exporting Alias: $($Alias) to Function: $($Function)"
                        Add-Content -Path $ModuleBuildFile -Value "Export-ModuleMember -Function $(($Function.split('.')[0]).ToString()) -Alias $Alias"
                        $AliasSwitch = $true
                    }
                }
                if($AliasSwitch -eq $false){
                    Write-Verbose -Message "No alias was found in function: $($Function))"
                    Add-Content -Path $ModuleBuildFile -Value "Export-ModuleMember -Function $(($Function.split('.')[0]).ToString())"
                }
            }
            else {
                Add-Content -Path $ModuleBuildFile -Value "Export-ModuleMember -Function $(($Function.split('.')[0]).ToString())"
            }
            Add-Content -Path $ModuleBuildFile -Value "#endregion"
        }
        catch {
            throw "Failed adding content to .psm1 for function: $($Function)"
        }
    }

    Write-Verbose -Message "Appending Private functions"
    Add-Content -Path $ModuleBuildFile -Value "### --- PRIVATE FUNCTIONS --- ###"
    foreach($function in $privateFunctions.Name){
        try {
            Write-Verbose -Message "Updating the .psm1 file with function: $($function)"
            $content = Get-Content -Raw -Path "$ModuleSourcePrivatePath\$($function)"
			if ($content -match '<#(\w|\W)*#>') { 
			  $comment = $Matches[0]
			  $contentWithoutComment = $content.replace($comment,'')
			  $regex = [Regex] "(?<=\).){(?=\s)"
			  $content = $regex.Replace($contentWithoutComment, [string]::Join([System.Environment]::Newline, '{', $comment), 1)
			}
            Add-Content -Path $ModuleBuildFile -Value "#region - $function"
            Add-Content -Path $ModuleBuildFile -Value $content
            Add-Content -Path $ModuleBuildFile -Value "#endregion"
        }
        catch {
            throw "Failed adding content to .psm1 for function: $($function)"
        }
    }

	Write-Verbose -Message "Updating Module Manifest with root module"

    try {
        Write-Verbose -Message "Updating the Module Manifest"
        Update-ModuleManifest -Path $ModuleManifestBuildFile -RootModule "$ModuleName.psm1"
    }
    catch {
        Write-Warning -Message "Failed appinding the rootmodule to the Module Manifest"
    }
	
	Write-Verbose -Message "Copying assets and updating locales path references"
	
	try {
		$moduleFile = Get-Content -Raw -Path $ModuleBuildFile
		if ($moduleFile -match "../locales") {
			Set-Content -Path $ModuleBuildFile -Value $moduleFile.replace("../locales","./locales") -Encoding "UTF8" -NoNewline			
		}
	}
	catch {
		Write-Warning -Message "Failed updating locales path reference"
	}
	
	try {
		Copy-Item -Path $ModuleSourceLocalesPath -Destination $ModuleBuildPath -Recurse
	}
	catch {
		Write-Warning -Message "Failed copying locales inside build Module directory"
	}
	
	try {
		Copy-Item -Path (Join-Path -Path $BuildRoot -ChildPath 'LICENSE') -Destination (Join-Path -Path $ModuleBuildPath -ChildPath 'License.txt')
	} catch {
		Write-Warning -Message "Failed copying license"
	}
}

task Zip -if($Configuration -eq "Release") {
	$compress = @{
	  Path = $ModuleBuildZipPath
	  CompressionLevel = "Optimal"
	  DestinationPath = $ModuleBuildZipFile
	  Force = $true
	}
	Compress-Archive @compress
}

task Docs -if($Configuration -eq "Release") {

    Write-Verbose -Message "Compiling Help files"

    try {
        Write-Verbose -Message "Importing the module to be able to output documentation"
        Import-Module $ModuleBuildFile -Force # re-import module with latest changes
    }
    catch {
        throw "Failed importing the module: $($ModuleName)"
    }
	
	if(Get-Module -Name $($ModuleName)) {
		Write-Verbose -Message "Removing old Help files, to generate new files."
		Remove-Item -Path ".\docs\*.md" -Exclude "index.md", "prerequisites.md", "installation.md", "gettingstarted.md", "FAQ.md", "how-to-contribute.md"

		Write-Verbose -Message "Module: $ModuleName is imported into session, generating Help Files"
		$parameters = @{
			Module = $ModuleName
			OutputFolder = ".\docs"
			NoMetadata = $true
			Encoding = [System.Text.Encoding]::UTF8
			Force = $true
		}
		New-MarkdownHelp @parameters
	}
	else {
	   throw "Module is not imported, cannot generate help files"
	}
}

task Publish -if($Configuration -eq "Release"){

    Write-Verbose -Message "Publishing Module to PowerShell gallery"
    Write-Verbose -Message "Importing Module $ModuleBuildFile"
    Import-Module $ModuleManifestBuildFile
    If((Get-Module -Name $ModuleName) -and ($NugetAPIKey)) {
        try {
            write-Verbose -Message "Publishing Module: $ModuleName"
            Publish-Module -Path $ModuleBuildPath -NuGetApiKey $NugetAPIKey
        }
        catch {
			Write-Error $_
            throw "Failed publishing module to PowerShell Gallery"
        }
    }
    else {
        Write-Warning -Message "Something went wrong, couldn't publish module to PSGallery. Did you provide a NugetKey?."
    }
}

task Clean -if($Configuration -eq "Release") {
    if(Test-Path $ModuleBuildPath){
        Write-Verbose -Message "Removing $ModuleBuildPath folders"
        Remove-Item $ModuleBuildPath -Recurse -Force
    }
}

# Synopsis: Generate a new module version if creating a release build
task GenerateNewModuleVersion -if($Configuration -eq "Release") {

	# Set module version base numbers
	[int]$Major = $ModuleVersion.Major
	[int]$Minor = $ModuleVersion.Minor
	[int]$Build = $ModuleVersion.Build
	[int]$Revision = $ModuleVersion.Revision

	switch ($Type) {
		"Major" {
			$Major++
			$Minor = 0
			$Build = 0
			break
		}
		"Minor" {
			$Minor++
			$Build = 0
			break
		}
		"Build" {
			$Build++
			$Revision = 0
			break
		}
		Default {
			$Revision++
			break
		}
	}
	
	$moduleVersion = New-Object -TypeName 'System.Version' -ArgumentList ($Major, $Minor, $Build, $Revision)
	
	$moduleManifestContent = Get-Content -Raw $ModuleManifestFile
	$regex = [Regex] "(?<=ModuleVersion.*\')\d.*(?<!\')"
	$moduleManifestContent = $regex.Replace($moduleManifestContent, $moduleVersion, 1)
	
	Set-Content -Path $ModuleManifestFile -Value $moduleManifestContent -Encoding "UTF8" -NoNewline
}

task . Init, Analyze, Test, Build, Zip, Docs, Publish, Clean, GenerateNewModuleVersion
