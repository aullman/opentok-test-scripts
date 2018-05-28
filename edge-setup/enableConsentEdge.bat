@PowerShell.exe -ExecutionPolicy RemoteSigned -Command "Invoke-Expression -Command ((Get-Content -Path '%~f0' | Select-Object -Skip 2) -join [environment]::NewLine)"
@exit /b %Errorlevel%
#Install scoop
set-executionpolicy unrestricted -s cu -f
iex (new-object net.webclient).downloadstring('https://get.scoop.sh')
scoop install sudo

# Add Enable Consent to Windows Registry
$registryPath = "HKLM:\Software\Microsoft\MicrosoftEdge"
$registryPathItem = "$($registryPath)\MediaCapture"
$name = "EnableConsentPrompt"
$value = "0"  

echo "Adding enable consent to Windows registry..."

sudo New-Item -Path $registryPath -Force | Out-Null   
sudo New-Item -Path $registryPathItem -Force | Out-Null    
sudo New-ItemProperty -Path $registryPathItem -Name $name -Value $value -PropertyType DWORD -Force | Out-Null

echo "Restarting Microsoft Edge..."

Stop-Process -Name "MicrosoftEdge"
Stop-Process -Name "MicrosoftEdgeCP"
Start-Sleep -s 10
Start-Process -FilePath "MicrosoftEdge" -Wait -WindowStyle Maximized

echo "Success!"
