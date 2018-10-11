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
  
      $This.Ipaddress = $IpAddress
      $This.HostName = $HostName
      $This.FullQuallifiedName = $FQDN
      $This.Description = $Description
      $This.EntryType = $Type
    }
    
    ## Add description to constructor
    HostsEntry([IpAddress]$IpAddress,[String]$HostName,[String]$FQDN,[String]$Description){
      
      $This.Ipaddress = $IpAddress
      $This.HostName = $HostName
      $This.FullQuallifiedName = $FQDN
      $This.Description = $Description
    }
    
    ## Add description to constructor
    HostsEntry([String]$Comment,[HostsEntryType]$Type){
      
      If ( ![Hostsentrytype]::Comment ) {
        throw "This constructor can only be used woth the [HostsEntryType]::Comment property."
      }

      $This.Description = $Comment
      $This.EntryType = $Type
    }
    
    ## Hiddent Constructor
    hidden HostsEntry([string]$Line){

      ## Local variable
      $Type = [HostsEntry]::GetLineType($Line)

      ## Determine type, and populate properties
      Switch ($Type){
        "Comment" {
          $This.EntryType = $Type
          $SplittedLine = [regex]::Split($line, "\s+") #$line.Split(" ")
          If ( $SplittedLine[0] -match '^#\d{1,3}\.' ) {
            $This.Ipaddress = $SplittedLine[0].replace("#","")
            $This.HostName = $SplittedLine[1]
            $This.FullQuallifiedName = $SplittedLine[2]
            [string]$comment = ""

            If ( $SplittedLine.count -gt 3 ) {
              $i = 3
              
              While ( $i -ne $SplittedLine.count ) {
                If ( $SplittedLine[$i] -ne "" ) {
                  $Comment += $SplittedLine[$i] + " "
                  $i++
                } Else {
                  $i++
                }
              }
            }#end if splitted line gt 3

            If ( $Comment -match '^#.*' ) {
              $This.Description = $Comment.Replace("#","")
            } Else {
              $This.Description = $comment
            }
  
          } ElseIf ( $SplittedLine[0] -match '^#.*' ) {
            #$This.Ipaddress = [ipaddress]::None
            $This.HostName = [string]::Empty
            $This.FullQuallifiedName = [string]::Empty
            $This.Description = $line.Replace("#","")
          }

        ;Break}

        "BlankLine" {
          $This.EntryType = $Type
          $This.HostName = [string]::Empty
          $This.Description = [string]::Empty
          $This.FullQuallifiedName = [string]::Empty
        ;Break}

        "Entry" {
          $SplittedLine = [regex]::Split($line, "\s+") #$line.Split(" ")
          $This.Ipaddress = $SplittedLine[0]
          $This.HostName = $SplittedLine[1]
          $This.FullQuallifiedName = $SplittedLine[2]
     
          [string]$comment = ""

          If ( $SplittedLine.count -gt 3 ) {
            $i = 3
            While ($i -ne $SplittedLine.count) {
              If ( $SplittedLine[$i] -ne "" ) {
                $Comment += $SplittedLine[$i] + " "
                $i++
              } Else {
                $i++
              }
            }
  
            If ($comment -match '^#.*' ) {
              $This.Description = $comment.Replace("#","")
            } Else {
              $This.Description = $comment
            }
          }
  
        ;Break}

      }
    }
    
    ## Default Constructor
    HostsEntry(){

      $This.HostName = [String]::Empty
      $This.FullQuallifiedName = [String]::Empty
      $This.Description = [String]::Empty
      $This.EntryType = [HostsEntryType]::BlankLine
      
    }
  
    ## Method to get the type of each line: comment, blankline or entry
    [HostsEntryType] static hidden GetLineType([string]$Line){
      
      ## local variables
      $Type = ""

      ## Switch to analyze the current $line with regex
      Switch -Regex ($Line) {
        '^#'    { $Type = [HostsEntryType]::Comment;Break }
        '^\s*$' { $Type = [HostsEntryType]::BlankLine;Break }
        Default { $Type = [HostsEntryType]::Entry;Break }
      }

      return $Type

    }
  }
  