function Get-ABRPfaCurrentCertificateAttributes {
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
        $ArraySSLCertificate = Get-PfaCurrentCertificateAttributes -Array $Array
    }

    Process {
        if ($ArraySSLCertificate) {
            Paragraph "The following section provides information on the SSL certificate for $($ArrayAttributes.array_name)."
            Blankline
            $ArraySSLCertConfiguration = [PSCustomObject] @{
                'Status' = $ArraySSLCertificate.status
                'Issued To' = $ArraySSLCertificate.issued_to
                'Issued By' = $ArraySSLCertificate.issued_by
                'Valid from' = $ArraySSLCertificate.valid_from
                'Valid To' = $ArraySSLCertificate.valid_to
                'Locality' = $ArraySSLCertificate.locality
                'Country' = $ArraySSLCertificate.country
                'State' = $ArraySSLCertificate.state
                'Key Size' = $ArraySSLCertificate.key_size
                'Organisational Unit' = $ArraySSLCertificate.organizational_unit
                'Organisation' = $ArraySSLCertificate.organization
                'Email' = $ArraySSLCertificate.email
            }
            $ArraySSLCertConfiguration | Table -Name 'SSL Certificate' -List
        }
    }
}