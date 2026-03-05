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
