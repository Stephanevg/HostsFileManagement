
Class HostsFile {
    [string]$Path
    [String]$ComputerName
    Hidden [HostsEntry[]]$Entries
    Hidden [int]$LogRotation = 5
    
    ## Default Constructor
    HostsFile(){

      $This.Path ="\\$ENV:Computername\admin$\System32\drivers\etc\hosts"
      $This.ComputerName = $ENV:Computername

    }
    
    ## Constructor that accepts a string (preferrably a computer name)
    HostsFile([String]$ComputerName){
    
      If ( Test-Connection -ComputerName $ComputerName -Quiet -Count 2 ) {
        $This.Path = "\\$Computername\admin$\System32\drivers\etc\hosts"
        $This.ComputerName = $Computername
      } Else {
        Throw "Could not reach the computer $($ComputerName)"
      }

    }
    
    ## Constructor that accept a path as a file
    HostsFile([System.IO.FileSystemInfo]$Path){

      $This.Path = $Path.FullName

    }
    
    ## Method to read the content of the hosts file
    [void]ReadHostsFileContent(){

      ## Local variables
      $Array = New-Object System.Collections.ArrayList #@()
      $HostsData = Get-Content $This.Path -Encoding Ascii
      
      ## Loop through the content of the file
      Foreach ( $Line in $HostsData ) {
        $Array +=[HostsEntry]::New($Line)
      }

      ## If Array exists
      If ( $array ){
        $This.Entries = $Array
      }

    }
    
    ## Method to get file entries
    [array]GetEntries(){

      ## Return entries
      If ( $This.Entries ) {
        return $This.Entries
      } Else {
        Throw "No entries present. Load a Hosts file first using the 'ReadHostsFileContent()' method, or use the add() method to add entries to the Hosts file that seems to be empty."
      }

    }
    
    ## Method to add Entries
    [void]AddHostsEntry([HostsEntry[]]$Entries){
      
      ## Local Variables
      $Added = $False
      [int]$Count = 0

      ## Loop through Entries
      Foreach ( $Entry in $Entries ) {
        ## If current entry is not already present is the file, add it
        If ( ($This.entries.ipaddress.IPAddressToString -notcontains $Entry.Ipaddress.IPAddressToString) ) {
          $Added = $True
          $Count++
          $This.entries += $Entry
        } Else {
          Write-Warning "The IpAddress $($Entry.ipaddress.IPAddressToString) is already present in the Hosts file."
        }
  
      }

      ## Write Verbose
      If ( $Added ) {
        Write-Verbose "Added: $($Count) entries to $($This.path). Call Set() to write to file."
      }
      
    }

    ## Method to Set LogRotation Value
    [Void]SetLogRotation([Int]$value){

      If ( $value -in 1..100 ) {
        $This.LogRotation = $value
      } Else {
        Throw "LogRotation must a int between 1 and 100 ..."
      }

    }
    
    ## Method to remove Entries in the Hosts File
    [void]RemoveHostsEntry([HostsEntry[]]$Entries){

      ## Easier to work with an arraylist
      $ArrayListofThisEntries = New-Object -TypeName System.Collections.ArrayList

      ## Fill ArrayListofThisEntries with current entries of the [HostsFile]
      Foreach ( $CurrEntry in $This.Entries ) { $ArrayListofThisEntries.add($CurrEntry) | Out-Null }
      Remove-Variable CurrEntry

      ## Remove entries passed to the method from the arraylist
      Foreach ( $Entry in $Entries ) {
        $ArrayListofThisEntries.Remove($Entry)
      }

      ## Push ArrayListofThisEntries This.Entries
      $This.Entries = $ArrayListofThisEntries

      ## Call Set Method, will backup current
      $This.Set()

    }
    
    ## Backup Method
    [void]Backup([System.IO.DirectoryInfo]$BackupFolder){
      
      ## Get All Hosts.bak files in the BackupFolder path
      $BackupItems = Get-ChildItem -Path $BackupFolder.FullName -Filter "*$($This.ComputerName)_Hosts.bak" | Sort-Object -Property CreationTime
      
      ## Check if the number of correspoing backup files is equal or greater than LogRotation Property
      If ( $BackupItems.Count -ge $This.LogRotation ) {
        #Remove the oldest Backup file
        Write-Verbose "LogRotation set to maximum $($This.LogRotation) backups. Deleting oldest backup $($BackupItems[0].Name)"
        $BackupItems[0].Delete()
      }
      
      ## Building backup file FullPath
      $FileStamp = Get-Date -Format 'yyyyMMdd-HHmmss'
      $Leaf = $FileStamp + "_" + $This.ComputerName + "_Hosts.bak"
      $BackupFullPath = Join-Path -Path $BackupFolder.FullName -ChildPath $Leaf

      ## Copying the backup file to the destination path
      Try {
        Copy-Item -Path $This.Path -Destination $BackupFullPath -ErrorAction stop
        Write-Verbose "Hosts file backup -> $($BackupFullPath)"
      } Catch {     
        Write-Warning "$_"
      }
  
    }
    
    ## Backup Method
    [void]Backup(){
  
      ## Get All Hosts.bak files in the default Path
      $BackupItems = Get-ChildItem -Path (split-Path -Path $This.Path -Parent) -Filter "*Hosts.bak" | Sort-Object CreationTime
      
      ## Check if the number of correspoing backup files is equal or greater than LogRotation Property
      If ($BackupItems.count -gt $This.logRotation){
        ## Remove the oldest Backup file
        Write-Verbose "LogRotation set to maximum $($This.LogRotation) backups. Deleting oldest backup $($BackupItems[0].Name)"
        $BackupItems[0].Delete()
      }
      
      ## Building backup file FullPath
      $FileStamp = Get-Date -Format 'yyyyMMdd-HHmmss'
      $BackupPath = Split-Path -Parent $This.Path
      $Leaf = $FileStamp + "_" + "Hosts.bak"
      $BackupFullPath = Join-Path -Path $backupPath -ChildPath $Leaf

      ## Copying the backup file to the destination path
      Try {
        Copy-Item -Path $This.Path -Destination $BackupFullPath -ErrorAction stop
        Write-Verbose "Hosts file backup -> $($BackupFullPath)"
      } Catch {   
        Write-Warning "$_"
      }

    }

    <#
    [void]Set(){
      
      if($This.Entries){
        $This.Backup()
        #write-warning "Waiting 3 seconds"
        #Start-Sleep -Seconds 3
        #Set-Content -Value "" -Path $This.Path -Encoding Ascii
  
       ("") | >> $This.Path -Encoding Ascii
        #$This.AddHostsEntry($This.Entries)
        
        
  
        foreach ($entry in $This.Entries){
          [string]$FullLine = ""
          #start-sleep -Seconds 1
          switch($entry.EntryType){
            "Comment"{
                   
              if (![string]::IsNullOrWhiteSpace($entry.Ipaddress.IPAddressToString)){
  
                $FullLine += $entry.Ipaddress.IPAddressToString
  
              }
  
              if (![string]::IsNullOrWhiteSpace($entry.HostName)){
  
                $FullLine += "`t`t" + $entry.hostname 
  
              }
  
              if (![string]::IsNullOrWhiteSpace($entry.FullQuallifiedName)){
                $FullLine += "`t`t" + $entry.FullQuallifiedName  
  
              }
  
              if (![string]::IsNullOrWhiteSpace($entry.Description)){
                if ($entry.Ipaddress.IpAddressToString){
                  $FullLine += "`t`t" + "#" + $entry.Description
                }else{
                  if ($fullLine -match '^#.+'){
                    $fullLine += "`t`t" + $entry.Description
                  }else{
                    $FullLine += $entry.Description
                  }
                }
                 
              }
  
              $fullLine = "#" + $FullLine
  
            ;Break}
            "BlankLine"{
              if ($entry.IsComment -eq $true){
                      
                $fullLine = "#"
              }else{
                #$fullLine = "`r`n"
                $fullLine = ""
              }
            ;Break}
            "Entry"{
              if (![string]::IsNullOrWhiteSpace($entry.Ipaddress.IPAddressToString)){
  
                $FullLine += $entry.Ipaddress.IPAddressToString
  
              }
  
              if (![string]::IsNullOrWhiteSpace($entry.HostName)){
  
                $FullLine += "`t`t" + $entry.hostname 
  
              }
  
              if (![string]::IsNullOrWhiteSpace($entry.FullQuallifiedName)){
                $FullLine += "`t`t" + $entry.FullQuallifiedName  
  
              }
  
              if (![string]::IsNullOrWhiteSpace($entry.Description)){
  
                $fullLine += "`t`t" + "# "+ $entry.Description
                  
                 
              }
            ;Break}#End Switch Entry
          }
  
  
        
          #$fullLine += "`r`n"
        
          try{
            write-verbose "Adding: $($fullLine) to $($This.path)"
            Start-Sleep -Milliseconds 70
            ($fullLine) | >> $This.Path -ErrorAction stop
            
          }catch{
            write-warning "$_"
            
          }
        
        
        }#endforeach
  
      }else{
        write-warning "No entries to set."
      }
    }
    #>

      ## Method to save the hosts file with changes
      [void]Set(){
      
      If ( $This.Entries ) {

        ## Create Backup
        $This.Backup()
        #write-warning "Waiting 3 seconds"
        #Start-Sleep -Seconds 3
        #Set-Content -Value "" -Path $This.Path -Encoding Ascii
        $stream = [System.IO.StreamWriter]::new($This.Path,$false)
       #("") | Set-Content -Path $This.Path -Encoding Ascii
       
        #$This.AddHostsEntry($This.Entries)
        
        Foreach ( $Entry in $This.Entries){
          [string]$FullLine = ""
          #start-sleep -Seconds 1
          switch($Entry.EntryType){
            "Comment"{
                   
              if (![string]::IsNullOrWhiteSpace($Entry.Ipaddress.IPAddressToString)){
  
                $FullLine += $Entry.Ipaddress.IPAddressToString
  
              }
  
              if (![string]::IsNullOrWhiteSpace($Entry.HostName)){
  
                $FullLine += "`t`t" + $Entry.hostname 
  
              }
  
              if (![string]::IsNullOrWhiteSpace($Entry.FullQuallifiedName)){
                $FullLine += "`t`t" + $Entry.FullQuallifiedName  
  
              }
  
              if (![string]::IsNullOrWhiteSpace($Entry.Description)){
                if ($Entry.Ipaddress.IpAddressToString){
                  $FullLine += "`t`t" + "#" + $Entry.Description
                }else{
                  if ($fullLine -match '^#.+'){
                    $fullLine += "`t`t" + $Entry.Description
                  }else{
                    $FullLine += $Entry.Description
                  }
                }
                 
              }
  
              $fullLine = "#" + $FullLine
  
            ;Break}
            "BlankLine"{
              if ($Entry.IsComment -eq $true){
                      
                $fullLine = "#"
              }else{
                #$fullLine = "`r`n"
                $fullLine = ""
              }
            ;Break}
            "Entry"{
              if (![string]::IsNullOrWhiteSpace($Entry.Ipaddress.IPAddressToString)){
  
                $FullLine += $Entry.Ipaddress.IPAddressToString
  
              }
  
              if (![string]::IsNullOrWhiteSpace($Entry.HostName)){
  
                $FullLine += "`t`t" + $Entry.hostname 
  
              }
  
              if (![string]::IsNullOrWhiteSpace($Entry.FullQuallifiedName)){
                $FullLine += "`t`t" + $Entry.FullQuallifiedName  
  
              }
  
              if (![string]::IsNullOrWhiteSpace($Entry.Description)){
  
                $fullLine += "`t`t" + "# "+ $Entry.Description
                  
                 
              }
            ;Break}#End Switch Entry
          }
  
  
        
          #$fullLine += "`r`n"
        
          try{
            write-verbose "Adding: $($fullLine) to $($This.path)"
            #Start-Sleep -Milliseconds 70
            $stream.WriteLine($FullLine)
            #$fullLine | Add-Content -Path $This.Path -ErrorAction stop
            
          }catch{
            write-warning "$_"
            
          }
        }#endforeach
  
        $stream.close()
  
      }else{
        write-warning "No entries to set."
      }
    }
  
  }
