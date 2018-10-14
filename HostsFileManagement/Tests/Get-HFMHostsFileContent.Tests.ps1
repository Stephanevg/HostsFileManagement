Import-Module -force $PSScriptRoot\..\HostsFileManagement.psd1

Describe "Testing Input/Output of Get-HFMHostsFileContent" {
    Context "Testing Get-HFMHostsFileContent InPut" {

        $ComputerName = $ENV:Computername
    
        It "Should throw run when no parameters provided" {
            Try { Get-HFMHostsFileContent; $a = $True } Catch { $a = $False }
            $a | Should be $False
        }
    
        It "Should accept Pipeline Input" {
            $ComputerName | Get-HFMHostsFile | Get-HFMHostsFileContent| Should not beNullOrEmpty
        }
    
        It "Input should be of type [HostsFile]" {
            Try { $ComputerName | Get-HFMHostsFile | Get-HFMHostsFileContent ; $a = $True } Catch { $a = $False }
            $a | Should be $True
        }
    
    }
    
    Context "Testing Get-HFMHostsFile OutPut" {
    
        $ComputerName = $ENV:Computername

        It "Output Should be of type [Objec[]] in default behavior (no pipeline)" {
            $a = Get-HFMHostsFile
            (Get-HFMHostsFileContent -Path $a).gettype().name -eq "Object[]" | Should be $True
        }

        It "Values in [Object[]] should be of type [HostsEntry] in default behavior (no pipeline)" {
            $a = Get-HFMHostsFile
            $b = Get-HFMHostsFileContent -Path $a
            ($b[0]).gettype().name -eq "HostsEntry" | Should be $True
        }
    
        It "Ouput Should be of type [Objec[]) when it comes after the pipeline" {
            (Get-HFMHostsFile | Get-HFMHostsFileContent).gettype().name -eq "Object[]" | Should be $True
        }
    
        It "Values in [Object[]] should be of type [HostsEntry] when it comes after the Pipeline" {
            $a = Get-HFMHostsFile | Get-HFMHostsFileContent
            ($a[0]).gettype().name -eq "HostsEntry" | Should be $True
        }
    
        It "Should not return any Comment if ExcludeComments parameter is specified" {
            $a = Get-HFMHostsFile | Get-HFMHostsFileContent -ExcludeComments
            "Comment" -notin $a.EntryType | Should be $True
        }
    
    }
}