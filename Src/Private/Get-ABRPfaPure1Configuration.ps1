function Get-ABRPfaPure1Configuration {
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
    }

    Process {
        Paragraph "The following section provides information on the Pure1 Support configuration for $($ArrayAttributes.array_name)."
        Blankline
        $ArrayPure1Configuration = [PSCustomObject] @{
            'Phone Home Status' = (Get-PfaPhoneHomeStatus -Array $array).phonehome
            'Remote Assist Status' = (Get-PfaRemoteAssistSession -Array $array).status
            'Proxy Server' = (Get-PfaProxy -Array $Array).proxy
        }
        $ArrayPure1Configuration | Table -Name 'Pure1 Configuration' -List -ColumnWidths 50, 50 
    }
}