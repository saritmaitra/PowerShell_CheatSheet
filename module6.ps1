#region Module 6 - Parsing Data and Working With Objects

#Credentials
#This is not good
$user = "administrator"
$password = 'Pa55word'
$securePassword = ConvertTo-SecureString $password `
    -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($user, $securePassword)

#An encrypted string
$encryptedPassword = ConvertFrom-SecureString (ConvertTo-SecureString -AsPlainText -Force "Password123")
$securepassword = ConvertTo-SecureString "<the huge value from previous command>"

#Another file
$credpath = "c:\temp\MyCredential.xml"
New-Object System.Management.Automation.PSCredential("sarit.maitra@alemark.com", (ConvertTo-SecureString -AsPlainText -Force "Password123")) | Export-CliXml $credpath
$cred = import-clixml -path $credpath

#Using Key Vault
Select-AzSubscription -Subscription (Get-AzSubscription | where Name -EQ "Microsoft Partner Network")
$cred = Get-Credential

#Store username and password in keyvault
Set-AzKeyVaultSecret -VaultName 'SMVault' -Name 'SamplePassword' -SecretValue $cred.Password
$secretuser = ConvertTo-SecureString $cred.UserName -AsPlainText -Force #have to make a secure string
Set-AzKeyVaultSecret -VaultName 'SMVault' -Name 'SampleUser' -SecretValue $secretuser

#Getting back
$username = (get-azkeyvaultsecret -vaultName 'SMVault' -Name 'SampleUser').SecretValueText
$password = (get-azkeyvaultsecret -vaultName 'SMVault' -Name 'SamplePassword').SecretValue
(get-azkeyvaultsecret -vaultName 'SMVault' -Name 'SamplePassword').SecretValueText #Can get the plain text via key vault
[Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($password)) #Inspect if want to double check

#Recreate
$newcred = New-Object System.Management.Automation.PSCredential ($username, $password)
#Test
invoke-command -ComputerName comp01 -Credential $newcred -ScriptBlock {whoami}

#Var types
$number=42
$boolset=$true
$stringval="hello"
$charval='a'
$number.GetType()
$boolset.GetType()
$stringval.GetType()
$charval.GetType()

[char]$newchar= 'a'
$newchar.GetType()

42 –is [int]

$number = [int]42
$number.ToString() | gm

$string1 = "rain drops are falling on my hat"
$string1 -like "*fox*"
$string2 = $string1 + " beautiful day"


#Time
$today=Get-Date
$today | Select-Object –ExpandProperty DayOfWeek
[DateTime]::ParseExact("02-25-2011","MM-dd-yyyy",[System.Globalization.CultureInfo]::InvariantCulture)
$christmas=[system.datetime]"25 December 2019"
($christmas - $today).Days
$today.AddDays(-60)
$a = new-object system.globalization.datetimeformatinfo
$a.DayNames

#Variable Scope
function test-scope()
{
    write-output $defvar
    write-output $global:globvar
    write-output $script:scripvar
    write-output $private:privvar
    $funcvar = "function"
    $private:funcpriv = "funcpriv"
    $global:funcglobal = "globfunc"
}

$defvar = "default/local" #default
get-variable defvar -scope local
$global:globvar = "global"
$script:scripvar = "script"
$private:privvar = "private"
test-scope
$funcvar
$funcglobal #this should be visible

#Variables with Invoke-Command
$message = "Message to Sarit"
Invoke-Command -ComputerName savazuusscdc01 -ScriptBlock {Write-Host $message}

$ScriptBlockContent = {
    param ($MessageToWrite)
    Write-Host $MessageToWrite }
Invoke-Command -ComputerName savazuusscdc01 -ScriptBlock $ScriptBlockContent -ArgumentList $message
#or
Invoke-Command -ComputerName savazuusscdc01 -ScriptBlock {Write-Output $args} -ArgumentList $message

Invoke-Command -ComputerName savazuusscdc01 -ScriptBlock {Write-Host $using:message}


#Hash Tables
$favthings = @{"Julia"="Sushi";"Ben"="Trains";"Abby"="Princess";"Kevin"="Minecraft"}
$favthings.Add("John","Crab Cakes")
$favthings.Set_Item("John","Steak")
$favthings.Get_Item("Abby")

#Custom objects
$cusobj = New-Object PSObject
Add-Member -InputObject $cusobj -MemberType NoteProperty `
    -Name greeting -Value "Hello"

$favthings = @{"Julie"="Sushi";"Ben"="Trains";"Abby"="Princess";"Kevin"="Minecraft"}
$favobj = New-Object PSObject -Property $favthings
#In PowerShell v3 can skip a step
$favobj2 = [PSCustomObject]@{"Julie"="Sushi";"Ben"="Trains";"Abby"="Princess";"Kevin"="Minecraft"}


#Foreach
$names = @("Julie","Abby","Ben","Kevin")
$names | ForEach-Object -Process { Write-Output $_}
$names | ForEach -Process { Write-Output $_}
$names | ForEach { Write-Output $_}
$names | % { Write-Output $_}

#Foreach vs Foreach
ForEach-Object -InputObject (1..100) {
    $_
} | Measure-Object

ForEach ($num in (1..100)) {
    $num
} | Measure-Object

'Z'..'A'

#Accessing property values
$samacctname = "Sarit"
Get-ADUser $samacctname  -Properties mail
Get-ADUser $samacctname  -Properties mail | select-object mail
Get-ADUser $samacctname  -Properties mail | select-object mail | get-member
Get-ADUser $samacctname  -Properties mail | select-object -ExpandProperty mail | get-member
Get-ADUser $samacctname  -Properties mail | select-object -ExpandProperty mail


#endregion
