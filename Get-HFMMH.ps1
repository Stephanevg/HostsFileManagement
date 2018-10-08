Function Get-HFMHostsfile {
    [CmdletBinding()]
    Param
    (
        [Alias("Name")]
        [Parameter(Mandatory=$False,ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)]
        [String[]]$ComputerName
    )

    BEGIN{}

    PROCESS{
        If ( !$ComputerName ) {
            return [HostsFile]::New()
        } Else {
            Return [HostsFile]::New($ComputerName)
        }
    }

    END{}
}

Function Get-HFMHostsFileContent {
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$True,ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)]
        [HostsFile[]]$Path
    )

    BEGIN {}

    PROCESS {
        $Path.ReadHostsFileContent()
        return $Path.GetEntries()
    }

    END {}
}

<#
Example 1:
$a = Get-HFMHostsfile -ComputerName Localhost
Get-HFMHostsFileContent -Path $a

Example 2:
$a = Get-HFMHostsfile
Get-HFMHostsFileContent $a

Example 3
Get-HFMHostsfile | Get-HFMHostsFileContent

Example 4
"localhost" | Get-HFMHostsfile | Get-HFMHostsFileContent
#>



