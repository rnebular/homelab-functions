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