---
external help file: HostsFileManagement-help.xml
Module Name: HostsFileManagement
online version:
schema: 2.0.0
---

# Set-HFMHostsFileEntry

## SYNOPSIS
Add new entry/entries to hosts file.

## SYNTAX

```
Set-HFMHostsFileEntry [-Path] <HostsFile[]> [-Entries] <HostsEntry[]> [<CommonParameters>]
```

## DESCRIPTION
Add new entry/entries to hosts file(s)

## EXAMPLES

### EXEMPLE 1
```
$Host = Get-HFMHostsfile
```

PS C:\\\> $Comment1 = New-HFMHostsFileEntry -IpAddress "20.0.0.0" -HostName "toto" -FullyQualifiedName "toto.com" -Description "ahahha" -EntryType Comment
PS C:\\\> $Comment2 = New-HFMHostsFileEntry -IpAddress "21.0.0.0" -HostName "toto" -FullyQualifiedName "toto.com" -Description "ahahha" -EntryType Comment
PS C:\\\> Set-HFMHostsFileEntry -Path $Host -Entries $Comment1,$Comment2

Create 2 new \[HostsEntry\], and add them to the local hosts file.
A backup is automatically created.

### EXEMPLE 2
```
$Comment1 = New-HFMHostsFileEntry -IpAddress "20.0.0.0" -HostName "toto" -FullyQualifiedName "toto.com" -Description "ahahha" -EntryType Comment
```

PS C:\\\> "Computer1","Computer2" | Get-HFMHostsfile | Set-HFMHostsFileEntry -Entries $Comment1

Create a new \[HostsEntry\], and add it to hostsfile on computer1, and computer2

## PARAMETERS

### -Path
{{Fill Path Description}}

```yaml
Type: HostsFile[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Entries
{{Fill Entries Description}}

```yaml
Type: HostsEntry[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### You must provide a valid path of type [HostsFile] and an entry of type [HostsEntry]
## OUTPUTS

## NOTES
This cmdlet uses Class.HostsManagement classes, by @StephaneVG
Fork hist project if you like it: https://github.com/Stephanevg/Class.HostsManagement
Visit his site, and read his article a boute pratical use of PowerShell Classes: http://powershelldistrict.com/powershell-class/

## RELATED LINKS
