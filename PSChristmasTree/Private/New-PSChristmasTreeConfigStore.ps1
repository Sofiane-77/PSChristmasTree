<#
 .Synopsis
  Create a configuration store adapter for PSChristmasTree.

 .Description
  Returns a hashtable that encapsulates all raw persistence operations (load, save, delete)
  for a given file path. This is the filesystem adapter implementing the config-store port.

  Callers (Read-PSChristmasTreeConfig, Write-PSChristmasTreeConfig) operate against this
  contract and never touch the filesystem directly. Tests inject a different adapter
  (e.g. New-PSChristmasTreeInMemoryConfigStore) to remove filesystem dependency.

  Store contract:
    Load   - scriptblock()          → [string|$null]   Raw JSON string, or $null if not found.
    Save   - scriptblock([string])  → [void]            Persists the JSON string.
    Delete - scriptblock()          → [bool]            $true if deleted, $false if not found.

 .Parameter Path
  Full path to the JSON configuration file.
  Defaults to the platform-standard location returned by Get-PSChristmasTreeConfigPath.

 .Example
    $store = Get-PSChristmasTreeConfigStore
  $json  = & $store.Load
  & $store.Save '{"ConfigVersion":3}'
  & $store.Delete
#>
function Get-PSChristmasTreeConfigStore() {
    [CmdletBinding()]
    [OutputType([hashtable])]
    Param (
        [Parameter(Mandatory = $false)]
        [string]$Path = (Get-PSChristmasTreeConfigPath)
    )

    if ([string]::IsNullOrWhiteSpace($Path)) {
        throw 'Configuration path cannot be empty.'
    }

    $storePath = $Path

    return @{
        Load   = {
            if (Test-Path -LiteralPath $storePath) {
                return Get-Content -Path $storePath -Raw -ErrorAction Stop
            }
            return $null
        }.GetNewClosure()

        Save   = {
            param([string]$Json)
            $dir = Split-Path -Path $storePath -Parent
            if (-not (Test-Path -LiteralPath $dir)) {
                New-Item -ItemType Directory -Path $dir -Force | Out-Null
            }
            Set-Content -Path $storePath -Value $Json -Encoding UTF8
        }.GetNewClosure()

        Delete = {
            if (Test-Path -LiteralPath $storePath) {
                Remove-Item -Path $storePath -Force
                return $true
            }
            return $false
        }.GetNewClosure()
    }
}
