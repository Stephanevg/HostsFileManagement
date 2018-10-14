---
external help file: HostsFileManagement-help.xml
Module Name: HostsFileManagement
online version:
schema: 2.0.0
---

# Remove-HFMHostsFileEntry

## SYNOPSIS
Remove entry/entries from a Hosts File

## SYNTAX

```
Remove-HFMHostsFileEntry [-Path] <HostsFile[]> [-Entry] <Object[]> [<CommonParameters>]
```

## DESCRIPTION
Remove entry/entries from a Hosts File

## EXAMPLES

### EXEMPLE 1
```
Get-HFMHostsFile | Remove-HFMHostsFileEntry -Entry "#5.0.0.0"
```

Will remove any Comment line with ip 5.0.0.0

### EXEMPLE 2
```
$a = Get-HFMHostsFile
```

PS C:\\\> $b = New-HFMHostsFileEntry -IpAddress "20.0.0.0" -EntryType Entry
PS C:\\\> Remove-HFMHostsFileEntry -Path $a -Entry $b
Will remove any Entry line With IpAdress starting with 20.0.0.0

### EXEMPLE 3
```
Get-HFMHostsFile | Remove-HFMHostsFileEntry -Entry "#5.0.0.0","20.0.0.0"
```

Will remove any Comment line wich start with commented ipadress #5.0.0.0 or 20.0.0.0

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

### -Entry
Accepte string ou \[HostEntry\]

```yaml
Type: Object[]
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

### You must provide a valid path of type [HostsFile] and an entry of type [HostsEntry] or a [String] representing an ipaddress or a comment.
## OUTPUTS

### -
## NOTES
This cmdlet uses Class.HostsManagement classes, by @StephaneVG
Fork and star his project if you like it: https://github.com/Stephanevg/Class.HostsManagement
Visit his site, and read his article a boute pratical use of PowerShell Classes: http://powershelldistrict.com/powershell-class/

## RELATED LINKS
