#region Module 8 - Automation Technologies

#Short workflow
Workflow MyWorkflow {Write-Output "Hello from Workflow!"}
MyWorkflow

#Long workflow
Workflow LongWorkflow
{
Write-Output -InputObject "Information loading..."
  Start-Sleep -Seconds 10
  CheckPoint-Workflow
  Write-Output -InputObject "Performing process list..."
  Get-process -PSPersist $true #this adds checkpoint
  Start-Sleep -Seconds 10
  CheckPoint-Workflow
  Write-Output -InputObject "Cleaning up..."
  Start-Sleep -Seconds 10

}
LongWorkflow –AsJob –JobName LongWF –PSPersist $true
Suspend-Job LongWF
Get-Job LongWF
Receive-Job LongWF –Keep
Resume-Job LongWF
Get-Job LongWF
Receive-Job LongWF –Keep
Remove-Job LongWF #removes the saved state of the job

#Parallel execution
workflow paralleltest
{
    parallel
    {
        get-process -Name w*
        get-process -Name s*
        get-service -name x*
        get-eventlog -LogName Application -newest 10
    }
}
paralleltest

workflow compparam
{
   param([string[]]$computers)
   foreach –parallel ($computer in $computers)
   {
        Get-CimInstance –Class Win32_OperatingSystem –PSComputerName $computer
        Get-CimInstance –Class win32_ComputerSystem –PSComputerName $computer
   }
}
compparam -computers savazuusscdc01, savazuusedc01

#Parallel and Sequence
workflow parallelseqtest
{
    parallel
    {
        sequence
        {
            get-process -Name w*
            get-process -Name s*
        }
        get-service -name x*
        get-eventlog -LogName Application -newest 10
    }
}
parallelseqtest

Workflow RestrictionCheck
{
    $msgtest = "Hello"
    #msgtest.ToUpper()
    $msgtest = InlineScript {($using:msgtest).ToUpper()}
    Write-Output $msgtest
}
RestrictionCheck

#Calling a function
$FunctionURL = "<your URI>"
Invoke-RestMethod -Method Get -Uri $FunctionURL

Invoke-RestMethod -Method Get -Uri "$($FunctionURL)&name=John"

$JSONBody = @{name = "World"} | ConvertTo-Json
Invoke-RestMethod -Method Post -Body $JSONBody -Uri $FunctionURL
#endregion
