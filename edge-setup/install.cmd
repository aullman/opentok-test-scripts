@PowerShell.exe -ExecutionPolicy RemoteSigned -Command "Invoke-Expression -Command ((Get-Content -Path '%~f0' | Select-Object -Skip 2) -join [environment]::NewLine)"
@exit /b %Errorlevel%
#Install scoop
set-executionpolicy unrestricted -s cu -f
iex (new-object net.webclient).downloadstring('https://get.scoop.sh')
scoop install sudo

$registryPath = "HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\MediaCapture"
$registryPathItem = "$($registryPath)\AllowDomains"
sudo New-Item -Path $registryPath -Force | Out-Null
sudo New-Item -Path $registryPathItem -Force | Out-Null

$value = "3"
$domains = "{DOMAINS}"
$domainArray = $domains.split(',')

for ($i = 0; $i -lt $domainArray.Count ; $i++) {
  # Add domain to Windows Registry
  $name = $domainArray[$i]
  echo "Adding $name to Windows registry..."
  sudo New-ItemProperty -Path $registryPathItem -Name $name -Value $value -PropertyType DWORD -Force | Out-Null
}

echo "Success!"
