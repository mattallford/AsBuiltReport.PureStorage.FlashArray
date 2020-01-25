function Get-AbrPureStorageArrayController {
    <#
    .SYNOPSIS
    Used by As Built Report to retrieve Array controller information from a Pure Storage FlashArray API

    .DESCRIPTION

    .EXAMPLE
    

    .NOTES
        Version:        0.0.1
        Author:         Matt Allford
        Twitter:        @mattallford
        Github:         mattallford

    .LINK
        
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [String] $BaseUri,

        [Parameter(Mandatory=$true)]
        $apiSession
    )

    begin {
        $URI = "$BaseUri/array?controllers=true"
    }

    process {
        try {
            $PureStorageFAArrayControllers = Invoke-RestMethod -Method Get -Uri $URI -WebSession $apiSession
        } catch {

        }

        if ($PureStorageFAArrayControllers) {
            Paragraph "The following section provides a summary of the Pure Storage FlashArray Controllers"
            BlankLine
            $FlashArrayControllerConfig = foreach ($Controller in $PureStorageFAArrayControllers) {
                [PSCustomObject] @{
                "Controller Name" = $Controller.name
                "Model" = $Controller.model
                "Status" = $Controller.status
                "Version" = $Controller.Version
                "Mode" = $Controller.mode
                "Type" = $Controller.type
                }
            }
            $FlashArrayControllerConfig | Table -Name "FlashArray Controller Information"
        }
    }

}