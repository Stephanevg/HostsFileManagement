Function Remove-HFMHostsFileEntry {
    <#
    .SYNOPSIS
        Remove entry/entries from a Hosts File
    .DESCRIPTION
        Remove entry/entries from a Hosts File
    .EXAMPLE
        PS C:\> Get-HFMHostsFile | Remove-HFMHostsFileEntry -Entry "#5.0.0.0"
        Will remove any Comment line with ip 5.0.0.0
    .EXAMPLE
        PS C:\> $a = Get-HFMHostsFile
        PS C:\> $b = New-HFMHostsFileEntry -IpAddress "20.0.0.0" -EntryType Entry
        PS C:\> Remove-HFMHostsFileEntry -Path $a -Entry $b
        Will remove any Entry line With IpAdress starting with 20.0.0.0
    .EXAMPLE
        PS C:\> Get-HFMHostsFile | Remove-HFMHostsFileEntry -Entry "#5.0.0.0","20.0.0.0"
        Will remove any Comment line wich start with commented ipadress #5.0.0.0 or 20.0.0.0
    .INPUTS
        You must provide a valid path of type [HostsFile] and an entry of type [HostsEntry] or a [String] representing an ipaddress or a comment.
    .OUTPUTS
        -
    .NOTES
        This cmdlet uses Class.HostsManagement classes, by @StephaneVG
        Fork and star his project if you like it: https://github.com/Stephanevg/Class.HostsManagement
        Visit his site, and read his article a boute pratical use of PowerShell Classes: http://powershelldistrict.com/powershell-class/
    #>
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$True,ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)]
        [HostsFile[]]$Path,
        [Parameter(Mandatory=$True)]
        ## Accepte string ou [HostEntry]
        [Object[]]$Entry
    )

    BEGIN{}

    PROCESS{
        Foreach ( $File in $Path ) {

            If ( $null -eq $File.Entries ) {
                $File.ReadHostsFileContent()
            }

            $ToBeRemoved = @()

            Switch ( $Entry ) {

                ({ $PSItem.GetType().FullName -eq 'System.String' }) {
                    If ( $PSItem -Match '^\s+$' ) { Throw "Entry can not be a string only made of spaces..."}
                    $HostsEntry = [HostsEntry]::New($PSItem)
                    ## Is Current Entry present in file.entries, add it to TobeRemoved Array
                    $File.entries | Where-Object { ($_.Ipaddress -eq $HostsEntry.Ipaddress) -and ($_.EntryType -eq $HostsEntry.EntryType)} | %{ $ToBeRemoved+=$_ }
                    Continue;
                }

                ({ $PSItem.GetType().FullName -eq 'HostsEntry'}) {
                    $HostsEntry = $PSitem
                    ## Is Current Entry present in file.entries, add it to TobeRemoved Array
                    $File.entries | Where-Object { ($PSItem.Iaddress -eq $HostsEntry.IpAddress) -and ($PSItem.EntryType -eq $HostsEntry.EntryType)} | %{ $ToBeRemoved+=$_ }
                    Continue;
                }

                Default { Throw "Entries must be of type System.String or HostsEntry"; Break }
            }

            ## Remove entries
            $File.RemoveHostsEntry($ToBeRemoved)
        }
    }

    END{}
}
