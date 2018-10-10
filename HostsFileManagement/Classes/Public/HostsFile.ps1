
Class HostsFile {
    [string]$Path
    [String]$ComputerName
    Hidden [HostsEntry[]]$Entries
    Hidden [int]$LogRotation = 5
    
    HostsFile(){
      $This.Path ="\\$env:Computername\admin$\System32\drivers\etc\hosts"
      $This.ComputerName = $env:Computername
    }
    
    HostsFile([String]$ComputerName){
    
      if (Test-Connection -ComputerName $ComputerName -Quiet -Count 2){
        $This.Path ="\\$Computername\admin$\System32\drivers\etc\hosts"
        $This.ComputerName = $Computername
      }else{
        throw "Could not reach the computer $($ComputerName)"
      }
    }
    
    HostsFile([System.IO.FileSystemInfo]$Path){
      $this.Path = $Path.fullName
    }
    
    [void]ReadHostsFileContent(){
      $array = New-Object System.Collections.ArrayList #@()
      $HostsData = Get-Content $this.Path -Encoding Ascii
  
    
      foreach ($Line in $HostsData){
  
        $array +=[HostsEntry]::New($line)
        
      }
      if ($array){
        $this.Entries = $array
      }
      
     
    }
    
    [array]GetEntries(){
      if ($this.Entries){
        return $this.Entries
      }else{
        throw "No entries present. Load a Hosts file first using the 'ReadHostsFileContent()' method, or use the add() method to add entries to the Hosts file that seems to be empty."
      }
    }
    
    [void]AddHostsEntry([HostsEntry[]]$entries){
   
      $added = $false
      [int]$count = 0
      foreach ($entry in $entries){
        if (($this.entries.ipaddress.IPAddressToString -notcontains $entry.Ipaddress.IPAddressToString)){
          $added = $true
          $count++
          $this.entries += $entry
        }else{
          Write-Warning "The IpAddress $($entry.ipaddress.IPAddressToString) is already present in the Hosts file."
        }
  
      }#end foreach
      if ($added){
        write-verbose "Added: $($count) entries to $($this.path). Call Set() to write to file."
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
    
    [void]RemoveHostsEntry([HostsEntry[]]$entries){
      $NewStructure = @() 
      $found = $false  
      
      if ($entries){
  
        $this.Backup()
        $this.Entries = $this.GetEntries() | ? {$Entries.IpAddress -notcontains $_.IpAddress}
  
      }
      <#
          foreach ($EntryToDelete in $entries){
  
          foreach ($ExistingEntry in $this.Entries){
  
          if (($EntryToDelete.Ipaddress -eq $ExistingEntry.ipaddress) -and ($EntryToDelete.HostName -eq $ExistingEntry.HostName) -and ($EntryToDelete.FullQuallifiedName -eq $ExistingEntry.FullQuallifiedName) -and ($EntryToDelete.description -eq $ExistingEntry.Description) -and ($EntryToDelete.entryType -eq $ExistingEntry.EntryType)){
  
          $ExistingEntry
          #Skipping
            
          }else{
          $found = $true
          $NewStructure += $ExistingEntry
  
          }
  
          }#end foreach existing entries
        
  
          }#end foreach all entries to delete
      
          if ($found){
        
          $this.Entries = $NewStructure
        
          #write to file
          }
  
      #>
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
        Copy-Item -Path $this.Path -Destination $BackupFullPath -ErrorAction stop
        Write-Verbose "Hosts file backup -> $($BackupFullPath)"
      } Catch {     
        Write-Warning "$_"
      }
  
    }
    
    ## Backup Method
    [void]Backup(){
  
      ## Get All Hosts.bak files in the default Path
      $BackupItems = Get-ChildItem -Path (split-Path -Path $this.Path -Parent) -Filter "*Hosts.bak" | Sort-Object CreationTime
      
      ## Check if the number of correspoing backup files is equal or greater than LogRotation Property
      if ($BackupItems.count -gt $This.logRotation){
        ## Remove the oldest Backup file
        Write-Verbose "LogRotation set to maximum $($this.LogRotation) backups. Deleting oldest backup $($BackupItems[0].Name)"
        $BackupItems[0].Delete()
      }
      
      ## Building backup file FullPath
      $FileStamp = Get-Date -Format 'yyyyMMdd-HHmmss'
      $BackupPath = Split-Path -Parent $this.Path
      $Leaf = $FileStamp + "_" + "Hosts.bak"
      $BackupFullPath = Join-Path -Path $backupPath -ChildPath $Leaf

      ## Copying the backup file to the destination path
      Try {
        Copy-Item -Path $this.Path -Destination $BackupFullPath -ErrorAction stop
        Write-Verbose "Hosts file backup -> $($BackupFullPath)"
      } Catch {   
        Write-Warning "$_"
      }
    }

    <#
    [void]Set(){
      
      if($this.Entries){
        $this.Backup()
        #write-warning "Waiting 3 seconds"
        #Start-Sleep -Seconds 3
        #Set-Content -Value "" -Path $this.Path -Encoding Ascii
  
       ("") | >> $this.Path -Encoding Ascii
        #$this.AddHostsEntry($this.Entries)
        
        
  
        foreach ($entry in $this.Entries){
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
            write-verbose "Adding: $($fullLine) to $($this.path)"
            Start-Sleep -Milliseconds 70
            ($fullLine) | >> $this.Path -ErrorAction stop
            
          }catch{
            write-warning "$_"
            
          }
        
        
        }#endforeach
  
      }else{
        write-warning "No entries to set."
      }
    }
    #>
     [void]Set(){
      
      if($this.Entries){
        $this.Backup()
        #write-warning "Waiting 3 seconds"
        #Start-Sleep -Seconds 3
        #Set-Content -Value "" -Path $this.Path -Encoding Ascii
        $stream = [System.IO.StreamWriter]::new($this.Path,$false)
       #("") | Set-Content -Path $this.Path -Encoding Ascii
       
        #$this.AddHostsEntry($this.Entries)
        
        
  
        foreach ($entry in $this.Entries){
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
            write-verbose "Adding: $($fullLine) to $($this.path)"
            #Start-Sleep -Milliseconds 70
  
            
  
              $stream.WriteLine($FullLine)
  
  
  
  
            #$fullLine | Add-Content -Path $this.Path -ErrorAction stop
            
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
