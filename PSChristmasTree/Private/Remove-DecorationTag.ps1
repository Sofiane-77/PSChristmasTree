<#
 .Synopsis
  Remove Tags for decorated Text

 .Description
  Replace #color#character# pattern with character

 .Parameter DecoratedText
  Decorated Text with Add-DecorationTags

 .Parameter Decorations
    Hashtable :
	  Key => character you have chosen to animate
	  Value => color you have chosen to display this character

 .Example
   # Remove tags for decorated Text
   Remove-DecorationTag "Hell#red#o# W#red#o#rld!" @{'o'='red'}
   Result : Hello World!
#>
function Remove-DecorationTag() {
    [CmdletBinding(SupportsShouldProcess)]
	[OutputType([String])]
    Param (
            [Parameter( Mandatory = $true, Position=0 )]
            [ValidateNotNullOrEmpty()]
            [string]$DecoratedText,

            [Parameter( Mandatory = $true, Position=1 )]
            [ValidateNotNullOrEmpty()]
            [Hashtable]$Decorations
    )

    BEGIN {
        $Text = ""
    }

    PROCESS {
		if($PSCmdlet.ShouldProcess($DecoratedText)){
			foreach ($decoration in $Decorations.keys) {
				$Text = $DecoratedText.Replace("#$($Decorations.$decoration)#$decoration#", "$decoration")
			}
		}
    }

    END {
        return $Text
    }
}