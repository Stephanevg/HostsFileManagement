Function Get-HFMHostsFileContent {
    <#
    .SYNOPSIS
        Read the Host file content.
    .DESCRIPTION
        Read the Host file content. Take input from Get-HFMHostsFile.
    .EXAMPLE
        PS C:\> $a = Get-HFMHostsFile
        PS C:\> Get-HFMHostsFileContent -Path $a
        Use Get-HFMHostsFile to get a [HostsFile] object
        Use Get-HFMHostFileContent to return a [HostsEntry] object(s)
    .EXAMPLE
        PS C:\> Get-HFMHostsFile | Get-HFMHostsFileContent -ExcludeComments
        List HostsFile entrie, but exclude comments
    .INPUTS
        Input must be of type [HostsFile].
    .OUTPUTS
        Return [HostsEntry] Object(s).
    .NOTES
        This cmdlet uses Class.HostsManagement classes, by @StephaneVG
        Fork hist project if you like it: https://github.com/Stephanevg/Class.HostsManagement
        Visit his site, and read his article a boute pratical use of PowerShell Classes: http://powershelldistrict.com/powershell-class/
    #>

    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$True,ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)]
        [HostsFile[]]$Path,
        [Parameter(Mandatory=$False)]
        [Switch]$ExcludeComments = $False
    )

    BEGIN {}

    PROCESS {
        Foreach ( $HostPath in $Path ) {
            $HostPath.ReadHostsFileContent()
            If ( $ExcludeComments ) {
                return $($HostPath.GetEntries() | Where-ObJect EntryType -ne "Comment")
            } Else {
                return $HostPath.GetEntries()
            }
        }
    }

    END {}
}