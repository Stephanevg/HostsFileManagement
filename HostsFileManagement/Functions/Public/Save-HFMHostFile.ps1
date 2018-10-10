Function Save-HFMHostFile{
    <#
    .SYNOPSIS
        Backup Hosts File.
    .DESCRIPTION
        Backup Hosts File. By default the backup file will be stored in the system32\drivers\etc folder.
        You can use the BackupFolder to specify override the default behavior of the cmdlet.
        Hosts file backups are prefixed with a timestamp, and the name of the current computer.
        20181010-185510_COMPUTER1_Hosts.Bak 
    .EXAMPLE
        PS C:\> $a = Get-FHMHostsFile
        PS C:\> Save-HFMHostsFile -Path $a
        Creates a backup of your hosts file.
    .EXAMPLE
        PS C:\> Get-FHMHostsFile | Save-HFMHostFile -BackupFolder c:\temp
        Create a backup of your hosts file in the c:\temp folder. MaxLog
    .EXAMPLE
        PS C:\> "Computer1","Computer2" | Get-FHMHostsFile | Save-HFMHostsFile -BackupFolder c:\temp -MaxLogRotation 10
        Creates a backup of the named computer hosts files, in your c:\temp folder. Each computer can have a max of 10 .bak files.
    .INPUTS
        Input must be of type [HostsFile].
    .OUTPUTS
        File, extension .bak
    .NOTES
        Remember to run Powershell in elevated mode, if you must backup your current hosts file by using the following: Get-FHMHostsFile | Save-HFMHostFile
        Standard credential dont allow you to write inside the system32\drivers\etc folder.
    #>
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$True,ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)]
        [HostsFile[]]$Path,
        [Parameter(Mandatory=$False)]
        [System.IO.DirectoryInfo]$BackupFolder,
        [Parameter(Mandatory=$False)]
        [Int]$MaxLogRotation
    )

    BEGIN{}

    PROCESS{
        Foreach ( $HostPath in $Path ) {
            If ( $MaxLogRotation ) { $HostPath.LogRotation = $MaxLogRotation }
            If ( $BackupFolder ) {
                $HostPath.Backup($BackupFolder)
            } Else {
                $HostPath.Backup()
            }
        }
    }

    END{}
}