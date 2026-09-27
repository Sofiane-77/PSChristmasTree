[CmdletBinding()]
param(
    [string]$OutputPath = (Join-Path -Path $PSScriptRoot -ChildPath '../PSChristmasTree/assets/carol.wav')
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

. (Join-Path -Path $PSScriptRoot -ChildPath '../PSChristmasTree/Private/Get-PSChristmasTreeCarol.ps1')
$score = @(Get-PSChristmasTreeCarol)
$sampleRate = 16000
$bytesPerSample = 2
$sampleCount = 0
foreach ($note in $score) {
    $sampleCount += [int](($note['Duration'] + $note['Rest']) * $sampleRate / 1000)
}

$directory = Split-Path -Path $OutputPath -Parent
if (-not (Test-Path -LiteralPath $directory)) {
    $null = New-Item -Path $directory -ItemType Directory -Force
}

$stream = [System.IO.File]::Create($OutputPath)
$writer = New-Object System.IO.BinaryWriter($stream)
try {
    $writer.Write([Text.Encoding]::ASCII.GetBytes('RIFF'))
    $writer.Write([int](36 + $sampleCount * $bytesPerSample))
    $writer.Write([Text.Encoding]::ASCII.GetBytes('WAVE'))
    $writer.Write([Text.Encoding]::ASCII.GetBytes('fmt '))
    $writer.Write([int]16)
    $writer.Write([int16]1)
    $writer.Write([int16]1)
    $writer.Write([int]$sampleRate)
    $writer.Write([int]($sampleRate * $bytesPerSample))
    $writer.Write([int16]$bytesPerSample)
    $writer.Write([int16]16)
    $writer.Write([Text.Encoding]::ASCII.GetBytes('data'))
    $writer.Write([int]($sampleCount * $bytesPerSample))

    foreach ($note in $score) {
        $toneSamples = [int]($note['Duration'] * $sampleRate / 1000)
        $restSamples = [int]($note['Rest'] * $sampleRate / 1000)
        $frequency = [double]$note['Frequency']
        $fadeSamples = [Math]::Min(80, [int]($toneSamples / 2))

        for ($sample = 0; $sample -lt $toneSamples; $sample++) {
            $envelope = [Math]::Min(1.0, [Math]::Min($sample / $fadeSamples, ($toneSamples - 1 - $sample) / $fadeSamples))
            $value = [Math]::Sin(2.0 * [Math]::PI * $frequency * $sample / $sampleRate)
            $writer.Write([int16][Math]::Round(8191 * $envelope * $value))
        }
        for ($sample = 0; $sample -lt $restSamples; $sample++) {
            $writer.Write([int16]0)
        }
    }
}
finally {
    $writer.Dispose()
}
