function Get-ABRPfaControllers {
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
        $ArrayControllers = Get-PfaControllers -Array $Array
    }

    Process {
        if ($ArrayControllers) {
            Paragraph "The following section provides a summary of the controllers in $($ArrayAttributes.array_name)."
            BlankLine
            $ArrayControllerSummary = foreach ($ArrayController in $ArrayControllers) {
                [PSCustomObject] @{
                    'Name' = $ArrayController.name
                    'Mode' = $ArrayController.mode
                    'Model' = $ArrayController.model
                    'Purity Version' = $ArrayController.version
                    'Status' = $ArrayController.status
                }
            }
            $ArrayControllerSummary | Sort-Object -Property Name | Table -Name 'Controller Summary'
        }
    }
}