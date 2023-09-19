<#
ADFindUserLogon
Version 3.1

Description: The script outputs data about user logins to the ARM.

Nikita Bratcev 2015
Anatoliy Krukov 2022
Aleksey Nesterenko 2023

#>
$ErrorActionPreference = 'SilentlyContinue'
 function ConverToHash ($x)
{
                $hash = @{}

                
                $x.psobject.properties | Foreach                 {
                   
                    if ($_.Value -match "^\d\d\.\d\d\.\d\d\d\d\s\d{1,}\:\d\d\:\d\d")  # The Date and Time in the blog can have different formats. Matching search by regular expression  
                    {
                          $hash[$_.Name] =[datetime]::parseexact($_.Value,"dd.MM.yyyy H:mm:ss",$null) #Parsing the datetime by template #1 into a variable of the datetime type (Required for proper sorting)
                    }
                    if ($_.Value -match "^\w\w\w\s\d\d\/\d\d\/\d\d\d\d\/\s\d{1,}\:\d\d\:\d\d") # The Date and Time in the blog can have different formats. Matching search by regular expression
                    {
                          $hash[$_.Name] =[datetime]::parseexact($_.Value,"ddd dd/MM/yyyy/ H:mm:ss",$null) #Parsing the datetime by template #2 into a variable of the datetime type (Required for proper sorting)
                    }
                  
                }
                $hash.getenumerator() | sort-object -property value 
                Write-Host ("-----`nTotal users: {0}" -f $hash.Count)
}

    $path="\\AVANGARD.LOC\fs\Bases\scripts\FIFO\Phonebook\logs\dbcache"
    Clear-Host
    Write-Host "Collect Users ..."

    Clear-Host


    $Users = Get-Content  -RAW $path\Computers.json |  ConvertFrom-Json
    $Computers = Get-Content -RAW $path\Users.json | ConvertFrom-Json


    do
    {
       try
       {
            Write-Host "--- Для выхода введите Exit или . ---"
            $choise = Read-Host "Введите имя пользователя или компьютера"
            if ($choise -eq "exit") {Exit}
	        if ($choise -eq ".") {Exit}


            if (($Users | where name -eq $Choise) -eq $null)
                {
   
                
                ConverToHash(($Computers | where name -eq $Choise ).Value)           

  

                }
            else
  
            {

            if ($Computers."$Choise" -eq $null)
                {
  
                ConverToHash(($Users | where name -eq $Choise).Value) 
         
                }
            }
            Write-Host ""
        }
        catch
        {
			Write-Host "----------------------------------------------------------"
            Write-Host ("Объект  с именем {0} не обнаружен в AD" -f $Choise) 
			Write-Host "----------------------------------------------------------"
			Write-Host "----------------------------------------------------------"
        }
    }
    while ($true)



