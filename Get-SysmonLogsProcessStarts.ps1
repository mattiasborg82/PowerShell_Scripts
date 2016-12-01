<#
.Synopsis
   .\Get-SysmonLogsProcessStarts.ps1
.DESCRIPTION
   This cmd-let will make it possible to get the logs from sysmon which you can filter and search for malicious activity
.EXAMPLE
   .\Get-SysmonLogsProcessStarts.ps1
.EXAMPLE
   .\Get-SysmonLogsProcessStarts.ps1 | where {($_.parentImage -like "*office*") -and ($_.CommandLine -like "*powershell*")}
#>

    Param
    (
  
        [array]$Computers = $env:computername
     
    )

Foreach ($ComputerName in $Computers)
{
    try
    {


    $events = Get-WinEvent -computername $ComputerName -FilterHashtable @{logname="Microsoft-Windows-Sysmon/Operational";Id=1;} -erroraction silentlycontinue

    foreach ($event in $events)
        {
     
     
            $eventXML = [xml]$Event.ToXml()

                # Create Object
                New-Object -Type PSObject -Property @{
                UTCTime = $eventXML.Event.EventData.Data[0].'#text'
                CommandLine = $eventXML.Event.EventData.Data[4].'#text'
                CurrentDirectory = $eventXML.Event.EventData.Data[5].'#text'
                User = $eventXML.Event.EventData.Data[6].'#text'
                IntegrityLevel = $eventXML.Event.EventData.Data[10].'#text'
                Hashes = $eventXML.Event.EventData.Data[11].'#text'
                ParentImage = $eventXML.Event.EventData.Data[14].'#text'
                 }

            
        }
   

    }
        catch
            {
            
                Write-Host "Something went wrong, please install Sysmon`nHost: $ComputerName"
            
            }

