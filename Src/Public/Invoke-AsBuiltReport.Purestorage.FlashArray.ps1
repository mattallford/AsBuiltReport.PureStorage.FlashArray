function Invoke-AsBuiltReport.PureStorage.FlashArray {
    <#
    .SYNOPSIS
        PowerShell script which documents the configuration of Pure Storage FlashArray in Word/HTML/XML/Text formats
    .DESCRIPTION
        Documents the configuration of Pure Storage FlashArray in Word/HTML/XML/Text formats using PScribo.
    .NOTES
        Version:        0.4.1
        Author:         Matt Allford
        Twitter:        @mattallford
        Github:         https://github.com/mattallford
        Credits:        Iain Brighton (@iainbrighton) - PScribo module
                        Tim Carman (@tpcarman) - Wrote original report for Pure Storage

    .LINK
        https://github.com/AsBuiltReport/AsBuiltReport.PureStorage.FlashArray
    #>

    #region Script Parameters
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string[]] $Target,

        [Parameter(Mandatory=$true)]
        [pscredential] $Credential,

        [Parameter(Mandatory=$false)]
        [string] $StylePath
    )

    # If custom style not set, use default style
    if (!$StylePath) {
        & "$PSScriptRoot\..\..\AsBuiltReport.Purestorage.FlashArray.Style.ps1"
    }

    $FlashArray = $Null
    
    foreach ($FlashArray in $Target) {
        #Connect to Pure Storage Array using supplied credentials via the API
        Try {
            # Allow the connection to complete if the endpoint has an untrusted certificate
        add-type @"
        using System.Net;
        using System.Security.Cryptography.X509Certificates;
        public class TrustAllCertsPolicy : ICertificatePolicy {
            public bool CheckValidationResult(
                ServicePoint srvPoint, X509Certificate certificate,
                WebRequest request, int certificateProblem) {
                return true;
            }
        }
"@
        
        # Ensure TLS12 is added to the Security Protocol
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

        # Allow connections to endpoints with untrusted certificates
        [System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy

        # Build a variable for the BaseUri to use through the rest of the tool
        $BaseUri = "https://$FlashArray/api/1.15"

        # Build the Body to use in the API Token Method Post
        $PureAuthAction = @{
            'username' = $($Credential.UserName);
            'password' = "$($Credential.GetNetworkCredential().Password)"
        }

        # Retrieve the API token from the FlashArray endpoint using the credentials supplied
        $ApiToken = Invoke-RestMethod -Method Post -Uri "$BaseUri/auth/apitoken" -Body $PureAuthAction

        # Build a session action to be used in the next Post to create a session
        $SessionAction = @{
            api_token = $ApiToken.api_token
        }

        # Create a web session to be reused throughout the rest of the script when calling the FlashArray API
        Invoke-RestMethod -Method Post -Uri "$BaseUri/auth/session" -Body $SessionAction -SessionVariable Session
        } Catch {
            Write-Error $_
        }

        # If creating the session was successful, query the API to pull the configuration information
        if ($Session) {

            Section -Style Heading1 $FlashArray {
                if ($ArrayInfo = Get-AbrPureStorageArray -BaseUri $BaseUri -apiSession $Session) {
                    Section -Style Heading2 'Array Summary' {
                        $ArrayInfo
                    }
                }

                if ($ControllerInfo = Get-AbrPureStorageArrayController -BaseUri $BaseUri -apiSession $Session) {
                    Section -Style Heading2 'Controller Summary' {
                        $ControllerInfo
                    }
                }
            }

        }#End if $Array

        #Clear the $Array variable ready for reuse for a connection attempt on the next foreach loop
        Clear-Variable -Name FlashArray
        #Delete the REST session
        #Invoke-RestMethod -Method Delete -Uri "$BaseUri/auth/session"

    }#End foreach $FlashArray in $Target

}#End Function Invoke-AsBuiltReport.PureStorage.FlashArray