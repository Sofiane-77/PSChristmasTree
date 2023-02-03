<#
 .Synopsis
  Merge Hashtable

 .Description
  Return a merged Hashtable
#>
Function Merge-Hashtable() {
	[CmdletBinding()]
	[OutputType([Hashtable])]
    Param (
        [Parameter(ValueFromRemainingArguments = $true)]
        [object[]]$InputObject
    )

    $output = @{}
    foreach ($item in $InputObject) {
        if ($item -isnot [hashtable]) {
            continue
        }

        foreach ($key in $item.Keys) {
            if ($output.ContainsKey($key) -and $output[$key] -is [hashtable] -and $item[$key] -is [hashtable]) {
                $output[$key] = Merge-Hashtable $output[$key] $item[$key]
            }
            else {
                $output[$key] = $item[$key]
            }
        }
    }

    return $output
}