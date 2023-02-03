function Get-PSChristmasTreeDecoratedTree() {
    [CmdletBinding()]
    [OutputType([string])]
    Param (
        [Parameter(Mandatory = $true)]
        [hashtable]$TreeData,

        [Parameter(Mandatory = $false)]
        [hashtable]$DecorationMap = @{}
    )

    $centeredBody = if (-not [string]::IsNullOrWhiteSpace([string]$TreeData['tree'])) {
        Get-CenteredText -Text ([string]$TreeData['tree'])
    }
    else {
        ''
    }

    $centeredTrunk = if (-not [string]::IsNullOrWhiteSpace([string]$TreeData['trunk'])) {
        Get-CenteredText -Text ([string]$TreeData['trunk'])
    }
    else {
        ''
    }

    $combined = if (-not [string]::IsNullOrWhiteSpace($centeredBody) -and -not [string]::IsNullOrWhiteSpace($centeredTrunk)) {
        "$centeredBody`n$centeredTrunk"
    }
    elseif (-not [string]::IsNullOrWhiteSpace($centeredBody)) {
        $centeredBody
    }
    else {
        $centeredTrunk
    }

    if ($null -eq $DecorationMap -or $DecorationMap.Count -eq 0) {
        return $combined
    }

    return Add-DecorationTag -Text $combined -Decorations $DecorationMap
}