<#
 .Synopsis
  Christmas tree

 .Description
  Return hashtable with christmas tree body and trunk.
  Supports built-in styles and custom ASCII tree import.
  Built-in styles intentionally include ornament symbol patterns so color mapping can illuminate them.

 .Parameter Style
  Built-in style name. Use Custom with CustomTreePath to import a tree from file.

 .Parameter CustomTreePath
  Path to a text file containing a custom ASCII tree.
#>
function Get-ChristmasTree() {
  [CmdletBinding()]
  [OutputType([hashtable])]
  Param (
    [Parameter(Mandatory = $false)]
    [ValidateSet('Classic', 'Minimal', 'Wide', 'Custom')]
    [string]$Style = 'Classic',

    [Parameter(Mandatory = $false)]
    [string]$CustomTreePath
  )

  if ($Style -eq 'Custom' -and -not [string]::IsNullOrWhiteSpace($CustomTreePath)) {
    if (Test-Path -Path $CustomTreePath) {
      try {
        $CustomTree = Get-Content -Path $CustomTreePath -Raw -ErrorAction Stop
        if (-not [string]::IsNullOrWhiteSpace($CustomTree)) {
          $TreeLines = $CustomTree -split "`r?`n" | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }
          $LastLine = if ($TreeLines.Count -gt 0) { $TreeLines[-1].Trim() } else { '|___|' }
          $TreeBody = if ($TreeLines.Count -gt 1) {
            (($TreeLines | Select-Object -First ($TreeLines.Count - 1)) -join "`n")
          }
          else {
            ''
          }

          return @{
            'tree'  = $TreeBody
            'trunk' = $LastLine
          }
        }
      }
      catch {
        Write-Warning "PSChristmasTree: failed to read custom tree file '$CustomTreePath'. Falling back to built-in style."
      }
    }
    else {
      Write-Warning "PSChristmasTree: custom tree file '$CustomTreePath' was not found. Falling back to built-in style."
    }
  }

  switch ($Style) {
    'Minimal' {
      return @{
        'tree'  = @"
      |
     -+-
      A
     /=\
    / i \
   / O O \
  /=======\
 / O * * O \
/===========\
"@
        'trunk' = '|_|'
      }
    }
    'Wide' {
      return @{
        'tree'  = @"
             |
            -+-
             A
            /=\
           / O \
          /  *  \
        i/ O i O \i
        /=========\
      i/  *  *  *  \i
       /===========\
     i/ *  O * O *  \i
     /===============\
    i/  O  i * i  O  \i
    /=================\
  i/   *  O  O  i  *   \i
   /===================\
 i/  O  *  i * O  *  O  \i
 /=======================\
"@
        'trunk' = '|_____|'
      }
    }
    default {
      return @{
        'tree'  = @"
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
"@
        'trunk' = '|___|'
      }
    }
  }
}