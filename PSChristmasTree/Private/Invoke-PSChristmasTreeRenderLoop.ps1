function Invoke-PSChristmasTreeRenderLoop() {
    [CmdletBinding()]
    [OutputType([System.Void])]
    Param (
        [Parameter(Mandatory = $true)]
        [hashtable]$EffectiveConfig,

        [Parameter(Mandatory = $true)]
        [hashtable]$Messages
    )

    $audioSession = $null
    $renderCompleted = $false
    $currentColor = $null
    $currentBufferSize = $null
    $currentCursorSize = $null
    $messageModel = @{
        Show = $false
    }

    try {
        $currentColor = Get-ConsoleForegroundColor
        $currentBufferSize = Get-BufferSizeWidth
        $currentCursorSize = Get-CursorSize

        $treeStyle = [string]$EffectiveConfig['TreeStyle']
        $customTreePath = [string]$EffectiveConfig['CustomTreePath']
        $christmasTree = Get-ChristmasTree -Style $treeStyle -CustomTreePath $customTreePath

        $decorations = @{}
        if ($EffectiveConfig['Decorations']) {
            $decorations = $EffectiveConfig['Decorations']
        }

        $trunkKey = [string]$christmasTree['trunk']
        if (-not [string]::IsNullOrWhiteSpace($trunkKey)) {
            $trunkKey = $trunkKey.Trim()
            $decorations = $decorations.Clone()
            $trunkColor = [string]$EffectiveConfig['TrunkColor']
            if (-not [string]::IsNullOrWhiteSpace($trunkColor)) {
                $decorations[$trunkKey] = $trunkColor
            }
            elseif (-not $decorations.ContainsKey($trunkKey)) {
                $decorations[$trunkKey] = 'Red'
            }
        }

        $renderedTree = Get-PSChristmasTreeDecoratedTree -TreeData $christmasTree -DecorationMap $decorations
        $messageModel = Get-PSChristmasTreeMessageRenderModel -Messages $Messages -ShowMessages ([bool]$EffectiveConfig['ShowMessages'])

        if ($EffectiveConfig['HideCursor']) {
            Hide-CursorSize
        }

        if ($EffectiveConfig['PlayCarol'] -gt 0) {
            $audioSession = Start-PSChristmasTreeCarolSession -LoopCount $EffectiveConfig['PlayCarol']
        }

        $i = 0
        do {
            if ($currentBufferSize -ine (Get-BufferSizeWidth)) {
                $christmasTree = Get-ChristmasTree -Style $treeStyle -CustomTreePath $customTreePath
                $renderedTree = Get-PSChristmasTreeDecoratedTree -TreeData $christmasTree -DecorationMap $decorations
                $messageModel = Get-PSChristmasTreeMessageRenderModel -Messages $Messages -ShowMessages ([bool]$EffectiveConfig['ShowMessages'])
                $currentBufferSize = Get-BufferSizeWidth

                if ($EffectiveConfig['HideCursor']) {
                    Hide-CursorSize
                }
            }

            Clear-Host
            Write-Host-Colorized -DecoratedText $renderedTree -Colors $EffectiveConfig['Colors'] -DefaultForegroundColor 'Green'

            if ($messageModel['Show']) {
                Write-Host (Get-CenteredText -Text $messageModel['MerryChristmasText']) -ForegroundColor ($messageModel['MerryChristmasColors'] | Get-Random)
                Write-Host-Colorized -DecoratedText $messageModel['DeveloperLineDecoratedText'] -Colors $EffectiveConfig['Colors'] -DefaultForegroundColor $messageModel['DeveloperLineDefaultColor']
                Write-Host (Get-CenteredText -Text $messageModel['HappyNewYearText']) -ForegroundColor ($messageModel['HappyNewYearColors'] | Get-Random)
            }

            Start-Sleep -Milliseconds $EffectiveConfig['AnimationSpeed']
            $i++
        } until ($i -eq $EffectiveConfig['AnimationLoopNumber'])
        $renderCompleted = $true
    }
    finally {
        try {
            if ($null -ne $audioSession) {
                if ($renderCompleted) {
                    Wait-PSChristmasTreeCarolSession -Session $audioSession
                }
                else {
                    Stop-PSChristmasTreeCarolSession -Session $audioSession
                }
            }
        }
        finally {
            try {
                if (-not [string]::IsNullOrWhiteSpace([string]$currentCursorSize)) {
                    Set-CursorSize $currentCursorSize
                }
            }
            finally {
                if ($null -ne $currentColor) {
                    Set-ConsoleForegroundColor $currentColor
                }
            }
        }
    }
}
