---
external help file: HostsFileManagement-help.xml
Module Name: HostsFileManagement
online version:
schema: 2.0.0
---

# Get-HFMHostsfile

## SYNOPSIS
Get the hosts file of the desired hostname.

## SYNTAX

```
Get-HFMHostsfile [[-ComputerName] <String[]>] [<CommonParameters>]
```

## DESCRIPTION
Get the hostfile of the desired hostname.
By default the localhost hosts file is fetched.
You can specify a remote computer name.

## EXAMPLES

### EXEMPLE 1
```
Get-HFMHostsfile
```

Return a \[HostsFile\] object representing the local hosts file.

### EXEMPLE 2
```
Get-HFMHostsfile -Name Computer1
```

Return a \[HostsFile\] object representing the hosts file of Computer1.

### EXEMPLE 3
```
"Computer1","Computer2" | Get-HFMHostsfile
```

Return an array of \[HostsFile\] objects representing the hosts file of Computer1 and Computer2.

## PARAMETERS

### -ComputerName
{{Fill ComputerName Description}}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Name

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Input String.
## OUTPUTS

### Return [HostsFile] Object(s).
## NOTES
This cmdlet uses Class.HostsManagement classes, by @StephaneVG
Fork hist project if you like it: https://github.com/Stephanevg/Class.HostsManagement
Visit his site, and read his article a boute pratical use of PowerShell Classes: http://powershelldistrict.com/powershell-class/

## RELATED LINKS
