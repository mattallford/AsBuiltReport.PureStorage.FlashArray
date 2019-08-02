function Get-ABRPfaArraySpaceMetrics {
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
        $Array
    )

    Begin {
        $ArraySpaceMetrics = Get-PfaArraySpaceMetrics -Array $Array
    }

    Process {
        if ($ArraySpaceMetrics) {
            Paragraph "The following section provides a summary of the storage usage on $($ArrayAttributes.array_name)."
            BlankLine
            $ArraySpaceSummary = [PSCustomObject] @{
                'Capacity' = "$([math]::Round(($ArraySpaceMetrics.capacity) / 1TB, 2)) TB"
                'Used' = "$([math]::Round(($ArraySpaceMetrics.total) / 1TB, 2)) TB"
                'Free' = "$([math]::Round(($ArraySpaceMetrics.capacity - $ArraySpaceMetrics.total) / 1TB, 2)) TB"
                '% Used' = [math]::Truncate(($ArraySpaceMetrics.total / $ArraySpaceMetrics.capacity) * 100)
                'Volumes' = "$([math]::Round(($ArraySpaceMetrics.volumes) / 1GB, 2)) GB"
                'Snapshots' = "$([math]::Round(($ArraySpaceMetrics.snapshots) / 1GB, 2)) GB"
                'Shared Space' = "$([math]::Round(($ArraySpaceMetrics.shared_space) / 1GB, 2)) GB"
                'System' = "$([math]::Round(($ArraySpaceMetrics.system) / 1GB, 2)) GB"
                'Data Reduction' = [math]::Round(($ArraySpaceMetrics.data_reduction), 2)
                'Total Reduction' = [math]::Round(($ArraySpaceMetrics.total_reduction), 2)
            }
            $ArraySpaceSummary | Table -Name 'Storage Summary' -List -ColumnWidths 50, 50
        }
    }
}