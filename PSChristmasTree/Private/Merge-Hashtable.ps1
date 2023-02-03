<#
 .Synopsis
  Merge Hashtable

 .Description
  Return a merged Hashtable
#>
Function Merge-Hashtable() {
	[OutputType([Hashtable])]
    $Output = @{}
    foreach ($Hashtable in $Args) {
        If ($Hashtable -is [Hashtable]) {
            foreach ($Key in $Hashtable.Keys) {$Output.$Key = $Hashtable.$Key}
        }
    }
    return $Output
}