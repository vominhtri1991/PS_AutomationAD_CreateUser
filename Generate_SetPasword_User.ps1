Get-Module ActiveDirecctory
$username=Read-Host -Prompt 'Input user need reset password: '
try{
$User=Get-ADUser $username

#Generate random comples password for user
Add-Type -AssemblyName System.Web
$randomPassword=[System.Web.Security.Membership]::GeneratePassword(9,2)
Write-Host "New password of user: $randomPassword"

#Convert passowrd to secure string for setting to AD User:
$secure_passowrd=$randomPassword | ConvertTo-SecureString -AsPlainText -Force

#Reset password for AD user
Set-ADAccountPassword -Identity $username -NewPassword $secure_passowrd

#Enbale user and set change password when user login again
Set-ADUser $username -Enabled $true -ChangePasswordAtLogon $true
} 
catch [Microsoft.ActiveDirectory.Management.ADIdentityResolutionException] 
{
 "Username does not exist on domain"
}
