Param(
[string]$computername='LAPTOP-Sarit')
Get-WmiObject -class win32_computersystem `
	-ComputerName $computername |
	fl numberofprocessors,totalphysicalmemory
