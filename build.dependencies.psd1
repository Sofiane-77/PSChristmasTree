@{
    # Defaults parameters for all dependencies
    PSDependOptions  = @{
        Scope     = 'CurrentUser'
        Parameters = @{
            Repository         = 'PSGallery'
            SkipPublisherCheck = $true
        }
    }

    # Dependencies
	Pester           = 'latest'
	PSScriptAnalyzer = 'latest'
	platyPS	         = 'latest'
	InvokeBuild      = 'latest'
	PowerShellGet	 = 'latest'
}
