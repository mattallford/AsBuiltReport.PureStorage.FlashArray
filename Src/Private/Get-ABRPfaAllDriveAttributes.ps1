function Get-ABRPfaAllDriveAttributes {
    <#
        .SYNOPSIS

        .DESCRIPTION

        .EXAMPLE
        .NOTES
        Author:
        Website:
        Twitter:
        GitHub:
        .LINK
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        $Array
    )

    Begin {
        $ArrayDisks = Get-PfaAllDriveAttributes -Array $Array
        
    }

    Process {
        if ($ArrayDisks) {
            Paragraph "The following section provides a summary of the disks in $($ArrayAttributes.array_name)."
            BlankLine
            $ArrayDiskSummary = foreach ($ArrayDisk in $ArrayDisks) {
                [PSCustomObject] @{
                    'Name' = $ArrayDisk.name
                    'Capacity GB' = [math]::Round(($ArrayDisk.capacity) / 1GB, 0)
                    'Type' = $ArrayDisk.Type
                    'Status' = $ArrayDisk.status
                }
            }
            $ArrayDiskSummary | Sort-Object -Property Name | Table -Name 'Disk Summary' -ColumnWidths 25, 25, 25, 25
        }
    }
}