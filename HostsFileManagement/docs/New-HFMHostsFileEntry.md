---
external help file: HostsFileManagement-help.xml
Module Name: HostsFileManagement
online version:
schema: 2.0.0
---

# New-HFMHostsFileEntry

## SYNOPSIS
Create a new Hosts File Entry.

## SYNTAX

```
New-HFMHostsFileEntry [[-IpAddress] <String>] [[-HostName] <String>] [[-FullyQualifiedName] <String>]
 [[-Description] <String>] [-EntryType] <String> [<CommonParameters>]
```

## DESCRIPTION
Create a new Hosts File Entry.

## EXAMPLES

### EXEMPLE 1
```
$NewEntry = New-HFMHostsFileEntry -IpAddress "20.0.0.0" -HostName "toto" -FullyQualifiedName "toto.com" -Description "ahahha" -EntryType Comment
```

Create a new comment entry.

## PARAMETERS

### -IpAddress
{{Fill IpAddress Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -HostName
{{Fill HostName Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FullyQualifiedName
{{Fill FullyQualifiedName Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
{{Fill Description Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EntryType
{{Fill EntryType Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Mostly Strings.
## OUTPUTS

### A [HostsEntry] object.
## NOTES
This cmdlet uses Class.HostsManagement classes, by @StephaneVG
Fork hist project if you like it: https://github.com/Stephanevg/Class.HostsManagement
Visit his site, and read his article a boute pratical use of PowerShell Classes: http://powershelldistrict.com/powershell-class/

## RELATED LINKS
