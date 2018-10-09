Function Get-HFMHostsfile {
    <#
    .SYNOPSIS
        Get the hosts file of the desired hostname.
    .DESCRIPTION
        Get the hostfile of the desired hostname.
        By default the localhost hosts file is fetched. You can specify a remote computer name.
    .EXAMPLE
        PS C:\> Get-HFMHostsfile
        Return a [HostsFile] object representing the local hosts file.
    .EXAMPLE
        PS C:\> Get-HFMHostsfile -Name Computer1
        Return a [HostsFile] object representing the hosts file of Computer1.
    .EXAMPLE
        PS C:\> "Computer1","Computer2" | Get-HFMHostsfile
        Return an array of [HostsFile] objects representing the hosts file of Computer1 and Computer2.
    .INPUTS
        Input String.
    .OUTPUTS
        Return [HostsFile] Object(s).
    .NOTES
        This cmdlet uses Class.HostsManagement classes, by @StephaneVG
        Fork hist project if you like it: https://github.com/Stephanevg/Class.HostsManagement
        Visit his site, and read his article a boute pratical use of PowerShell Classes: http://powershelldistrict.com/powershell-class/
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
        Read the Host file content.
    .DESCRIPTION
        Read the Host file content. Take input from Get-HFMHostsFile.
    .EXAMPLE
        PS C:\> $a = Get-HFMHostsFile
        PS C:\> Get-HFMHostsFileContent -Path $a
        Use Get-HFMHostsFile to get a [HostsFile] object
        Use Get-HFMHostFileContent to return a [HostsEntry] object(s)
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
        Create a new Hosts File Entry.
    .DESCRIPTION
        Create a new Hosts File Entry.
    .EXAMPLE
        PS C:\> $NewEntry = New-HFMHostsFileEntry -IpAddress "20.0.0.0" -HostName "toto" -FullyQualifiedName "toto.com" -Description "ahahha" -EntryType Comment
        Create a new comment entry.
    .INPUTS
        Mostly Strings.
    .OUTPUTS
        A [HostsEntry] object.
    .NOTES
        This cmdlet uses Class.HostsManagement classes, by @StephaneVG
        Fork hist project if you like it: https://github.com/Stephanevg/Class.HostsManagement
        Visit his site, and read his article a boute pratical use of PowerShell Classes: http://powershelldistrict.com/powershell-class/
    #>

    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$False)]
        [String]$IpAddress,
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

        Foreach ($File in $path ) {
            $File.ReadHostsFileContent()
            $File.AddHostsEntry($Entries)
            $File.Set()
        }
    }

    END{}
}

<#
Remove-Module Get-HFMMH;Import-Module .\Get-HFMMH.ps1;
$h = Get-HFMHostsfile
$n = New-HFMHostsFileEntry -IpAddress "20.0.0.0" -HostName "toto" -FullyQualifiedName "toto.com" -Description "ahahha" -EntryType Comment
$m = New-HFMHostsFileEntry -IpAddress "21.0.0.0" -HostName "toto" -FullyQualifiedName "toto.com" -Description "ahahha" -EntryType Comment
Set-HFMHostsFileEntry -Path $h -Entries $n,$m

$h.GetEntries()
$h.addHostEntries()
$h.set()

"localhost","L-FRA-370397" | Get-HFMHostsfile | Set-HFMHostsFileEntry -Entries $n,$m

#>