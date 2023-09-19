<#
ADFindUserLogon
Version 3.1

Description: The script outputs data about user logins to the ARM.

Nikita Bratcev 2015
Anatoliy Krukov 2022
Aleksey Nesterenko 2023

#>

$path="\\AVANGARD.LOC\fs\Bases\scripts\FIFO\Phonebook\logs\dbcache"
Clear-Host
Write-Host "Collect logs ..."
$Logs = Get-ChildItem -Path "\\avangard.loc\fs\Bases\Scripts\FIFO\Phonebook\logs\*"
Clear-Host
$cnt = $Logs.Count
[int32]$i = 1

$Computers = @{}
$Users = @{}


ForEach ($Log in $Logs)
{
    $data = Import-Csv -Path $Log.FullName -Delimiter ';' -Header "User", "Date", "Time"
   
     $Computers.Item($Log.BaseName)= @{}
    
    
    ForEach ($User in ($data | Group-Object -Property "User" | Sort-Object -Property "Name"))
    {
       
    
        if(-not $Users.ContainsKey($User.Name))
        {
            $Users.Item($User.Name) =  @{}  
            
         }
        

        $Dtt=(($User.Group | Select-Object -Property "Date" -Last 1 | %{$_.Date}).Trim()+' '+($User.Group | Select-Object -Property "Time" -Last 1 | %{$_.Time})-replace ".{3}$").Trim() #collect Date and Time

        #Formation of hash tables

        
        $Computers[$Log.BaseName].Add($User.Name,$Dtt) #
        $Users[$User.Name].Add($Log.BaseName,$Dtt) 
        
      
        
    }
    Write-Progress -Activity "Create dictionaries " -Status "Progress: " -PercentComplete ($i++/$cnt*100) #ProgressBar
	
}
Write-Host "Start Export base"
Clear-Host
Write-Host "Export Computers base ..."
$Computers.GetEnumerator() |  ConvertTo-JSON -Depth 10 | Out-File $path\Computers.json
Clear-Host
Write-Host "Export Users base ..."
$Users.GetEnumerator() |    ConvertTo-JSON -Depth 10 | Out-File $path\Users.json
Clear-Host
Write-Host "End Export base"


