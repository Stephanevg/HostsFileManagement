using module ..\Class.HostsManagement.psd1 #Assuming that the tests are located in the \tests folder in the module directory.


# describes the function HostsEntry
Describe 'HostsEntry - Constructors' {

  Context 'Testing Constructors: values with comment'{
    $IpAddress = "192.168.2.2"
    $HostName = "Woop"
    $fqdn = "woop.powershelldistrict.com"
    $Description = "Awesome Server"
    $Entry = [HostsEntry]::new($IpAddress,$HostName,$fqdn,$Description,[HostsEntryType]::Comment)
    It 'Ipaddress should be set' {
      $Entry.Ipaddress | should be $IpAddress
    }
    
    It 'Hostname should be set' {
      $Entry.HostName | should be $HostName
    }
    
    It 'fqdn should be set' {
      $Entry.FullQuallifiedName | should be $fqdn
    }
    
    It 'description should be set' {
      $Entry.Description | should be $Description
    }
    
    It 'EntryType should be of type "Comment"' {
      #When not specified, the comment is $false
      $Entry.EntryType | should be "Comment"
    }
  }

  Context 'Testing Constructors: values not commented'   {
    $IpAddress = "192.168.2.2"
    $HostName = "Woop"
    $fqdn = "woop.powershelldistrict.com"
    $Description = "Awesome Server"
    $Entry = [HostsEntry]::new($IpAddress,$HostName,$fqdn,$Description,[HostsEntryType]::Entry)
    It 'Ipaddress should be set' {
      $Entry.Ipaddress | should be $IpAddress
    }
    
    It 'Hostname should be set' {
      $Entry.HostName | should be $HostName
    }
    
    It 'fqdn should be set' {
      $Entry.FullQuallifiedName | should be $fqdn
    }
    
    It 'description should be set' {
      $Entry.Description | should be $Description
    }
    
    It 'Entry Type should be of type "Entry"' {
      #When not specified, the comment is $false
      $Entry.EntryType | should be 'Entry'
    }

  }
  
  Context 'Testing Constructors: Single commented Line'{

    $Comment = "This complete line is commented out."
    $Entry = [HostsEntry]::new($Comment,[HostsEntrytype]::Comment)
   
    
    It 'Hostname hould be empty' {
      $Entry.HostName | should benullorempty
    }
    
    It 'fqdn should be empty' {
      $Entry.FullQuallifiedName | should benullorempty
    }
    
    It 'description should contain the comment' {
      $Entry.Description | should be $Comment
    }
    
    It 'EntryType should be of type "Comment"' {
      #When not specified, the comment is $false
      $Entry.EntryType | should be "Comment"
    }
  }

  Context 'Testing Constructors: Full line (string) with description" '{
    $Entry = [HostsEntry]::new("138.190.39.52		District234		District234.powershelldistrict.com #Woop")

    it 'IP address should be correct' {
      $Entry.Ipaddress | Should be "138.190.39.52"
    }

    it 'HostName should be correct' {
      $Entry.HostName | Should be "District234"
    }

    it 'FullQuallifiedName should be correct' {
      $Entry.FullQuallifiedName | Should be "District234.powershelldistrict.com"
    }

    it 'Description should be correct' {
      $Entry.Description | Should be "Woop "
    }
    
    it 'EntryType should be of type Entry' {
      $Entry.EntryType | Should be "Entry"
    }
  }

  Context 'Testing Constructors: Full line (string) with description - commented '{
    $Entry = ""
    $Entry = [HostsEntry]::new("#138.190.39.52		District234		District234.powershelldistrict.com #Woop")

    it 'IP address should be correct' {
      $Entry.Ipaddress | Should be "138.190.39.52"
    }

    it 'HostName should be correct' {
      $Entry.HostName | Should be "District234"
    }

    it 'FullQuallifiedName should be correct' {
      $Entry.FullQuallifiedName | Should be "District234.powershelldistrict.com"
    }

    it 'Description should be correct' {
      $Entry.Description | Should be "Woop "
    }
    
    it 'EntryType should be of type Comment' {
      $Entry.EntryType | Should be "Comment"
    }
  }

  Context 'Testing Constructors: Full commented line (Title style)'{
    $Entry = [HostsEntry]::new("All Primary Servers",[HostsEntryType]::comment)

    it 'IP address should be empty' {
      $Entry.Ipaddress | Should benullorempty
    }

    it 'HostName should be empty' {
      $Entry.HostName | Should benullorempty
    }

    it 'FullQuallifiedName should be empty' {
      $Entry.FullQuallifiedName | Should benullorempty
    }

    it 'Description should contain correct values' {
      $Entry.Description | Should be "All Primary Servers"
    }
    
    it 'EntryType should be of type Comment' {
      $Entry.EntryType | Should be "Comment"
    }
  }

  Context 'Testing Constructors: Full empty line (Type "BlankLine") '{
    $Entry = [HostsEntry]::new()

    it 'IP address should be correct' {
      $Entry.Ipaddress | Should benullorempty
    }

    it 'HostName should be correct' {
      $Entry.HostName | Should benullorempty
    }

    it 'FullQuallifiedName should be correct' {
      $Entry.FullQuallifiedName | Should benullorempty
    }

    it 'Description should be correct' {
      $Entry.Description | Should benullorempty
    }
    
    it 'EntryType should be of type Entry' {
      $Entry.EntryType | Should be "BlankLine"
    }
  }
  
  Context 'Testing Constructors: Passing Wrong data types'{
  
    it 'Constructor single String: Bad IP address should throw an error'{

      {[HostsEntry]::New("403.3.5.8		steph		svg.powershelldistrict.com")} | should throw

    }
    
    it 'Constructor Ip address, String, String,String: Bad IP address should throw an error'{

      {[HostsEntry]::New("392.168.2.1","Woop","Woop.wap.com","plop")} | should throw

    }
  
  }
  
} -Tag "Constructors"



# describes the function HostsFile

Describe 'HostsFile' {

  $HostsData = @'
# Copyright (c) 1993-2009 Microsoft Corp.
#
# This is a sample HOSTS file used by Microsoft TCP/IP for Windows.
#
# This file contains the mappings of IP addresses to host names. Each
# entry should be kept on an individual line. The IP address should
# be placed in the first column followed by the corresponding host name.
# The IP address and the host name should be separated by at least one
# space.
#
# Additionally, comments (such as these) may be inserted on individual
# lines or following the machine name denoted by a '#' symbol.
#
# For example:
#
#      102.54.94.97     rhino.acme.com          # source server
#       38.25.63.10     x.acme.com              # x client host

# localhost name resolution is handled within DNS itself.
#	127.0.0.1       localhost
#	::1             localhost

# All platform servers
192.168.1.2    wip wip.wop.wap
1.2.3.5		plop             plop.powershelldistrict.com             
1.2.3.6		wap wap.fop.lop
1.2.3.4		wap		wap.fop.lop
2.2.2.2		svg		plop


#Domain Controllers
1.2.3.7		dc01		dc01.powershelldistrict.com


'@
  $HostsFilePath =  join-path -Path $testDrive -ChildPath "Hosts"
  $HostsData | Out-File -FilePath $HostsFilePath -Encoding ascii
    
  $item = Get-Item -Path $HostsFilePath
  $HostFile = [HostsFile]::New($item)
  $HostFile.ReadHostsFileContent()
  $entries = $HostFile.GetEntries()

  Context 'Loading external Hosts file'   {
    
    
    It 'Instance should be created' {
      $HostFile | should not benullorempty
      $HostFile.path -eq $HostsFilePath | should be $true
    }

    it 'Should return entries' {
      #$entries = $HostFile.GetHostsEntries()
      $entries | should not benullorempty
    }
    
    it 'Entries must be of type "HostsEntry"'{
      #$entries = $HostFile.GetHostsEntries()
      $entries[0].GetType().Name | should be "HostsEntry"
      $entries[6].GetType().Name | should be "HostsEntry"
      $entries[10].GetType().Name | should be "HostsEntry"
    }
    
    it 'should contain commented entries' {
      #$entries = $HostFile.GetHostsEntries()
      $entries | ? {$_.EntryType -eq [HostsEntryType]::Comment} | should not benullorempty
    }
    
    it 'should contain regular entries' {
      
      $entries | ? {$_.EntryType -eq [HostsEntryType]::Entry} | should not benullorempty
    }
    
    it 'should contain blankline entries' {
      
      $entries | ? {$_.EntryType -eq [HostsEntryType]::BlankLine} | should not benullorempty
    }

    it 'should contain specefic entries 1'{
    
      $entries | ? {($_.ipAddress -eq "1.2.3.7") -and ($_.Hostname -eq "dc01") -and ($_.isComment -eq $false) -and ($_.fullqualifiedName -eq "dc01.powershelldistrict.com")}
    
    }

    it 'should contain specefic entries 2'{
    
      $entries | ? {($_.ipAddress -eq "2.2.2.3") -and ($_.Hostname -eq "ee") -and ($_.isComment -eq $false) -and ($_.fullqualifiedName -eq "ee.powershelldistrict.com")}
    
    }
    
    it 'should contain specefic entries 3'{
    
      $entries | ? {($_.ipAddress -eq "1.2.3.5") -and ($_.Hostname -eq "plop") -and ($_.isComment -eq $false) -and ($_.fullqualifiedName -eq "plop.powershelldistrict.com")}
    
    }

  }
  
  Context 'Testing Adding Entries'{
    $Entries = @()
    $Entries += [HostsEntry]::new("138.190.39.52		District234		District234.powershelldistrict.com #Woop")
    $Entries += [HostsEntry]::new("138.190.39.53		District235		District235.powershelldistrict.com #Woop")
    $Entries += [HostsEntry]::new("138.190.39.54		District236		District236.powershelldistrict.com #Woop")
    
    $HostFile.AddHostsEntry($Entries)
    
    $AllEntries = $HostFile.GetEntries()
    
    It 'Should contain entry 1'{
      $Entry = $AllEntries | ? {$_.Ipaddress -eq '138.190.39.52'}
      $Entry.IpAddress.IPAddressToString | Should be '138.190.39.52'
      $Entry.HostName | should be 'District234'
      $Entry.fullQuallifiedName | should be 'District234.powershelldistrict.com'
      $Entry.Description | should be 'Woop '
      $Entry.entryType | should be 'Entry'
    
    }
    
    It 'Should contain entry 2'{
        $Entry = $AllEntries | ? {$_.Ipaddress -eq '138.190.39.53'}
        $Entry.IpAddress.IPAddressToString | Should be '138.190.39.53'
        $Entry.HostName | should be 'District235'
        $Entry.fullQuallifiedName | should be 'District235.powershelldistrict.com'
        $Entry.Description | should be 'Woop '
        $Entry.entryType | should be 'Entry'
    
    }

    It 'Should contain entry 3'{
        $Entry = $AllEntries | ? {$_.Ipaddress -eq '138.190.39.54'}
        $Entry.IpAddress.IPAddressToString | Should be '138.190.39.54'
        $Entry.HostName | should be 'District236'
        $Entry.fullQuallifiedName | should be 'District236.powershelldistrict.com'
        $Entry.Description | should be 'Woop '
        $Entry.entryType | should be 'Entry'
    
    }
    

  }
  
  Context 'Testing Removing Entries'{
    
    $Entries = @()
    
    $Entries += [HostsEntry]::new("1.2.3.7","dc01","dc01.powershelldistrict.com","",[HostsEntryType]::Entry)
    $Entries += [HostsEntry]::new("1.2.3.5		plop             plop.powershelldistrict.com   ")
    
    $HostFile.ReadHostsFileContent()
    $HostFile.RemoveHostsEntry($Entries)
    
    $HostFile.GetEntries()
    
    It 'Should not contain entry 1'{
      $Entries = $HostFile.GetEntries()
      $Entry = $Entries | ? {$_.Ipaddress -contains "1.2.3.7"}
      $Entry | Should BeNullOrEmpty 

    }
    
    It 'Should not contain entry 2'{
        $Entry = $HostFile.GetEntries() | ? {$_.Ipaddress -eq '1.2.3.5'}
        $Entry | Should BeNullOrEmpty 
    
    }

    
  }
  
  Context 'Testing Backup Methods'{
  
    it 'Should create a backup' {
      $HostFile.Backup()
      $BackupFolder = split-Path -Path $HostsFilePath -Parent
      $item = Get-ChildItem -Path $BackupFolder -Filter "*.bak"
      $item | should not benullorempty
  
    }

    It 'Creating Backup with alternate path'{
    
      $BackupFolderPath = join-Path -Path $testdrive -ChildPath "Backup"
      if (!(test-path $BackupFolderPath)){

        $null = mkdir $BackupFolderPath
      }
      $BackupFolderItem = Get-Item $BackupFolderPath
      $HostFile.Backup($BackupFolderItem) #Needs to be of type System.IO.DirectoryInfo
    
      $item = Get-ChildItem -Path $BackupFolderItem.FullName -Filter "*.bak"
      $item | should not benullorempty
    }
  
    It 'Testing LogRotation (default 5)' {
      
      
      $BackupFolderPath = join-Path -Path $testdrive -ChildPath "Backup"

      if (!(test-path $BackupFolderPath)){

        $null = mkdir $BackupFolderPath
      }
      
      $BackupFolderItem = Get-Item $BackupFolderPath
      $HostFile.Backup($BackupFolderItem) #Needs to be of type System.IO.DirectoryInfo
  
  
      $HostFile.Backup()
      Start-Sleep -Seconds 2
      $HostFile.Backup()
      Start-Sleep -Seconds 1
      $HostFile.Backup()
      Start-Sleep -Seconds 2
      $HostFile.Backup()
      Start-Sleep -Seconds 1
      $HostFile.Backup()
      Start-Sleep -Seconds 2
      $HostFile.Backup()
      
      $items = Get-ChildItem -Path $BackupFolderItem.FullName -Filter "*.bak"
      $items.count -lt 6 | should be $true
  
  
    }

  }

  
} -tag "Hostsfile"

Describe 'Testing Persistance Options' {
    
    $HostsData = @'
# Copyright (c) 1993-2009 Microsoft Corp.
#
# This is a sample HOSTS file used by Microsoft TCP/IP for Windows.
#
# This file contains the mappings of IP addresses to host names. Each
# entry should be kept on an individual line. The IP address should
# be placed in the first column followed by the corresponding host name.
# The IP address and the host name should be separated by at least one
# space.
#
# Additionally, comments (such as these) may be inserted on individual
# lines or following the machine name denoted by a '#' symbol.
#
# For example:
#
#      102.54.94.97     rhino.acme.com          # source server
#       38.25.63.10     x.acme.com              # x client host

# localhost name resolution is handled within DNS itself.
#	127.0.0.1       localhost
#	::1             localhost

# All platform servers
192.168.1.2    wip wip.wop.wap
1.2.3.5		plop             plop.powershelldistrict.com             
1.2.3.6		wap wap.fop.lop
1.2.3.4		wap		wap.fop.lop
2.2.2.2		svg		plop


#Domain Controllers
1.2.3.7		dc01		dc01.powershelldistrict.com


'@
  $HostsFilePath =  join-path -Path $testDrive -ChildPath "Hosts"
  $HostsData | Out-File -FilePath $HostsFilePath -Encoding ascii
    
  $item = Get-Item -Path $HostsFilePath
  $HostFile = [HostsFile]::New($item)
  $HostFile.ReadHostsFileContent()

    Context 'Persisting data to disk -  Writing data to Hosts file'{
  
    

    $Entries = @()
    $Entries += [HostsEntry]::new("138.190.39.52		District234		District234.powershelldistrict.com #Woop")
    $Entries += [HostsEntry]::new("138.190.39.53		District235		District235.powershelldistrict.com #Woop")
    $Entries += [HostsEntry]::new("138.190.39.54		District236		District236.powershelldistrict.com #Woop")
    
    $HostFile.AddHostsEntry($Entries)
    
    #The Following entries are already present in the fake host file created at the begin of the describe block.
    $EntriesToDelete = @()
    $EntriesToDelete += [HostsEntry]::new("1.2.3.7","dc01","dc01.powershelldistrict.com","",[HostsEntryType]::Entry)
    $EntriesToDelete += [HostsEntry]::new("1.2.3.5		plop             plop.powershelldistrict.com   ")
    
    
    $HostFile.RemoveHostsEntry($EntriesToDelete)

    it "Should write file to disk using .Set() Method"{
        $HostFile.set()
        Test-Path $HostFile.Path | should be $true
    }

    it "Hosts file should be present and not null or empty"{

        gc $HostFile.Path | should not benullorempty
    }

    it "Data added through the Add tests should have been persisted into file: IP 138.190.39.52"{
        
        $HostFile.ReadHostsFileContent()
        $AllEntries = $HostFile.GetEntries()
        $AllEntries | ? {$_.IpAddress -eq "138.190.39.52"} | should be $true
    }

    it "Data added through the Add tests should have been persisted into file: IP 138.190.39.53"{
        
        $HostFile.ReadHostsFileContent()
        $AllEntries = $HostFile.GetEntries()
        $AllEntries | ? {$_.IpAddress -eq "138.190.39.53"} | should be $true
    }

    it "Data added through the Add tests should have been persisted into file: IP 138.190.39.54"{
        
        $HostFile.ReadHostsFileContent()
        $AllEntries = $HostFile.GetEntries()
        $AllEntries | ? {$_.IpAddress -eq "138.190.39.54"} | should be $true
    }

    it "Data deleted through the delete tests should not have been persisted into file: IP 1.2.3.7"{
        
        $HostFile.ReadHostsFileContent()
        $AllEntries = $HostFile.GetEntries()
        $AllEntries | ? {$_.IpAddress -eq "1.2.3.7"} | should benullOrEmpty
    }

    it "Data deleted through the delete tests should not have been persisted into file: IP 1.2.3.5"{
        
        $HostFile.ReadHostsFileContent()
        $AllEntries = $HostFile.GetEntries()
        $AllEntries | ? {$_.IpAddress -eq "1.2.3.5"} | should benullOrEmpty
    }

    it 'dummy'{
        notepad $HostFile.Path
        write-host "woop"
    }

  }
} -Tag "Persistence"

