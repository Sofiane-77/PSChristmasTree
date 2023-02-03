<#
 .Synopsis
  Decorate Text with Tags to be able to add color to specific character

 .Description
  Replace character with #color#character# pattern

 .Parameter Text
  Text to decorate

 .Parameter Decorations
  Hashtable :
	  Key => character you want to animate
	  Value => color you want to display this character

 .Example
   # Decorate "Hello World!" for "o" character to be red
   Add-DecorationTag "Hello World!" @{'o'='red'}
   Result : Hell#red#o# W#red#o#rld!
#>
function Add-DecorationTag() {
    [CmdletBinding()]
	[OutputType([String])]
    Param (
            [Parameter( Mandatory = $true, Position=0 )]
            [ValidateNotNullOrEmpty()]
            [string]$Text,

            [Parameter( Mandatory = $true, Position=1 )]
            [ValidateNotNullOrEmpty()]
            [Hashtable]$Decorations
    )

    BEGIN {}

    PROCESS {
        foreach ($decoration in $Decorations.keys) {
            $Text = $Text.Replace("$decoration", "#$($Decorations.$decoration)#$decoration#")
        }
    }

    END {
        return $Text
    }
}