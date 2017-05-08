<#
.Synopsis
   Get-WPAKey to extract the WPA key for a specific SSID
.DESCRIPTION
   Get the WPA Key, authentication type, SSIDName from all SSID profiles in the computer
.EXAMPLE
   Get-WPAkey
.EXAMPLE
   Get-WPAkey -SSID "MySSID"
.NOTES
   SEC-LABS R&D
#>

param([Parameter(Mandatory=$FALSE,
ValueFromPipelineByPropertyName=$FALSE,
Position=0)]
$SSID = (netsh wlan show profiles | Select-String "All User Profile"))
 
foreach ($profile in $SSID)
	{
	 
		try{
			$SSID = ($profile.ToString().Split(":")[1]).trim()
		}
		catch{}
		try
		{
			$Data = netsh wlan show profiles name="$SSID" key=clear | select-String Authentication, Cipher, "Key Content"
			$Data = $Data -split ":"
			[string]$Authentication = $Data[1]
			[string]$Cipher = $Data[3]
			[string]$Key = $data[9]
		}
		catch
		{
		}
	 
		New-Object -Type PSObject -Property @{
		Authentication = $Authentication.trim()
		SSIDName = $SSID
		Cipher = $Cipher.trim()
		Key = $Key.trim()
	 	}
	 
	}
