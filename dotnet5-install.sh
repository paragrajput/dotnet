#!/bin/bash

# .NET 5 (LTS) download URL (replace if needed)
DOTNET_URL="https://dotnet.microsoft.com/download/dotnet/5.0.17"

# Installation directory (modify as desired)
DOTNET_INSTALL_DIR="/usr/local/share/dotnet"

# Check for dependencies (adjust for your distribution)
if [ -f /etc/os-release ]; then  # For systems using /etc/os-release
  ID=$(grep -oP '^ID=.*' /etc/os-release | cut -d= -f2)
  if [[ "$ID" == "ubuntu" || "$ID" == "debian" ]]; then
    sudo apt-get update
    sudo apt-get install -y curl wget libunwind8 libicu60 libgpm-dev
  elif [[ "$ID" == "centos" || "$ID" == "redhat" || "$ID" == "fedora" || "$ID" == "rhel" ]]; then
    sudo yum install -y curl wget libunwind libicu gpm
  fi
else  # Handle other distributions (add checks as needed)
  echo "Warning: Distribution detection failed. You might need to install dependencies manually."
fi

# Download .NET 5 installer
curl -sSL "$DOTNET_URL" | grep -iE 'download\.linux-x64\.tar\.gz' | cut -d '"' -f2 | wget -i - -O dotnet.installer.tar.gz

# Verify GPG signature (optional, recommended)
# Download the signature file (replace URL if needed)
# wget https://dotnet.microsoft.com/download/dotnet/5.0/dotnet-sdk-5.0.17-linux-x64.release.gpg
# Verify the signature using your distribution's GPG tool (e.g., `gpg --verify dotnet-sdk-5.0.17-linux-x64.release.gpg dotnet.installer.tar.gz`)

# Extract the installer
tar -xzf dotnet.installer.tar.gz

# Install .NET 5
sudo ./dotnet-install.sh -c LTS -i "$DOTNET_INSTALL_DIR"

# Clean up temporary files
rm -rf dotnet.installer.tar.gz dotnet-install.sh

# Update environment variables (modify path if needed)
echo "export PATH=$PATH:$DOTNET_INSTALL_DIR" >> ~/.bashrc

# Reload your shell configuration (or log out/in)
source ~/.bashrc

# Verify installation
dotnet --info

echo ".NET 5 (LTS) installation complete."
