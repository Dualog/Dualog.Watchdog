
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

$debug = 0
$dateNow = (Get-Date).ToUniversalTime()
$logStamp = $dateNow.toString("dd_MM_yyyy")
$contentRoot = Split-Path $MyInvocation.MyCommand.Path -Parent 
$logFilePath = Join-Path $contentRoot "Logs"
$logFileName = "$logFilePath\DualogServiceManager_$logStamp.log"

function Log {
    Param (
        [string]$LogString, 
        [string]$Level="Information")

    # Make sure log path exists
    if (!(Test-Path $logFilePath)) {
        New-Item -Path $logFilePath -Type Directory | Out-Null
    }

    $stamp = (Get-Date).ToUniversalTime().toString("yyyy-MM-dd HH:mm:ss")

    $LogMessage = "$stamp [$Level] $LogString"

    # Write to Console if debug = 1
    if($debug) {
        Write-Host $LogMessage
    }

    Add-content $logFileName -value $LogMessage
}

Function Get-UpTime {
    $OS = Get-WmiObject Win32_OperatingSystem
    $Uptime = (Get-Date) - ($OS.ConvertToDateTime($OS.LastBootupTime))
    return $Uptime
  }

Log "Starting Dualog task manager"
Log "Computer uptime: $((Get-UpTime).TotalMinutes) minutes"

[Array] $services = 'DualogAccessClient';

# loop through each service, if its not running, start it
foreach($serviceName in $services)
{
    Log "Checking service '$serviceName'"
    
    # -ea flag = ErrorAction. Silent error, variable set to null.
    $arrService = Get-Service -Name $serviceName -ea 0
    if(!$arrService) {
        Log "Could not find service '$serviceName'" "Error"
        continue
    }

    # Service already running, abort
    if ($arrService.Status -eq 'Running') {
        Log "Service '$serviceName' is already running"
        continue
    }

    [int] $retryCount = "0"

    while ($arrService.Status -ne 'Running')
    {
        if ($retryCount -gt 3) {
            break
        }

        $status = $arrService.status
        Log "Status for service '$serviceName': $status"

        Log "Starting service '$serviceName'"
        
        Start-Service $arrService.Name

        Start-Sleep -seconds 30
        $arrService.Refresh()

        if ($arrService.Status -eq 'Running')
        {
          Log "Service '$serviceName' is now Running"
        }

        $retryCount = $retryCount + 1
    }
}

exit 0