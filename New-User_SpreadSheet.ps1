Get-Module ImportExcel
Get-Module ActiveDirectory
(Get-ADDomainController).Name

$Sheet=".\NewUsers.xlsx"
$UserData=Import-Excel $Sheet

#Check user list data loaded
$UserData | Format-Table

#Default Password For New User Added
$password="abc@123456" | ConvertTo-SecureString -AsPlainText -Force


#Get Domain Name for create User Logon Name 
$domain=Get-ADDomain
$domain_name=$domain.DNSRoot

#Load User Template
$user_template=Get-ADUser 'UserTemplate' -Properties MemberOf,StreetAddress,City,Country
$user_template

#Create new user with command New-ADUser
ForEach($aUser in $UserData)
{
$FullName=$aUser."Full Name".Replace(" ",".")
$LogonName=$FullName+"@"+$domain_name
$FistName=$aUser."First Name"
$LastName=$aUser."Last Name"
$Department=$aUser."Department"
$Phone=$aUser."Phone"
$Job=$aUser."Job Titile"
Write-Host $FullName
New-ADUser -Name $FullName -UserPrincipalName $LogonName `
-GivenName $LastName -Surname $FistName -OfficePhone $Phone -Office $Department -Title $Job `
-AccountPassword $password -ChangePasswordAtLogon $True -Enabled $True -Instance $user_template
}