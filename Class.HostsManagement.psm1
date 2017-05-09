Enum HostsEntryType{
  Entry
  Comment
  BlankLine
}

Class HostsEntry{
  [Ipaddress]$Ipaddress
  [string]$HostName
  [String]$FullQuallifiedName
  [String]$Description
  [HostsEntryType]$EntryType
  
  HostsEntry([IpAddress]$IpAddress,[String]$HostName,[String]$FQDN,[String]$Description,[HostsEntryType]$Type){
    
    if ($Type -eq [HostsEntryType]::BlankLine){
      throw "This constructor cannot be used to create a blank line. Use the constructor with the empty signature HostsEntry()."
    }

    $this.Ipaddress = $IpAddress
    $this.HostName = $HostName
    $this.FullQuallifiedName = $FQDN
    $this.Description = $Description
    $this.EntryType = $Type
  }
  
  HostsEntry([IpAddress]$IpAddress,[String]$HostName,[String]$FQDN,[String]$Description){
    $this.Ipaddress = $IpAddress
    $this.HostName = $HostName
    $this.FullQuallifiedName = $FQDN
    $this.Description = $Description
    
  }
 
  HostsEntry([String]$Comment,[HostsEntryType]$Type){
    
    if (![Hostsentrytype]::Comment){
      throw "This constructor can only be used woth the [HostsEntryType]::Comment property."
    }
    $this.Description = $Comment
    $this.EntryType = $Type
  }

  hidden HostsEntry([string]$Line){
    $Type = [HostsEntry]::GetLineType($Line)


    switch ($Type){
      "Comment" {
        $this.EntryType = $Type
        $SplittedLine = [regex]::Split($line, "\s+") #$line.Split(" ")
        if($SplittedLine[0] -match '^#\d{1,3}\.'){
          $this.Ipaddress = $SplittedLine[0].replace("#","")
          $this.HostName = $SplittedLine[1]
          $this.FullQuallifiedName = $SplittedLine[2]
          [string]$comment = ""
          if ($SplittedLine.count -gt 3){
            $i = 3
            
            while ($i -ne $SplittedLine.count){
              if ($SplittedLine[$i] -ne ""){
                $Comment += $SplittedLine[$i] + " "

                $i++

              }else{

                $i++
              }
            }
          }#end if splitted line gt 3

           
          if ($Comment -match '^#.*'){
            $this.Description = $Comment.Replace("#","")
          }else{
            $this.Description = $comment
          }

        }elseif($SplittedLine[0] -match '^#.*'){
          #$this.Ipaddress = [ipaddress]::None
          $this.HostName = [string]::Empty
          $this.FullQuallifiedName = [string]::Empty

          $this.Description = $line.Replace("#","")
        }
            

      ;Break}
      "BlankLine" {
        
        $this.HostName = [string]::Empty
        $this.FullQuallifiedName = [string]::Empty
        $this.Description = [string]::Empty
        $this.EntryType = $Type
            
        
      ;Break}
      "Entry" {
            
        $SplittedLine = [regex]::Split($line, "\s+") #$line.Split(" ")
        $this.Ipaddress = $SplittedLine[0]
        $this.HostName = $SplittedLine[1]
        $this.FullQuallifiedName = $SplittedLine[2]
                
        [string]$comment = ""
        if ($SplittedLine.count -gt 3){
          $i = 3
            
          while ($i -ne $SplittedLine.count){
            if ($SplittedLine[$i] -ne ""){
              $Comment += $SplittedLine[$i] + " "

              $i++

            }else{

              $i++
            }
          }

          if ($comment -match '^#.*'){
            $this.Description = $comment.Replace("#","")
          }else{
            $this.Description = $comment
          }
        }

      ;Break}
    }
  }

  HostsEntry(){
    $this.HostName = [string]::Empty
    $this.FullQuallifiedName = [string]::Empty
    $this.Description = [string]::Empty
    $this.EntryType = [HostsEntryType]::BlankLine
    
  }


  [HostsEntryType] static hidden GetLineType([string]$Line){

    $type = ""
    switch -Regex ($line){
    
      '^#'{$type = [HostsEntryType]::Comment;Break}
      '^\s*$'{$type = [HostsEntryType]::BlankLine;Break}
      Default {$type = [HostsEntryType]::Entry;Break}

    
    }
    return $type
  }
}

Class HostsFile{
  hidden [HostsEntry[]]$Entries
  [string]$Path
  hidden [int]$LogRotation = 5
  
  HostsFile(){
    $this.Path ="\\$env:Computername\admin$\System32\drivers\etc\hosts"
  }
  
  HostsFile([String]$ComputerName){
  
    if (Test-Connection -ComputerName $ComputerName -Quiet -Count 2){
      $This.Path ="\\$Computername\admin$\System32\drivers\etc\hosts"
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
  
  [void]Backup([System.IO.DirectoryInfo]$BackupFolder){

    $BackupItems = Get-ChildItem -Path (split-Path -Path $BackupFolder.FullName -Parent) -Filter "*Hosts.bak" | sort CreationTime
    
    if ($BackupItems.count -gt $This.logRotation){
    
      #Remove the oldest Backup file
      write-verbose "LogRotation set to maximum $($this.LogRotation) backups. Deleting oldest backup $($BackupItems[0].Name)"
      $BackupItems[0].Delete()
    }
    
    $FileStamp = get-date -Format 'yyyyMMdd-HHmmss'
    #$backupPath = Split-Path -Parent $this.Path
    $leaf = $FileStamp + "_" + "Hosts.bak"
    $BackupFullPath = Join-Path -Path $BackupFolder.FullName -ChildPath $leaf
    try{
      Copy-Item -Path $this.Path -Destination $BackupFullPath -ErrorAction stop
      Write-Verbose "Hosts file backup -> $($BackupFullPath)"
    }catch{   
        
      Write-Warning "$_"

    }

  }

  [void]Backup(){

    
    $BackupItems = Get-ChildItem -Path (split-Path -Path $this.Path -Parent) -Filter "*Hosts.bak" | sort CreationTime
    
    #Based on hidden parameter 'logRotation' we can limit the number of backups we want to keep. Default is set to 5
    if ($BackupItems.count -gt $This.logRotation){
    
      #Remove the oldest Backup file
      write-verbose "LogRotation set to maximum $($this.LogRotation) backups. Deleting oldest backup $($BackupItems[0].Name)"
      $BackupItems[0].Delete()
    }
    
    $FileStamp = get-date -Format 'yyyyMMdd-HHmmss'
    $backupPath = Split-Path -Parent $this.Path
    $leaf = $FileStamp + "_" + "Hosts.bak"
    $BackupFullPath = Join-Path -Path $backupPath -ChildPath $leaf
    try{
      Copy-Item -Path $this.Path -Destination $BackupFullPath -ErrorAction stop
      Write-Verbose "Hosts file backup -> $($BackupFullPath)"
    }catch{   
        
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