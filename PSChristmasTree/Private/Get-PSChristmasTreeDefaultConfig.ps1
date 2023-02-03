function Get-PSChristmasTreeDefaultConfig() {
    [CmdletBinding()]
    [OutputType([hashtable])]
    Param ()

    $allColors = @([Enum]::GetNames([System.ConsoleColor]))
    $uiCultureName = (Get-UICulture).Name
    if ([string]::IsNullOrWhiteSpace($uiCultureName)) {
        $uiCultureName = [System.Globalization.CultureInfo]::CurrentUICulture.Name
    }
    if ([string]::IsNullOrWhiteSpace($uiCultureName)) {
        $uiCultureName = 'en-US'
    }

    return @{
        ConfigVersion = 3
        Language      = @{
            UICulture = $uiCultureName
        }
        Tree          = @{
            Style      = 'Classic'
            CustomPath = ''
        }
        Decorations   = @{
            Mode            = 'Default'
            IncludeDefaults = $true
            Defaults        = @{
                'O' = 'random'
            }
            Map             = @{}
        }
        Colors        = @{
            Mode        = 'Multicolor'
            SingleColor = 'Green'
            Palette     = $allColors
        }
        Display       = @{
            AnimationLoopNumber = 50
            AnimationSpeed      = 300
            HideCursor          = $true
        }
        Audio         = @{
            PlayCarol = 0
        }
        Messages      = @{
            Show   = $true
            Custom = @{}
        }
    }
}
