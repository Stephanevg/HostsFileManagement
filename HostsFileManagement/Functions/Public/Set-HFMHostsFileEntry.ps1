
Function Set-HFMHostsFileEntry {
    <#
    .SYNOPSIS
        Add new entry/entries to hosts file.
    .DESCRIPTION
        Add new entry/entries to hosts file(s)
    .EXAMPLE
        PS C:\> $Host = Get-HFMHostsfile
        PS C:\> $Comment1 = New-HFMHostsFileEntry -IpAddress "20.0.0.0" -HostName "toto" -FullyQualifiedName "toto.com" -Description "ahahha" -EntryType Comment
        PS C:\> $Comment2 = New-HFMHostsFileEntry -IpAddress "21.0.0.0" -HostName "toto" -FullyQualifiedName "toto.com" -Description "ahahha" -EntryType Comment
        PS C:\> Set-HFMHostsFileEntry -Path $Host -Entries $Comment1,$Comment2

        Create 2 new [HostsEntry], and add them to the local hosts file.
        A backup is automatically created.
    .EXAMPLE
        PS C:\> $Comment1 = New-HFMHostsFileEntry -IpAddress "20.0.0.0" -HostName "toto" -FullyQualifiedName "toto.com" -Description "ahahha" -EntryType Comment
        PS C:\> "Computer1","Computer2" | Get-HFMHostsfile | Set-HFMHostsFileEntry -Entries $Comment1

        Create a new [HostsEntry], and add it to hostsfile on computer1, and computer2
    .INPUTS
        You must provide a valid path of type [HostsFile] and an entry of type [HostsEntry]
    .OUTPUTS
        
    .NOTES
        This cmdlet uses Class.HostsManagement classes, by @StephaneVG
        Fork hist project if you like it: https://github.com/Stephanevg/Class.HostsManagement
        Visit his site, and read his article a boute pratical use of PowerShell Classes: http://powershelldistrict.com/powershell-class/
    #>
    Param
    (
        [Parameter(Mandatory=$True,ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)]
        [HostsFile[]]$Path,
        [Parameter(Mandatory=$True)]
        [HostsEntry[]]$Entries
    )

    BEGIN{}

    PROCESS{

        Foreach ( $File in $Path ) {
            $File.ReadHostsFileContent()
            $File.AddHostsEntry($Entries)
            $File.Set()
        }
    }

    END{}
}
