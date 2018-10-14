---
external help file: HostsFileManagement-help.xml
Module Name: HostsFileManagement
online version:
schema: 2.0.0
---

# Save-HFMHostFile

## SYNOPSIS
Backup Hosts File.

## SYNTAX

```
Save-HFMHostFile [-Path] <HostsFile[]> [[-BackupFolder] <DirectoryInfo>] [[-MaxLogRotation] <Int32>]
 [<CommonParameters>]
```

## DESCRIPTION
Backup Hosts File.
By default the backup file will be stored in the system32\drivers\etc folder.
You can use the BackupFolder to specify override the default behavior of the cmdlet.
Hosts file backups are prefixed with a timestamp, and the name of the current computer.
20181010-185510_COMPUTER1_Hosts.Bak

## EXAMPLES

### EXEMPLE 1
```
$a = Get-FHMHostsFile
```

PS C:\\\> Save-HFMHostsFile -Path $a
Creates a backup of your hosts file.

### EXEMPLE 2
```
Get-FHMHostsFile | Save-HFMHostFile -BackupFolder c:\temp
```

Create a backup of your hosts file in the c:\temp folder.
MaxLog

### EXEMPLE 3
```
"Computer1","Computer2" | Get-FHMHostsFile | Save-HFMHostsFile -BackupFolder c:\temp -MaxLogRotation 10
```

Creates a backup of the named computer hosts files, in your c:\temp folder.
Each computer can have a max of 10 .bak files.

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

### -BackupFolder
{{Fill BackupFolder Description}}

```yaml
Type: DirectoryInfo
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MaxLogRotation
{{Fill MaxLogRotation Description}}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Input must be of type [HostsFile].
## OUTPUTS

### File, extension .bak
## NOTES
Remember to run Powershell in elevated mode, if you must backup your current hosts file by using the following: Get-FHMHostsFile | Save-HFMHostFile
Standard credential dont allow you to write inside the system32\drivers\etc folder.

## RELATED LINKS
