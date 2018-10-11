Function Remove-HFMHostsFileEntry {
    <#
    .SYNOPSIS
        Short description
    .DESCRIPTION
        Long description
    .EXAMPLE
        PS C:\> <example usage>
        Explanation of what the example does
    .INPUTS
        Inputs (if any)
    .OUTPUTS
        Output (if any)
    .NOTES
        General notes
    #>
    #[CmldetBinding()]
    Param
    (
        [Parameter(Mandatory=$True,ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)]
        [HostsFile[]]$Path,
        [Parameter(Mandatory=$True,ValueFromPipeline=$True)]
        ## Accepte string ou [HostEntry]
        [Object[]]$Entries ## m en fou de stephanexD
    )

    BEGIN{}

    PROCESS{

        Foreach ( $File in $Path ) {

            Switch ( $Entries ) {

                ({ $PSItem.GetType().FullName -eq 'System.String' }) {
                    $HostsEntry = [HostsEntry]::New($PSItem)
                    $File.RemoveHostsEntry($HostsEntry)
                }

                ({ $PSItem.GetType().FullName -eq 'HostsEntry'}) {
                    $File.RemoveHostsEntry($PSItem)
                }

                Default { Throw "Entries must be of type System.String or HostsEntry" }
            }

        }
    }

    END{}
}
