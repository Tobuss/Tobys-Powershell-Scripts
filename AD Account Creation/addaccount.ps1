import-module activedirectory

$users = Import-Csv -Delimiter "," "C:\Scripts\ADcreation\Input.csv"

foreach ($user in $users)
{
	$Displayname = $user.First + " " + $user.Last
	$Userfirstname = $user.First
	$Userlastname = $user.Last
	$Sam = $user.Login
	$Upn = $User.Login + "@companyemail.com"
	$Password = "DefaultPassword"
	$oU = "OU=" + $user.ou + ",ADD OU PATH BEFORE THE ONE IN CSV"
# Below is only needed if you use home drives/roaming profiles

	$directory = "\\Home drive path" + $Sam
	$profile = "\\romaming profile path" + $Sam

#---------------------------------------------------------
	$description = $user.Description
	$office = $user.Office
	$department = $user.Department
	
	New-ADUser -Name $Displayname -DisplayName $DisplayName -SamAccountName $Sam -UserPrincipalName $Upn -givenName $Userfirstname -Surname $Userlastname -Description $description -Office $office -Department $department -Title $description -Company "COMPANY" -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -Force) -Enabled $true -ProfilePath $profile -HomeDrive " NETWORK LETTER FOR HOME DRIVE" -HomeDirectory $directory -Path $oU -ChangePasswordAtLogon $true -PasswordNeverExpires $false -server "AD SERVER"

	
}