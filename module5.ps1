#region Module 5 - Advanced PowerShell Scripting

function first3 {$input | Select-Object -First 3}
get-process | first3

#Code signing
$cert = @(gci cert:\currentuser\my -codesigning)[0]
Set-AuthenticodeSignature signme.ps1 $cert

#endregion
