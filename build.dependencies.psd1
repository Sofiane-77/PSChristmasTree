@{
    # Defaults parameters for all dependencies
    PSDependOptions  = @{
        Scope     = 'CurrentUser'
        Parameters = @{
            Repository = 'PSGallery'
        }
    }

    # Dependencies
    Pester           = '5.7.1'
    PSScriptAnalyzer = '1.25.0'
    platyPS          = '0.14.2'
    InvokeBuild      = '5.14.23'
    PowerShellGet    = '2.2.5'
}
