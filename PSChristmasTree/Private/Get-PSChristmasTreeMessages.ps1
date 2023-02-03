function Get-PSChristmasTreeMessageCatalog() {
    [CmdletBinding()]
    [OutputType([hashtable])]
    Param (
        [Parameter(Mandatory = $true)]
        [string]$UICulture,

        [Parameter(Mandatory = $false)]
        [hashtable]$CustomMessages = @{}
    )

    $messages = Import-LocalizedData -BaseDirectory (Join-Path -Path $PSScriptRoot -ChildPath '../locales') -FileName 'Messages.psd1' -UICulture $UICulture -ErrorAction SilentlyContinue
    if (-not $messages) {
        $messages = Import-LocalizedData -BaseDirectory (Join-Path -Path $PSScriptRoot -ChildPath '../locales') -FileName 'Messages.psd1'
    }

    if ($CustomMessages -and $CustomMessages.ContainsKey('MerryChristmas')) {
        $messages.MerryChristmas.Text = [string]$CustomMessages['MerryChristmas']
    }
    if ($CustomMessages -and $CustomMessages.ContainsKey('MessageForDevelopers')) {
        $messages.MessageForDevelopers.Text = [string]$CustomMessages['MessageForDevelopers']
    }
    if ($CustomMessages -and $CustomMessages.ContainsKey('HappyNewYear')) {
        $messages.HappyNewYear.Text = [string]$CustomMessages['HappyNewYear']
    }
    if ($CustomMessages -and $CustomMessages.ContainsKey('CodeWord')) {
        $messages.MessageForDevelopers.'{0}' = [string]$CustomMessages['CodeWord']
    }

    $messages.MerryChristmas.Text = $messages.MerryChristmas.Text.ToUpper()
    $messages.MessageForDevelopers.Text = $messages.MessageForDevelopers.Text.Replace('{1}', (Get-NewYear))
    $messages.HappyNewYear.Text = $messages.HappyNewYear.Text.ToUpper()

    return $messages
}
