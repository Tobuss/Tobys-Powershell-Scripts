$computers = Import-csv "C:\computers.csv"

#Run this on Active Directory
foreach ($oldname in $computers) {
Rename-computer -ComputerName computers.oldname -NewName $computers.newname -DomainCrediential DOMAIN ADMIN ACCOUNT -Force -Restart
}