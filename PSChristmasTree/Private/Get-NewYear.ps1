<#
 .Synopsis
  Get Year for christmas messages

 .Description
  Returns the current year or new year depends on when you call it
#>
function Get-NewYear() {
	[OutputType([int])]
	[int]$currentYear = Get-Date -UFormat "%Y"

	# The following year is displayed only if the date is greater than December 23
	if ((Get-Date) -gt (Get-Date -Year $currentYear -Month 12 -Day 23)) {
		$newYear = $currentYear + 1
		return $newYear
	}
	return $currentYear
}