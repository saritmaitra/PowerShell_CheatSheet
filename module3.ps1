#region Module 3 - Remote Management

#enabling WinRM and PS Remoting
Enable-PSRemoting

Invoke-Command -ComputerName comp01 {$env:computername}
Invoke-Command -ComputerName comp01 {$var=10}
Invoke-Command -ComputerName comp01 {$var}

#Filter on remote and perform actions or strange results
Invoke-Command -ComputerName comp01 -ScriptBlock {get-eventlog -logname security} | select-object -First 10
Invoke-command -computername comp01 -scriptblock {get-eventlog -logname security | select-object -first 10}
Invoke-command -computername comp01 -scriptblock {get-eventlog -logname security -newest 10}

Invoke-Command -ComputerName comp01 -ScriptBlock {get-process} | where {$_.name -eq "notepad"} | Stop-Process
Invoke-Command -ComputerName comp01 -ScriptBlock {get-process | where {$_.name -eq "notepad"} | Stop-Process }

Measure-Command {Invoke-Command -ComputerName comp01 -ScriptBlock {get-process} | where {$_.name -eq "notepad"} }
Measure-Command {Invoke-Command -ComputerName comp01 -ScriptBlock {get-process | where {$_.name -eq "notepad"}} }


#Sessions
$session = New-PSSession -ComputerName savazuusscds01
Invoke-Command -SessionName $session {$var=10}
Invoke-Command -SessionName $session {$var}
Enter-PSSession -Session $session  #also interactive
Get-PSSession
$session | Remove-PSSession

#Multiple machines
$dcs = "comp01", "comp02"
Invoke-Command -ComputerName $dcs -ScriptBlock {$env:computername}
$sess = New-PSSession -ComputerName $dcs
$sess
icm –session $sess –scriptblock {$env:computername}

#Implicit remoting
$adsess = New-PSSession -ComputerName savazuusscdc01
Import-Module -Name ActiveDirectory -PSSession $adsess
Get-Module #type different from the type on the actual DC
Get-Command -Module ActiveDirectory #functions instead of cmdlets
Get-ADUser -Filter *
$c = Get-Command Get-ADUser
$c.Definition
Remove-Module ActiveDirectory
Import-Module -Name ActiveDirectory -PSSession $adsess -Prefix OnDC
Get-Command -Module ActiveDirectory
Get-OnDCADUser -Filter *  #I don't have regular Get-ADUser anymore

#Execution operator &
$comm = "get-process"
$comm   #Nope
&$comm  #Yep!


#PowerShell Core Compatibility with Windows PowerShell modules
get-module -ListAvailable -SkipEditionCheck
Get-EventLog  #Fails in PowerShell Core
Install-Module WindowsCompatibility -Scope CurrentUser
Import-WinModule Microsoft.PowerShell.Management
Get-EventLog -Newest 5 -LogName "security"
#Behind the scenes
$c = Get-Command get-eventlog
$c
$c.definition
Get-PSSession #Note the WinCompat session to local machine


#Alternate endpoint
Enable-WSManCredSSP -Role "Server" -Force
New-PSSessionConfigurationFile –ModulesToImport OneTech, ActiveDirectory, Microsoft.PowerShell.Utility `
	–VisibleCmdLets ('*OneTech*','*AD*','format*','get-help') `
	-VisibleFunctions ('TabExpansion2') -VisibleAliases ('exit','ft','fl') –LanguageMode ConstrainedLanguage `
	-VisibleProviders FileSystem `
	–SessionType ‘RestrictedRemoteServer’ –Path ‘c:\dcmonly.pssc’
Register-PSSessionConfiguration -Name "DCMs" -Path C:\dcmonly.pssc -StartupScript C:\PSData\DCMProd.ps1

$pssc = Get-PSSessionConfiguration -Name "DCMs"
$psscSd = New-Object System.Security.AccessControl.CommonSecurityDescriptor($false, $false, $pssc.SecurityDescriptorSddl)

$Principal = "sarit\DCMs"
$account = New-Object System.Security.Principal.NTAccount($Principal)
$accessType = "Allow"
$accessMask = 268435456
$inheritanceFlags = "None"
$propagationFlags = "None"
$psscSd.DiscretionaryAcl.AddAccess($accessType,$account.Translate([System.Security.Principal.SecurityIdentifier]),$accessMask,$inheritanceFlags,$propagationFlags)
Set-PSSessionConfiguration -Name "DCMs" -SecurityDescriptorSddl $psscSd.GetSddlForm("All") -Force
#Set-PSSessionConfiguration -Name "DCMs" -ShowSecurityDescriptorUI
Restart-Service WinRM


#Enabling HTTPS
Winrm create winrm/config/Listener?Address=*+Transport=HTTPS @{Hostname="host";CertificateThumbprint="thumbprint"}
#e.g.
cd Cert:\LocalMachine\My
Get-ChildItem #or ls remember. Find the thumbprint you want
winrm create winrm/config/listener?address=*+Transport=HTTPS @{Hostname="savazuusscdc01.savilltech.net";CertificateThumbprint="B4B3FAE3F30944617E477F77756D6ABCB9980E38"}
New-NetFirewallRule -DisplayName "Windows Remote Management (HTTPS-In)" -Name "Windows Remote Management (HTTPS-In)" -Profile Any -LocalPort 5986 -Protocol TCP

#To view - must be elevated
winrm enumerate winrm/config/Listener

#Connect using SSL
Invoke-Command comp01.xxxx.net -ScriptBlock {$env:computername} -UseSSL
#Short name will fail as using cert can override
$option = New-PSSessionOption -SkipCACheck -SkipCNCheck -SkipRevocationCheck
Enter-PSSession -ComputerName comp01 -SessionOption $option -useSSL

#Connection via SSH  hostname instead of computername
Invoke-Command -HostName compx01 -ScriptBlock {get-process} -UserName sarit

#Mix of WinRM and SSH
New-PSSession -ComputerName comp01  #winrm
New-PSSession -HostName compnx01 -UserName sarit
Get-PSSession -OutVariable sess
$sess
invoke-command $sess {get-process *s}
$sess | Remove-PSSession

#endregion
