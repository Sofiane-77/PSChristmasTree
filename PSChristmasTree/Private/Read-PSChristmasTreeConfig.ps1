<#
 .Synopsis
  Read the PSChristmasTree configuration file

 .Description
  Reads the user configuration file and returns its contents as a normalized, validated hashtable.
  If no file exists, returns $null.
  If the file is invalid or corrupted, emits a warning and returns $null.
  Partial or invalid values in valid config files are normalized to defaults.

 .Example
   Read-PSChristmasTreeConfig

 .Example
   $Config = Read-PSChristmasTreeConfig
   if ($Config) { $Config['AnimationSpeed'] }
#>
function Read-PSChristmasTreeConfig() {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $false)]
        [hashtable]$Store = (Get-PSChristmasTreeConfigStore)
    )

    try {
        $Json = & $Store.Load
    }
    catch {
        Write-Warning "PSChristmasTree: configuration file is invalid and will be ignored. Run 'Reset-PSChristmasTreeConfig' to remove it. ($($_.Exception.Message))"
        return $null
    }

    if ($null -eq $Json) {
        return $null
    }

    try {
        $Parsed = $Json | ConvertFrom-Json -ErrorAction Stop

        if ($Parsed -isnot [PSCustomObject]) {
            Write-Warning "PSChristmasTree: configuration file has an unexpected format and will be ignored. Run 'Reset-PSChristmasTreeConfig' to remove it."
            return $null
        }

        $Config = ConvertTo-PSChristmasTreeHashtable -Value $Parsed
        if ($Config -isnot [hashtable]) {
            Write-Warning "PSChristmasTree: configuration file has an unexpected format and will be ignored. Run 'Reset-PSChristmasTreeConfig' to remove it."
            return $null
        }

        return ConvertTo-PSChristmasTreeConfig -PartialConfig $Config
    }
    catch {
        Write-Warning "PSChristmasTree: configuration file is invalid and will be ignored. Run 'Reset-PSChristmasTreeConfig' to remove it. ($($_.Exception.Message))"
        return $null
    }
}
