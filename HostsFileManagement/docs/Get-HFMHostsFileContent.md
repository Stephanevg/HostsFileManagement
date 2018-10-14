---
external help file: HostsFileManagement-help.xml
Module Name: HostsFileManagement
online version:
schema: 2.0.0
---

# Get-HFMHostsFileContent

## SYNOPSIS
Read the Host file content.

## SYNTAX

```
Get-HFMHostsFileContent [-Path] <HostsFile[]> [-ExcludeComments] [<CommonParameters>]
```

## DESCRIPTION
Read the Host file content.
Take input from Get-HFMHostsFile.

## EXAMPLES

### EXEMPLE 1
```
$a = Get-HFMHostsFile
```

PS C:\\\> Get-HFMHostsFileContent -Path $a
Use Get-HFMHostsFile to get a \[HostsFile\] object
Use Get-HFMHostFileContent to return a \[HostsEntry\] object(s)

### EXEMPLE 2
```
Get-HFMHostsFile | Get-HFMHostsFileContent -ExcludeComments
```

List HostsFile entrie, but exclude comments

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

### -ExcludeComments
{{Fill ExcludeComments Description}}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Input must be of type [HostsFile].
## OUTPUTS

### Return [HostsEntry] Object(s).
## NOTES
This cmdlet uses Class.HostsManagement classes, by @StephaneVG
Fork hist project if you like it: https://github.com/Stephanevg/Class.HostsManagement
Visit his site, and read his article a boute pratical use of PowerShell Classes: http://powershelldistrict.com/powershell-class/

## RELATED LINKS
