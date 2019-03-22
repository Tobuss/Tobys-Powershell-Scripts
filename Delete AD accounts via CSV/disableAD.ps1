<# Use below for exporting email profiles from O365

$Usercredentials = Get-credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.compliance.protection.outlook.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session

#>

import-module activedirectory

Import-Module "PSCX"

$users = Import-Csv -Delimiter "," "C:\scripts\disablead\import.csv"

	$IDM = Read-Host -Prompt 'Please enter your login'
	$pass = Read-Host -Prompt 'Please enter your password' -AsSecureString

	# Retrieves users via their login name
	get-ADUser -server "AD SERVER" -SearchBase "USER OU FULL PATH" -filter {sAMAccountName =eq $login} |
	
	#Removes the telephone number from all accounts in csv and adds them all to a CSV wit the days date.
	Set-ADUser -server "AD SERVER" -SearchBase "USER OU FULL PATH" -filter @{telephonenumber = $null}     	
	export-csv c:\temp\Ext-$((Get-Date).ToString('MM-dd-yyyy')).csv -NoTypeInformation

foreach ($user in $users)
{
	$Sam = $user.Login
	$oU = "Disabled User OU gos here"
	
	# $uDrive = Path to home drive if used e.g "\\192.168.0.1" + $Sam
	# $disabledDrive = Destination for home drive to be moved to

	# $disabledProfile = Destination for disabled profile to be moved to
	
	$email = $user.email

	Set-ADUser -server "AD SERVER" -Replace @{telephonenumber = rrr}
	
	<# Start a O365 complaince search for each user for easy exports
	New-ComplianceSearch -Name "$Sam" -ExchangeLocation $email
	Start-ComplianceSearch -Identity "$Sam"	
	#>
	if(get-ADUser -server "AD SERVER" -filter{sAMAccountName -eq $Sam})
	{

	Get-ADUser -server "AD SERVER" -Identity $Sam | Disable-ADAccount
	Get-ADUser -server "AD SERVER" -Identity $Sam | move-ADObject -targetpath $oU 

	#Copies homedrive to destination and deletes old homedrive
	Copy-item $uDrive $disabledDrive -Recurse -force
	Remove-Item $uDrive	

	#sets the SAM account name on a disabled profile to nothing so it can be reused.
	Set-ADUser -server "AD SERVER" -Replace @{sAMAccountName = $null}
	
		#Export Profile if using roaming profile. This section is really messy and hard to explain but it's the best way to do it in my opinion.
	
	  # This for loop will increment $i from 2 to 6 running the profile move each time. This takes care of all windows version profiles for the users.
		for ($i=2;$i -le 6;$i++)
	{
		$profile = "192.168.0.2" + $Sam + ".V" + $i
	
	Set-Privilege (new-object Pscx.Interop.TokenPrivilege "SeRestorePrivilege", $true) #Necessary to set Owner Permissions
	Set-Privilege (new-object Pscx.Interop.TokenPrivilege "SeBackupPrivilege", $true) #Necessary to bypass Traverse Checking
	Set-Privilege (new-object Pscx.Interop.TokenPrivilege "SeTakeOwnershipPrivilege", $true) #Necessary to override FilePermissions & take Ownership

	$blankdirAcl = New-Object System.Security.AccessControl.DirectorySecurity
	$blankdirAcl.SetOwner([System.Security.Principal.NTAccount]'$IDM')

	(Get-Item "$profile").SetAccessControl($blankdirAcl)

	$Acl = Get-Acl "$profile"
	$Ar = New-Object system.Security.AccessControl.FileSystemAccessRule("$IDM", "FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")
	$Acl.Setaccessrule($Ar)
	takeown /s SERVER NAME WITH PROFILE /f $profile /u $IDM /P $Pass /r /d y

	Set-Acl "$profile" $Acl
	$profile2 = "$profile" + "\*"
	Set-Acl $profile2 $Acl

	Copy-item $profile $disabledProfile -Recurse -force
		Remove-item $profile -Recurse -Force
	}
	
	
	}

	else
	{
	Write-host "No user found"
	}

}
