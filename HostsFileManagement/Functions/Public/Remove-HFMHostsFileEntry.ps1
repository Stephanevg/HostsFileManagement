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
        [Parameter(Mandatory=$True)]
        ## Accepte string ou [HostEntry]
        [Object[]]$Entries
    )

    BEGIN{}

    PROCESS{
        Foreach ( $File in $Path ) {

            Switch ( $Entries ) {

                ({ $PSItem.GetType().FullName -eq 'System.String' }) {
                    $HostsEntry = [HostsEntry]::New($PSItem)
                    If ( $null -eq $File.entries) {
                        Throw "Please run Get-HFMHostsFileContent first..."
                    } Else {
                        ## Is Current Entry present in file.entries, add it to TobeRemoved Array
                        $File.entries | Where-Object { ($_.Ipaddress -eq $HostsEntry.Ipaddress) -and ($_.EntryType -eq $HostsEntry.EntryType)} | %{ $ToBeRemove+=$_ }
                    }
                    Break;
                }

                ({ $PSItem.GetType().FullName -eq 'HostsEntry'}) {
                    $HostsEntry = $PSitem
                    ## Is Current Entry present in file.entries, add it to TobeRemoved Array
                    $File.entries | Where-Object { ($PSItem.Iaddress -eq $HostsEntry.IpAddress) -and ($PSItem.EntryType -eq $HostsEntry.EntryType)} | %{ $ToBeRemove+=$_ }
                    Break;
                }

                Default { Throw "Entries must be of type System.String or HostsEntry"; Break }
            }

            ## Remove entries
            $File.RemoveHostsEntry($ToBeRemove)
        }
    }

    END{}
}
