function New-PSChristmasTreeCarolRunspace() {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Internal audio lifecycle operation.')]
    [CmdletBinding()]
    [OutputType([System.Management.Automation.Runspaces.Runspace])]
    Param ()

    [runspacefactory]::CreateRunspace()
}
