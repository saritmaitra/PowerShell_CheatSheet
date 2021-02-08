#region Module 7 - Desired State Configuration

#Imperative install
Import-Module ServerManager
#Check and install Web Server Role if not installed
If (-not (Get-WindowsFeature "Web-Server").Installed)
{
    try {
        Add-WindowsFeature Web-Server
    }
    catch {
        Write-Error $_
    }
}

#Get all providers
Get-DscResource

#endregion
