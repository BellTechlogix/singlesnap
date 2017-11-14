add-pssnapin VMware.VimAutomation.Core

Get-Module –ListAvailable VM* | Import-Module

Connect-VIServer -Server JAXVC01

$servername = import-csv singlesnapservers.csv
$name = '111817 Maintenance'
$description = 'INC0048080 for Naoko Neff'
$subject = 'Snaps Complete for '+$name+' '+$description

$servername | foreach ( New-Snapshot -vm $_.servername -Name $name -Description $description -RunAsync }

$servername | foreach { Get-Snapshot -vm $_.servername | select vm,name,description,created,sizeGB | export-csv -append singlesnapdetails.csv -notype }

Disconnect-VIServer -server JAXVC01 -confirm:$False

Send-MailMessage -from svc_wug@crowley.com -to tjohnson@belltechlogix.com -subject $subject -smtpserver mail.crowley.com -attachment singlesnapdetails.csv

Remove-Item singlesnapdetails.csv