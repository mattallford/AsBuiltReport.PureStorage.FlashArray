function Get-AbrPureStorageArray {
    <#
    .SYNOPSIS
    Used by As Built Report to retrieve Array information from a Pure Storage FlashArray API

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
        $URI = "$BaseUri/array"
    }

    process {
        try {
            $PureStorageFAArray = Invoke-RestMethod -Method Get -Uri $URI -WebSession $apiSession
        } catch {

        }

        if ($PureStorageFAArray) {
            Paragraph "The following section provides a summary of the Pure Storage FlashArray"
            BlankLine
            $FlashArrayConfig = [PSCustomObject] @{
                "Array Name" = $PureStorageFAArray.array_name
                "Array ID" = $PureStorageFAArray.ID
                "Purity Version" = $PureStorageFAArray.version
            }
            $FlashArrayConfig | Table -Name "FlashArray Array Information" -List
        }
    }

}