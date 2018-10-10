Function Save-HFMHostsFile{
    <#
    .SYNOPSIS
        Backup Hosts File
    .DESCRIPTION
        Backup Hosts File.
        By default Save-HFMHostsFiles as a 5 backup file retention. The 6th file will erase the first file.
    .EXAMPLE
        PS C:\> Get-HFMostsFile | Save-HFMHostsFile
        Will Create a backup of your current Hosts File in the default path hosting the hosts file.
    .EXAMPLE
        PS C:\> Get-HFMostsFile | Save-HFMHostsFile -BackupFolder c:\temp\ -LogRotation 10
        Will Create a backup of your current Hosts File. in the temp folder. LogRotation will be fixed to 10, so you can create up to 10 backups
    .INPUTS
        Input must be of type [HostsFile].
    .OUTPUTS
        File
    .NOTES
        There seem to be a bug in the HostsFileManagement file.
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