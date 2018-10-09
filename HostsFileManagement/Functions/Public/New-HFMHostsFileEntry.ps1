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