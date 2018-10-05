
Manage local and remote Hosts file(s) using Powershell.

This modules helps to read, parse, save, edit, and backup your local or remote HOSTS file.
The main advantage of this module is that it makes converts the 'unstructured' HOSTS file, into a rich object.
It becomes easy to filter a HOSTS file to find entries that are double, incorrect, or that need to be deleted.
New entries can easily be added as well.


## Read my blog post about the details:

If you are interested in the details of this module, want to learn about it's history, and improve your knowledge about powershell classes, I have writen an extensive documentation on my blog. You can find it on [PowerShellDistrict-ManagingHostsFile](http://powershelldistrict.com/managing-hosts-file-using-powershell-classes/)


## Module composition:

The module is composed of the following components:
- HostsFile (Class)
Represents in instance of a HOSTS file (Can be local, or remote).

- HostsEntry (Class)
Represents an instance of a HOSTS file entry (a simple line of a HOSTS file).

- HostsEntryType (Enum)
Represents the type of the HOSTS Entry line.




The difference classes (and Enum(s)) represent the logical structure of a HOSTS file and it's content.
A HostsFile points to a file (which is by default, but not necessarly, located at "c:\System32\drivers\etc\hosts".


## HostsFile Entries

The HostsFile contains several entries (or lines). Each Hosts file entry is an object of  any of the  types in the 'HostsEntryType' Enum, which are the following ones.

### Entry:
It can be a regular entry. It links an IP address to a HostsName, and a Full qualified name. Additionnaly, it can have a comment at the end to give additional information about the entry.

### Comment:
A comment in the HOSTS file starts with the symbol # (pound). A comment can either be used to comment a Hosts entry, or to delimit a header section, in order to group entries logically together.

### BlankLine:
A hosts file can contain blank lines to separate the different entries and comments, in order to create a more friendly to read structure.

## How to use this module (Highlevel overview)

  ### Read a hosts file:
    1. Create an instance of the [Hostsfile] class
    2. Call the GetHostsEntries Method

  ### Add an entry to the hosts file:
    1. Create an entry using the [HostsEntry]
    2. Add the Entry to a hosts file loaded through the [HostsFile] class using the .AddHostsEntry([HostsEntry[]]$Entries) method.
    3. use .set() method on HostsFile to persist the changes into Hosts file.

  ### Remove an entry to the hosts file:
    1) Create an entry using the [HostsEntry] / filter to find the entry to remove.
    2) Remove the entry using the .RemoveHostsEntry([HostsEntry[]]$Entries) method.
    3) use .set() method on HostsFile to persist the changes into Hosts file.

  It is possible to have a verbose output using the following command:
    $VerbosePreference = "Continue"

## Structure of this module:

The structure of an object that this module would get/generate is the following:

[HostsFile]

&nbsp;&nbsp;&nbsp;|--> [HostsEntry]

&nbsp;&nbsp;&nbsp;|--> [HostsEntry]

&nbsp;&nbsp;&nbsp;|--> [HostsEntry]

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;--> [HostsEntryType]

## EXAMPLES

## Prerequisites: Loading the module
### Load the module (if module located in path contained in $Env:PSmodulepath)
```powershell
    Using module ClassHostsManagement.psd1
```

### Load the module (if module **not** located in path contained in $Env:PSmodulepath)
```powershell
    Using module <PathToFile>\ClassHostsManagement.psd1
```
## Reading Entries

  ## Reading HostsFile entries (Constructor -> [HostsFile]::())
  ```powershell
    $HostsFile = [HostsFile]::new()  #Loads the path to the local HOSTS file into memory.         
    $HostsFile.ReadHostsFileContent() # Loads all the entries into memory in a hidden property called "Entries".
    $HostsFile.GetEntries() #Display all entries loaded into memory.
```

## Reading HostsFile entries from alternate path (Constructor -> [HostsFile]::($Item [System.IO.FileSystemInfo]))
```powershell
    $Item = Get-Item "C:\MyFiles\Backups\20170418-143835_Hosts.bak"
    $HostsFile = [HostsFile]::new($Item) #Loads a backup HOSTS file into memory. Needs variable of type System.IO.FileSystemInfo.       
    $HostsFile.ReadHostsFileContent() # Loads all the entries into memory in a hidden property called "Entries".
    $HostsFile.GetEntries() #Display all entries loaded into memory.
```
  ## Reading HostsFile entries from remote computer (Constructor -> [HostsFile]::($ComputerName [String]))
```powershell
    $HostsFile = [HostsFile]::("Server02")
    $HostsFile.ReadHostsFileContent() # Loads all the entries into memory in a hidden property called "Entries".
    $HostsFile.GetEntries() #Display all entries loaded into memory.
```
## Creating Backups

  ## Creating a backup of local hosts file and save to default location
    The backup will be created in the same folder that holds the current HOSTS folder (defined through the Path Property).
```Powershell
    $HostsFile = [HostsFile]::new()  #Loads the path to the local HOSTS file into memory.         
    $HostsFile.ReadHostsFileContent() # Loads all the entries into memory in a hidden property called "Entries".
    $HostsFile.Backup() #Creates a backup of the current data located into memory (Entries) respecting the following format: YYYYMMDD-HHmmss_Hosts.bak
```
  ## Creating a backup of local hosts file and save to alternate location

    Use this method create a backp of the HOSTS file content located in memory (Visible Through getEntries()) to a seperate location. 

```powershell

    $HostsFile = [HostsFile]::new()  #Loads the path to the local HOSTS file into memory.         
    $HostsFile.ReadHostsFileContent() # Loads all the entries into memory in a hidden property called "Entries".
    $folder = Get-Item -Path C:\Temp\backup
    $HostsFile.Backup($Folder)
```
## Creating New Entries (using ```[HostsEntry]::New```)

  ### Creating a new HOSTS entry 

```powershell

    $IpAddress = "192.168.2.2"
    $HostName = "Computer02"
    $fqdn = "Computer02.powershelldistrict.com"
    $Description = "Awesome Server"
    $Entry = [HostsEntry]::new($IpAddress,$HostName,$fqdn,$Description,[HostsEntryType]::Entry)
```
    #Effective line in HOSTS file: 
      ```192.168.2.1		Computer01		Computer01.powershelldistrict.com #Awesome Server```


### Creating a HOSTS comment (HostsTypeEntry -eq Comment)

Creating a HostsEntry is the first step towards adding a HOSTS entry to your Local or remote Hosts file.
once the  Hostsentry is created, it will need to be added to one or more HostsEntries. This is done through the method ```AddHostsEntry()```.(See, Adding HostsEntries)

```powershell
    $IpAddress = "192.168.2.2"
    $HostName = "Computer02"
    $fqdn = "Computer02.powershelldistrict.com"
    $Description = "This line is commented out"
    $Entry = [HostsEntry]::new($IpAddress,$HostName,$fqdn,$Description,[HostsEntryType]::Comment)
```
    Effective line in HOSTS file (once Added): 
```#192.168.2.2		Computer02		Computer02.powershelldistrict.com #This line is commented out```

  ### Creating a blank line
```powershell
$Entry = [HostsEntry]::new()
```
### Creating a line containing only a comment (section / title purpose)

```powershell
    $Entry = [HostsEntry]::new("All Primary Servers",[HostsEntryType]::comment)
```

Effective line in HOSTS file (Once Added):
      ```#All primary Servers```

## Adding Entries:

Adding entries to the HostsFile,allows to add HostsEntry items to be added to one or more hosts file(s).

```Powershell 
  #Adding entries to the HostsFile
    $Entries = @()
    $Entries += [HostsEntry]::new("138.190.39.52		District234		District234.powershelldistrict.com #Woop")
    $Entries += [HostsEntry]::new("138.190.39.53		District235		District235.powershelldistrict.com #Woop")
    $Entries += [HostsEntry]::new("138.190.39.54		District236		District236.powershelldistrict.com #Woop")
    
    $HostFile.AddHostsEntry($Entries)
```


## Removing Entries 

  ### Removing Hosts entries

  ```Powershell
    $Entries = @()
    
    $Entries += [HostsEntry]::new("1.2.3.7","dc01","dc01.powershelldistrict.com","",[HostsEntryType]::Entry)
    $Entries += [HostsEntry]::new("1.2.3.5		plop             plop.powershelldistrict.com   ")
    
    $HostFile.ReadHostsFileContent()
    $HostFile.RemoveHostEntry($Entries)

```
  
  ### Persist changes to file
    All Hosts entries added and removed are only done in memory. To persist the change to disk (to write the entries back to the HostsFile) use the ```.Set()``` Method.
```Powershell

$HostFile.Set()
```

  ### Example
  
  This is a complete example that add's removes, and persists changes to disk

```powershell 
    $HostsFile = [HostsFile]::new()         
    $HostsFile.ReadHostsFileContent()

    $Entries = @()
    $Entries += [HostsEntry]::new("138.190.39.52		District234		District234.powershelldistrict.com #Woop")
    $Entries += [HostsEntry]::new("138.190.39.53		District235		District235.powershelldistrict.com #Woop")
    $Entries += [HostsEntry]::new("138.190.39.54		District236		District236.powershelldistrict.com #Woop")
    
    $HostFile.AddHostsEntry($Entries)  

    $HostsFile.Set()

    $HostsFile.ReadHostsFileContent()

    $HostsFile.GetEntries()
```

## Class diagram

This module is class based, see here the Class Diagram.

![ClassDiagram](/images/Class.HostsManagement.png)