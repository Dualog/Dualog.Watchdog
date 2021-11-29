
<#
.SYNOPSIS
    Check Dualog services
.DESCRIPTION
	This script starts Dualog services that are not running.
.EXAMPLE
	PS> ./service-manager
.NOTES
	Author: Fredrik Eilertsen @ Dualog
.LINK
	https://github.com/dualog
#>

$debug = 1
$dateNow = (Get-Date).ToUniversalTime()
$logStamp = $dateNow.toString("dd_MM_yyyy")
$logFileName = "C:\Dualog\Logs\DualogServiceManager_$logStamp.log"

function WriteLog
{
    Param ([string]$LogString, [string]$Level="Information")
    $Stamp = $dateNow.toString("yyyy-MM-dd HH:mm:ss")
    $LogMessage = "$Stamp [$Level] $LogString"
    if($debug) {
        Write-Host $LogMessage
    }

    Add-content $logFileName -value $LogMessage
}

WriteLog "Starting Dualog task manager"

[Array] $services = 'TestClient2';

# loop through each service, if its not running, start it
foreach($serviceName in $services)
{
    WriteLog "Checking service '$serviceName'"
    
    $arrService = Get-Service -Name $serviceName -ea 0

    if(!$arrService) {

        WriteLog "Could not find service '$serviceName'"
        continue
    }

    # Service already running, abort
    if ($arrService.Status -eq 'Running') {
        WriteLog "Service '$serviceName' is already running"
        continue
    }

    while ($arrService.Status -ne 'Running')
    {
        $status = $arrService.status
        WriteLog "Status for service '$serviceName': $status"

        WriteLog "Starting service '$serviceName'"
        
        Start-Service $arrService.Name

        Start-Sleep -seconds 30
        $arrService.Refresh()

        if ($arrService.Status -eq 'Running')
        {
          WriteLog 'Service is now Running'
        }
    }
}
