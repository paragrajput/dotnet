# Download the .NET 5 SDK installer
$download_url = "https://dotnet.microsoft.com/download/dotnet/5.0.17"  # Update version as needed
$installer_file = "dotnet-sdk-$(Invoke-WebRequest -Uri $download_url -UseBasicParsing).Content | Select-Object -ExpandProperty downloadUrl"

Invoke-WebRequest -Uri $download_url/$installer_file -OutFile $installer_file

# Install .NET 5 SDK
Start-Process -FilePath $installer_file -Wait -ArgumentList "/quiet /norestart"

# Remove temporary installer file
Remove-Item $installer_file
