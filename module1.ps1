#region Module 1 - PowerShell Fundamentals

#Basic Pipeline
dir | Sort-Object -Descending

dir | Sort-Object lastwritetime

dir | sort-object –descending –property lastwritetime

#To show the object types being passed
dir | foreach {"$($_.GetType().fullname)  -  $_.name"}  #lazy quick version using alias
Get-ChildItem | ForEach-Object {"$($_.GetType().fullname)  -  $_.name"}  #Proper script version

#Modules
Get-Module #to see those loaded
Get-Module –listavailable #to see all available
Import-Module <module>  #to add into PowerShell instance
Get-Command –Module <module> #to list commands in a module
Get-Command -Module <module> | Select-Object -Unique Noun | Sort-Object Noun
Get-Command -Module <module> | Select -Unique Noun | Sort Noun  #Lazy version :-)

(Get-Module <module name>).Version  #make sure module has been imported first or will not get output
(Get-Module az.compute).Version
Install-Module Az
Update-Module Az


#Help
Get-Command –Module <module>
Get-Command –Noun <noun>
Update-Help

#Hello World
Write-Output "Hello beautiful people"

#Hello Universe
Write-Output "Wolf of wall street"

#Use a variable
$name = "Sarit"
Write-Output "Hello $name"

#Use an environment variable
Write-Output "Hello $env:USERNAME"

#endregion
