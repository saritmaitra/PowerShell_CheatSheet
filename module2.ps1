#region Module 2 - Connecting Commands

#Looking at variable type
notepad
$proc = Get-Process –name notepad
$proc.GetType().fullname
$proc | Get-Member

get-process | Where-Object {$_.handles -gt 900} | Sort-Object -Property handles |
    ft name, handles -AutoSize

#Must be elevated
Get-WinEvent -LogName security -MaxEvents 10 | Select-Object -Property Id, TimeCreated, Message |
    Sort-Object -Property TimeCreated | convertto-html | out-file c:\sec.html

$xml = [xml](get-content .\R_and_j.xml)
$xml.PLAY
$xml.PLAY.ACT
$xml.PLAY.ACT[0].SCENE[0].SPEECH
$xml.PLAY.ACT.SCENE.SPEECH | Group-Object speaker | Sort-Object count


#Output to file
Get-Process > procs.txt
Get-Process | Out-File procs.txt #what is really happening
get-process | Export-csv c:\stuff\proc.csv
get-process | Export-clixml c:\stuff\proc.xml

#Limiting objects returned
Get-Process | Sort-Object -Descending -Property StartTime | Select-Object -First 5
Get-Process | Measure-Object
Get-Process | Measure-Object WS -Sum

#PowerShell Core or Windows PowerShell
Get-WinEvent -LogName security -MaxEvents 5
Invoke-Command -ComputerName savazuusscdc01, savazuusedc01 `
    -ScriptBlock {get-winevent -logname security -MaxEvents 5}

#Windows PowerShell only
Get-EventLog -LogName Security -newest 10
Invoke-command -ComputerName savdaldc01,savdalfs01,localhost `
    -ScriptBlock {Get-EventLog -LogName Security -newest 10}


#Comparing
get-process | Export-csv d:\temp\proc.csv
Compare-Object -ReferenceObject (Import-Csv d:\temp\proc.csv) -DifferenceObject (Get-Process) -Property Name

notepad
$procs = get-process
get-process -Name notepad | Stop-Process
$procs2 = get-process
Compare-Object -ReferenceObject $procs -DifferenceObject $procs2 -Property Name


# -confirm and -whatif
get-aduser -filter * | Remove-ADUser -whatif

Get-ADUser -Filter * -Properties "LastLogonDate" `
    | where {$_.LastLogonDate -le (Get-Date).AddDays(-60)} `
    | sort-object -property lastlogondate -descending `
    | Format-Table -property name, lastlogondate -AutoSize

 Get-ADUser -Filter * -Properties "LastLogonDate" `
    | where {$_.LastLogonDate -le (Get-Date).AddDays(-60)} `
    | sort-object -property lastlogondate -descending `
    | Disable-ADAccount -WhatIf

$ConfirmPreference = "medium"
notepad
Get-Process | where {$_.name –eq "notepad"} | Stop-Process
notepad
get-process | where {$_.name -eq "notepad"} | stop-process -confirm:$false
$ConfirmPreference = "high"
Get-Process | where {$_.name –eq "notepad"} | Stop-Process


#Using $_

Get-Process | Where-Object {$_.name –eq "notepad"} | Stop-Process

#Simply notation
Get-Process | where {$_.HandleCount -gt 900}
Get-Process | where {$psitem.HandleCount -gt 900}
Get-Process | where HandleCount -gt 900
Get-Process | ? HandleCount -gt 900


$UnattendFile = "unattend.xml"
$xml = [xml](gc $UnattendFile)
$child = $xml.CreateElement("TimeZone", $xml.unattend.NamespaceURI)
$child.InnerXml = "Central Standard Time"
$null = $xml.unattend.settings.Where{($_.Pass -eq 'oobeSystem')}.component.appendchild($child)
#$xml.Save($UnattendFile)
$xml.InnerXml

$resources = Get-AzResourceProvider -ProviderNamespace Microsoft.Compute
$resources.ResourceTypes.Where{($_.ResourceTypeName -eq 'virtualMachines')}.Locations


#endregion
