function Get-ABRPfaProtectionGroupSchedules {
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
        $ArrayProtectionGroupSchedules = Get-PfaProtectionGroupSchedules -Array $Array
    }

    Process {
        if ($ArrayProtectionGroupSchedules) {
            Paragraph "The following section provides information on the protection group snapshot and replication schedules on $($ArrayAttributes.array_name)."
            BlankLine
            $ArrayProtectionGroupScheduleConfiguration = foreach ($ArrayProtectionGroupSchedule in $ArrayProtectionGroupSchedules) {
                [PSCustomObject] @{
                    'Name' = $ArrayProtectionGroupSchedule.name
                    'Snapshot Enabled' = $ArrayProtectionGroupSchedule.snap_enabled
                    'Snapshot Frequency (Mins)' = ($ArrayProtectionGroupSchedule.snap_frequency / 60)
                    'Snapshot At' = $ArrayProtectionGroupSchedule.snap_at
                    'Replication Enabled' = $ArrayProtectionGroupSchedule.replicate_enabled
                    'Replication Frequency (Mins)' = ($ArrayProtectionGroupSchedule.replicate_frequency / 60)
                    'Replicate At' = $ArrayProtectionGroupSchedule.replicate_at
                    'Replication Blackout Times' = $ArrayProtectionGroupSchedule.replicate_blackout
                }
            }
            $ArrayProtectionGroupScheduleConfiguration | Sort-Object -Property Name | Table -Name 'Protection Group Schedule'
        }
    }
}