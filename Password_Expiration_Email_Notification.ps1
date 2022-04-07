## Send-PasswordExpiryEmails.ps1
## Author: Teddy Mbuthi
## Created: 2/17/2022
## -----------------------------

#Import AD Module
 Import-Module ActiveDirectory

#Create warning dates for future password expiration
$SevenDayWarnDate = (get-date).adddays(7).ToLongDateString()
$ThreeDayWarnDate = (get-date).adddays(3).ToLongDateString()
$OneDayWarnDate = (get-date).adddays(1).ToLongDateString()


#Email Variables
$MailSender = "Password AutoBot passwordbot@alertinnovation.com"
$Subject = 'Password will expire soon'
$EmailStub1 = 'Hello Alertian,

This is an automated email. I am here to inform you that the password for'
$EmailStub2 = 'will expire in'
$EmailStub3 = 'days on'
$EmailStub4 = '. To change your password, please follow the steps in the Password Reset PDF attached above. 

Please submit a ticket if you have any issues: "https://helpdesk.alertinnovation.com"
Also, feel free to ask any questions in the #it channel on Slack. Do NOT reply to this email.

If you are unsure if this message is authentic, please contact the helpdesk. 

Thank you,
Alert Innovation IT'
$Policy = 'C:\Password Reset\Password_Reset.pdf'
$SMTPServer = 'alertinnovation-com.mail.protection.outlook.com'


#Find accounts that are enabled and have expiring passwords
$users = Get-ADUser -filter {Enabled -eq $True -and PasswordNeverExpires -eq $False -and PasswordLastSet -gt 0 } `
 -Properties "Name", "EmailAddress", "msDS-UserPasswordExpiryTimeComputed" | Select-Object -Property "Name", "EmailAddress", `
 @{Name = "PasswordExpiry"; Expression = {[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed").tolongdatestring() }}


#check password expiration date and send email on match
foreach ($user in $users) {
     if ($user.PasswordExpiry -eq $SevenDayWarnDate) {
         $days = 7
         $EmailBody = $EmailStub1, $user.name, $EmailStub2, $days, $EmailStub3, $SevenDayWarnDate, $EmailStub4 -join ' '
         Send-MailMessage -To $user.EmailAddress -From $MailSender -SmtpServer $SMTPServer -Subject $Subject -Body $EmailBody -Attachments $Policy
     }
     elseif ($user.PasswordExpiry -eq $ThreeDayWarnDate) {
         $days = 3
         $EmailBody = $EmailStub1, $user.name, $EmailStub2, $days, $EmailStub3, $ThreeDayWarnDate, $EmailStub4 -join ' '
         Send-MailMessage -To $user.EmailAddress -From $MailSender -SmtpServer $SMTPServer -Subject $Subject `
         -Body $EmailBody -Attachments $Policy
     }
     elseif ($user.PasswordExpiry -eq $oneDayWarnDate) {
         $days = 1
         $EmailBody = $EmailStub1, $user.name, $EmailStub2, $days, $EmailStub3, $OneDayWarnDate, $EmailStub4 -join ' '
         Send-MailMessage -To $user.EmailAddress -From $MailSender -SmtpServer $SMTPServer -Subject $Subject -Body $EmailBody -Attachments $Policy
     }
    else {}
 }