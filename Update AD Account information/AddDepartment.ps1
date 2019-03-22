Import-Module ActiveDirectory

$users = import-csv C:\Users\Administrator\Desktop\AddDepartment\import.csv

Foreach ($User in $users) 
{ 
    $login = $user.login
    $department = $user.department
    $title = $user.title
    $description = $user.title
    $office = $user.office
    
       get-ADUser -server "ADMIN SERVER" -filter {sAMAccountName -eq $login} |

       #Follow the convention and add any other AD attributes to here and the csv.
       Set-ADUser -server "ADMIN SERVER" -Replace @{department = $department}
       Set-ADUser -server "ADMIN SERVER" -Replace @{Office = $office}
       Set-ADUser -server "ADMIN SERVER" -Replace @{title = $title} 
       Set-ADUser -server "ADMIN SERVER" -Replace @{description = $title}       	
       Write-host "user $login has had $department, $office, $title added to their account" 
     }


