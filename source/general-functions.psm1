# functions that do generic actions, usable by all other functions.

# function to write a log file entry. $log_file can be any filename, whether the file exists or not.

function Write-LogEntry {
    param($logTxt, $log_file)
    $time_stamp = Get-Date
    Write-Output "$time_stamp == Logging: $logTxt "

    # check for existing logfile
    Write-Output "$time_stamp : $logTxt" >> $log_file
}

# function to setup log source
function New-EventLogSource {
    param(
        [Parameter(Mandatory=$true)]
        [String]
        $logSource,
        [Parameter(Mandatory=$false)]
        [String]
        $logName = "Application"
    )
    if (-not [System.Diagnostics.EventLog]::SourceExists($logSource)) {
        New-EventLog -LogName $logName -Source $logSource
    }
}

# function to write a log entry into a Windows Event log.
function Write-EventLogEntry {
    param(
        [Parameter(Mandatory=$true)]
        [String]
        $logTxt,
        [Parameter(Mandatory=$false)]
        [String]
        $logSource = "Homelab",
        [Parameter(Mandatory=$false)]
        [String]
        $logName = "Application",
        [Parameter(Mandatory=$false)]
        [Int32]
        $eventId = 1000
    )

    $time_stamp = Get-Date
    $logTxt = "$time_stamp == Logging: "+"$logTxt"
    Write-EventLog -LogName $logName -Source $logSource -EventID $eventId -EntryType Information -Message $logTxt
}

Function Invoke-LogRotation {
    # Log rotation function. Will rename specified log file with a timestamp version.
    # The variable $log_file should be the full path to the log file to rotate.

    param(
        [Parameter(Mandatory=$true)]
        [String]
        $logFile
    )

    if (Test-Path -Path $logFile) {
        $time_stamp = Get-Date -Format "yyyy-MM-dd"
        $new_log_file = "$time_stamp-$($logFile)"
        try {
            Rename-Item -Path $logFile -NewName $new_log_file
            New-Item -Path "$logFile" -ItemType File
            Write-Output "Log file $logFile rotated successfully."
        } catch {
            Write-Output "Error rotating log file: $logFile. Error: $_"
        }
        
    } else {
        Write-Output "Log file $logFile not found, skipping log rotation."
    }
}