<#
 .Synopsis
    Tag existing ornament symbols in text for colorized rendering

 .Description
    Replaces matching symbol patterns with #color#symbol# tags.
    This does not create new ornaments; it tags symbols already present in the ASCII tree text.

 .Parameter Text
    Input text containing ornament symbol patterns

 .Parameter Decorations
  Hashtable :
      Key => existing symbol pattern to illuminate
      Value => color used for that symbol pattern

 .Example
     # Tag the existing "o" pattern in text so it is rendered in red
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