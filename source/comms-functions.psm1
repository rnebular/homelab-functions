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

# # function to send a message to Slack.
# # assumes environment variable '$env:SLACK_TOKEN' is already set to a valid Slack token.
# function Send-SlackMessage {
#     param($msgTxt, $status, $slackChannel = "#channel", $slackUsername="user-name", $ThreadId)
    
#     switch ($status) {
#         error {
#             $emoji = ":alert:"
#         }
#         warn {
#             $emoji = ":warning:"
#         }
#         info {
#             $emoji = ":information_source:"
#         }
#         success {
#             $emoji = ":success:"
#         }
#         yoda {
#             $emoji = ":baby-yoda-soup:"
#         }
#         default {
#             $emoji = ":1up:"
#         }
#     }

#     $Payload = @{
#         channel = $slackChannel
#         text = "$emoji $msgTxt"
#         username = $slackUsername 
#         unfurl_links = 'false'
#         unfurl_media = 'false'
#         reply_broadcast = $($status -eq 'error') ? 'true' : 'false'
#         thread_ts = $ThreadId
#     }

#     # https://api.slack.com/methods/chat.postMessage
#     $Response = Invoke-RestMethod -Method POST -Uri 'https://slack.com/api/chat.postMessage' `
#         -Headers @{'Authorization'="Bearer $env:SLACK_TOKEN"} `
#         -ContentType 'application/json' -Body $($Payload | ConvertTo-Json)
#     [PSCustomObject]@{
#         Channel = $slackChannel
#         ThreadId = $Response.ts
#     }
# }