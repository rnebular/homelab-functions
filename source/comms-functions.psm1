# functions for any kind of communication, like email or discord.

# function to send an email notification
# requires the environment variables $env:EMAIL_USERNAME and $env:EMAIL_APP_PASSWORD to be set to a valid Gmail address and app password.
function Send-GmailNotification {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [String]
        $EmailFrom = "jtbyrum@gmail.com",
        [Parameter(Mandatory=$true)]
        [String]
        $EmailTo,
        [Parameter(Mandatory=$false)]
        [String]
        $EmailSubject = "Test Email from PowerShell",
        [Parameter(Mandatory=$false)]
        [String]
        $Body = "This is a test email sent from PowerShell using Gmail's SMTP server."
    )

    # Email parameters
    $SMTPServer = "smtp.gmail.com"
    $SMTPPort = 587

    $SecurePassword = ConvertTo-SecureString -String $env:EMAIL_APP_PASSWORD -AsPlainText -Force
    $Credential = New-Object System.Management.Automation.PSCredential($env:EMAIL_USERNAME, $SecurePassword)

    # Send the email
    try {
        Send-MailMessage -From $EmailFrom -To $EmailTo -Subject $EmailSubject -Body $Body -SmtpServer $SMTPServer -Port $SMTPPort -UseSsl -Credential $Credential
        Write-Output "Email sent successfully to $EmailTo"
    } catch {
        Write-Output "Failed to send email: $_"
    }
}

# function to send a log message to graylog using the GELF format over UDP
# usage example:
# Send-GraylogGelfMessage -Message "This is a test GELF message from PowerShell." -Level "6" -AdditionalFields @{ "environment" = "test"; "application" = "MyApp" } -GraylogHost "graylog.example.com" -Port 12201
function Send-GraylogMessage {
    param(
        [string]$GraylogHost,
        [int]$Port = 12201,
        [string]$Message,
        [string]$Level = "6",  # 0=Emergency, 1=Alert, 2=Critical, 3=Error, 4=Warning, 5=Notice, 6=Info, 7=Debug
        [hashtable]$AdditionalFields = @{}
    )

    $gelfMessage = @{
        version       = "1.1"
        host          = $env:COMPUTERNAME
        short_message = $Message
        timestamp     = [DateTimeOffset]::UtcNow.ToUnixTimeSeconds()
        level         = $Level
    }

    # Add custom fields (must be prefixed with _)
    foreach ($key in $AdditionalFields.Keys) {
        $gelfMessage["_$key"] = $AdditionalFields[$key]
    }

    $json = $gelfMessage | ConvertTo-Json -Compress
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($json)

    $udpClient = New-Object System.Net.Sockets.UdpClient
    $udpClient.Send($bytes, $bytes.Length, $GraylogHost, $Port) | Out-Null
    $udpClient.Close()
}

# end of line