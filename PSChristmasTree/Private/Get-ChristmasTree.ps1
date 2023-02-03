<#
 .Synopsis
  Christmas tree

 .Description
  Return hashtable with christmas tree and trunk
#>
function Get-ChristmasTree() {
    return @{
	'tree' = @"
         |
        -+-
         A
        /=\
      i/ O \i
      /=====\
      /  i  \
    i/ O * O \i
    /=========\
    /  *   *  \
  i/ O   i   O \i
  /=============\
  /  O   i   O  \
i/ *   O   O   * \i
/=================\
       |___|
"@;
	'trunk' = '|___|'; # Trunk of christmas tree
	}
}