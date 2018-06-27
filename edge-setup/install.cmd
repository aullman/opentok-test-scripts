@PowerShell.exe -ExecutionPolicy RemoteSigned -Command "Invoke-Expression -Command ((Get-Content -Path '%~f0' | Select-Object -Skip 2) -join [environment]::NewLine)"
@exit /b %Errorlevel%
#Install scoop
set-executionpolicy unrestricted -s cu -f
iex (new-object net.webclient).downloadstring('https://get.scoop.sh')
scoop install sudo

# Add domain to Windows Registry
$registryPath = "HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\MediaCapture"
$registryPathItem = "$($registryPath)\AllowDomains"
$name = "http://{DOMAIN}:{PORT}"
$value = "3"    

echo "Adding domain to Windows registry..."

sudo New-Item -Path $registryPath -Force | Out-Null   
sudo New-Item -Path $registryPathItem -Force | Out-Null    
sudo New-ItemProperty -Path $registryPathItem -Name $name -Value $value -PropertyType DWORD -Force | Out-Null

echo "Success!"
