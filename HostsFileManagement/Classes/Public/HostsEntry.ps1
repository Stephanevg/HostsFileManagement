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
  