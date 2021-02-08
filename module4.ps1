#region Module 4 - PowerShell Scripting

#Shows write-host vs write-output
function Receive-Output
{
    process { write-host $_ -ForegroundColor Green}
}
Write-Output "this is a test" | Receive-Output
Write-Host "this is a test" | Receive-Output
Write-Output "this is a test"

#' vs "
$name = "Sarit"
Write-Output "Hello $name"
Write-Output 'Hello $name'
$query = "SELECT * FROM OS WHERE Name LIKE '%SERVER%'"
Write-Output "Hello `t`t`t World"

#User input
$name = Read-Host "Who are you?"
$pass = Read-Host "What's your password?" -AsSecureString
[Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($pass))


Get-CimInstance -ClassName Win32_Logical  #ctrl space to intelli sense all the name spaces available

#endregion
