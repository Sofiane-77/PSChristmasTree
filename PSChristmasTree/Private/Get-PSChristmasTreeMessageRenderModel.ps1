function Get-PSChristmasTreeMessageRenderModel() {
    [CmdletBinding()]
    [OutputType([hashtable])]
    Param (
        [Parameter(Mandatory = $true)]
        [hashtable]$Messages,

        [Parameter(Mandatory = $true)]
        [bool]$ShowMessages
    )

    if (-not $ShowMessages) {
        return @{
            Show = $false
        }
    }

    return @{
        Show                       = $true
        MerryChristmasText         = [string]$Messages['MerryChristmas']['Text']
        MerryChristmasColors       = @($Messages['MerryChristmas']['Colors'])
        DeveloperLineDecoratedText = Get-DecoratedFormattedText -FormattedText ([string]$Messages['MessageForDevelopers']['Text']) -FormattedValue ([string]$Messages['MessageForDevelopers']['{0}']) -Centered $true
        DeveloperLineDefaultColor  = [string]$Messages['MessageForDevelopers']['Color']
        HappyNewYearText           = [string]$Messages['HappyNewYear']['Text']
        HappyNewYearColors         = @($Messages['HappyNewYear']['Colors'])
    }
}