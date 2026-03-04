# functions for use with Amazon Web Services (AWS) resources
# these functions assume that the AWS tools for Powershell are installed (Install-Module AWS.Tools.* or AWSPowerShell.NetCore) and that authentication is already established.
function Stop-MyEC2Instance {
    Param([string]$fqdn,[System.Management.Automation.PSCredential]$RemCreds)
    # Use a remote pssession to cleanly shut down a target instance ($fqdn)
    # To be used only after patching nodes that were started for patching.

    $pssession = New-PSSession -Computer $fqdn -Credential $RemCreds
    Invoke-Command -Session $pssession -ScriptBlock {
        # 1.  Cleanly shutdown SQL Server service on the node.
        try {
            Write-Output "Stopping SQL Service (if found)"
            Stop-Service -Name MSSQLSERVER -Force -ErrorAction $SilentlyContinue
        } catch {
            Write-Output "SQL Server not running or not installed."
        }

        # 2.  Make sure the EC2 launch scripts re-run when the node is brought back up.
        #     NOTE:  There is to avoid instances with NVMe SSD drives used for 'tempdb' to not initialize through userdata.
        # Check to see if the file C:\ProgramData\Amazon\EC2-Windows\Launch\Scripts\InitializeInstance.ps1 exists.  If it does run the script with the correct option.
        $InitializeInstance="C:\ProgramData\Amazon\EC2-Windows\Launch\Scripts\InitializeInstance.ps1"
        IF (Test-Path $InitializeInstance) {
            $ExecuteInitializeInstance="${InitializeInstance} -Schedule"
            Invoke-Expression $ExecuteInitializeInstance
        }
        # 3.  Shutdown the node.
        Write-Output "Shutting down now (shutdown -s -t 5)."
        shutdown -s -t 5 -c "Shutting down ndoe after patching."
    }
    Get-PSSession | Remove-PSSession
}

# This function will check the current public IP address and update the specified Route53 records if the IP has changed.
function Update-MyRouterDNSRecords {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [String]
        $ZoneId,
        [Parameter(Mandatory=$true)]
        [String]
        $ZoneName,
        [Parameter(Mandatory=$true)]
        [String[]]
        $RecordNames
    )

    # get public IP
    $external_ip = (Invoke-WebRequest myexternalip.com/raw).content

    $records_updated =@()

    $RecordNames | ForEach-Object {
        $record = "$_.$ZoneName"
        #Write-Output "Verifying $record DNS record is still current."
        $current_record = Test-R53DNSAnswer -HostedZoneId $ZoneId -RecordName $record -RecordType "A"
        $current_ip = $current_record.RecordData
        #Write-Output "Current DNS IP: $current_ip"
        If ($current_ip -eq $external_ip) {
            #Write-Output "IP is correct, no need to change it."
        } else {
            #Write-Output "IP is not correct and will be updated from $current_ip to $external_ip."

            # change set
            $change1 = New-Object Amazon.Route53.Model.Change
            $change1.Action = "UPSERT"
            $change1.ResourceRecordSet = New-Object Amazon.Route53.Model.ResourceRecordSet
            $change1.ResourceRecordSet.Name = "$record"
            $change1.ResourceRecordSet.Type = "A"
            $change1.ResourceRecordSet.TTL = 60
            $change1.ResourceRecordSet.ResourceRecords = @()
            $change1.ResourceRecordSet.ResourceRecords.Add(@{Value="$external_ip"})

            $params = @{
                HostedZoneId="$ZONE_ID"
                ChangeBatch_Comment="This change updates the IP of $record to current."
                ChangeBatch_Change=$change1
            }
            
            # time to update the record
            $results=Edit-R53ResourceRecordSet @params
            $result_record = Test-R53DNSAnswer -HostedZoneId $ZONE_ID -RecordName $record -RecordType "A"
            $result_ip = $result_record.RecordData
            #Write-Output "Verified that $record is now set to $result_ip."
            $records_updated += $record
        }
    }
    if (!$records_updated) {
        #Write-Output "No records needed to be updated."
    } else {
        #Write-Output "Updated records: $records_updated"
    }
    Return $records_updated
}