$ScriptPath = Split-Path $MyInvocation.MyCommand.Path

write-verbose "Loading data from $($ScriptPath)"

if(test-Path "$ScriptPath\Enums\Public"){

    write-verbose "Loading Enums"
    $Enums = gci "$ScriptPath\Enums\Public" -Filter *.ps1 | Select -Expand FullName
    
    
    foreach ($Enum in $Enums){
        write-verbose "importing Enum $($Enum)"
        try{
            . $Enum
        }catch{
            write-warning $_
        }
    }
}

If(Test-Path "$ScriptPath\Classes\Private"){

    write-verbose "Loading Private Classes"
    $PrivateFunctions = gci "$ScriptPath\Classes\Private" -Filter *.ps1 | Select -Expand FullName
    
    
    foreach ($Private in $PrivateFunctions){
        write-verbose "importing function $($function)"
        try{
            . $Private
        }catch{
            write-warning $_
        }
    }
}

If(test-Path "$ScriptPath\Classes\Public"){

    write-verbose "Loading Public Classes"
    $PublicFunctions = gci "$ScriptPath\Classes\public" -Filter *.ps1 | Select -Expand FullName
    
    
    foreach ($public in $PublicFunctions){
        write-verbose "importing function $($function)"
        try{
            . $public
        }catch{
            write-warning $_
        }
    }
}

if(Test-Path "$ScriptPath\Functions\Private"){

    write-verbose "Loading Private Functions"
    $PrivateFunctions = gci "$ScriptPath\Functions\Private" -Filter *.ps1 | Select -Expand FullName
    
    
    foreach ($Private in $PrivateFunctions){
        write-verbose "importing function $($function)"
        try{
            . $Private
        }catch{
            write-warning $_
        }
    }
}

if(Test-Path "$ScriptPath\Functions\public"){

    write-verbose "Loading Public Functions"
    $PublicFunctions = gci "$ScriptPath\Functions\public" -Filter *.ps1 | Select -Expand FullName
    
    
    foreach ($public in $PublicFunctions){
        write-verbose "importing function $($function)"
        try{
            . $public
        }catch{
            write-warning $_
        }
    }
}


