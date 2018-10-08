Function Get-HFMHostsfile {
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

Function New-HFMHostsFileEntry {
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

    [CmdletBinding()]
    Param
    (
        ## regex to match ip
        [Parameter(Mandatory=$False)]
        [String]$IpAddress,
        ## regex, no space etc..
        [Parameter(Mandatory=$False)]
        [String]$HostName,
        [Parameter(Mandatory=$False)]
        [String]$FullyQualifiedName,
        [Parameter(Mandatory=$False)]
        [String]$Description,
        [ValidateSet("Entry","Comment","BlankLine")]
        [Parameter(Mandatory=$True)]
        [String]$EntryType
    )

    Switch ($EntryType) {
        BlankLine {
            return [HostsEntry]::New()
        }

        Comment {
            return [HostsEntry]::New($IpAddress,$HostName,$FullyQualifiedName,$Description,[HostsEntryType]::Comment)
        }

        Entry {
            return [HostsEntry]::New($IpAddress,$HostName,$FullyQualifiedName,$Description,[HostsEntryType]::Entry)
        }
    }
}

Function Set-HFMHostsFileEntry {
    <#
     # Need Testing, hostfile is backedup and re-created
     #>
    [CmdletBinding(SupportsShouldProcess = $True, ConfirmImpact = 'High')]
    Param
    (
        [Parameter(Mandatory=$True,ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)]
        [HostsFile[]]$Path,
        [Parameter(Mandatory=$True)]
        [HostsEntry[]]$Entry

    )

    BEGIN{}

    PROCESS{
        If ($PSCmdlet.ShouldProcess($Path)) {
            Write-Output 'Your hosts file will be backedup and re-created with the specified entries...'
        }
        $Path.AddHostsEntry($Entry)
        $Path.Set()
    }

    END{}
}

<#
    New-HFMHostsFileEntry -> Creates an HostFileEntry object (Of type [HostsEntry])
    Set-HFMHostsFileEntry
    Set-HFMHostsFileEntry ->
    Save-HFMHostFileEntry
    New-HFMHostsFileBackup
#>

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



