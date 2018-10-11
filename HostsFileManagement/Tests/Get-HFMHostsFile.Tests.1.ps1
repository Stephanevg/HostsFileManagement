Import-Module -force $PSScriptRoot\..\HostsFileManagement.psd1

Describe "Testing Input/Output of Get-HFMHostsFile" {
    Context "Testing Get-HFMHostsFile InPut" {

        $ComputerName = $ENV:Computername
    
        It "Should run when no parameters provided" {
            Get-HFMHostsFile | Should not beNullOrEmpty
        }
    
        It "Should accept Pipeline Input" {
            $ComputerName | Get-HFMHostsFile | Should not beNullOrEmpty
        }
    
    }
    
    Context "Testing Get-HFMHostsFileContent OutPut" {
    
        $ComputerName = $ENV:Computername
    
        It "Output Should be of type [HostsFile] in default behavior (no pipeline)" {
            (Get-HFMHostsFile).gettype().name -eq "HostsFile" | Should be $True
        }

        It "Ouput Should be of type [HostsFile] when ONLY ONE computer is specified before the pipeline" {
            ($ComputerName | Get-HFMHostsfile).gettype().name -eq "HostsFile" | Should be $True
        }

        It "Ouput Should be of type [Objec[]] when MULTIPLE computer are specified before the pipeline" {
            ($ComputerName,$ComputerName | Get-HFMHostsfile).gettype().name -eq "Object[]" | Should be $True
        }
    
    }
}