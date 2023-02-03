function Write-PSChristmasTreeConfig() {
    [CmdletBinding()]
    [OutputType([System.Void])]
    Param (
        [Parameter(Mandatory = $true)]
        [hashtable]$Config,

        [Parameter(Mandatory = $false)]
        [hashtable]$Store = (Get-PSChristmasTreeConfigStore)
    )

    $normalized = ConvertTo-PSChristmasTreeConfig -PartialConfig $Config
    $json = $normalized | ConvertTo-Json -Depth 8
    & $Store.Save $json
    Write-Verbose 'Configuration saved.'
}
