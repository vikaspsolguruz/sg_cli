#!/bin/bash

# Get the absolute path of the script's directory (i.e., project root)
SG_CLI_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Activating sg_cli from: $SG_CLI_PATH"

flutter clean
flutter pub upgrade
# Activate the CLI globally
flutter pub global activate --source path "$SG_CLI_PATH"

# Apply changes
# shellcheck disable=SC1090
source ~/.zshrc

# Test the installation
echo "Testing sg_cli..."
if sg --help >/dev/null 2>&1; then
echo "✅  sg_cli is successfully activated and ready to use!"
else
echo "❌  Failed to run sg. Check installation."
fi
