function Get-PSChristmasTreeCarol() {
    [CmdletBinding()]
    [OutputType([hashtable])]
    Param ()

    $notes = @{
        A4 = 440
        B4 = 493.883301256124
        C5 = 523.251130601197
        D5 = 587.329535834815
        E5 = 659.25511382574
        F5 = 698.456462866008
        G4 = 391.995435981749
    }

    # Each entry preserves the original 200 ms beep and its following 100 ms rest.
    $sequence = @(
        'G4:100', 'C5:100', 'C5:0', 'D5:0', 'C5:0', 'B4:0', 'A4:100',
        'A4:100', 'A4:100', 'D5:100', 'D5:0', 'E5:0', 'D5:0', 'C5:0', 'B4:100',
        'G4:100', 'G4:100', 'E5:100', 'E5:0', 'F5:0', 'E5:0', 'D5:0', 'C5:100',
        'A4:100', 'G4:100', 'A4:100', 'D5:100', 'B4:100', 'C5:0'
    )

    foreach ($entry in $sequence) {
        $parts = $entry.Split(':')
        @{
            Frequency = $notes[$parts[0]]
            Duration = 200
            Rest = [int]$parts[1]
        }
    }
}
