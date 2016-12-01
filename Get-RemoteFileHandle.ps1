param([String]$Server)
Get-WmiObject win32_serverconnection -ComputerName $Server | Format-Table connectionid,username,computername,sharename,activetime,number* -auto