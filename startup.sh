#!/usr/bin/env bash

echo "===== eG APM Setup Starting ====="

# -------------------------------
# Config
# -------------------------------
DOWNLOAD_URL="https://github.com/vimalramkc/eg-apm-package/releases/download/v1.0/eGagent_linux_x64.tar.gz"
INSTALL_DIR="/home/site/wwwroot/egagent"
INI_FILE="/home/site/wwwroot/99-egurkha.ini"

# -------------------------------
# Create working directory
# -------------------------------
mkdir -p $INSTALL_DIR
cd $INSTALL_DIR

# -------------------------------
# Download only if not exists
# -------------------------------
if [ ! -f "egagent.tar.gz" ]; then
    echo "Downloading eG agent..."
    curl -L --fail -o egagent.tar.gz $DOWNLOAD_URL

    if [ $? -ne 0 ]; then
        echo "Download failed ❌"
        exit 1
    fi
else
    echo "Using existing downloaded package"
fi

# -------------------------------
# Extract only if not extracted
# -------------------------------
if [ ! -d "egurkha" ]; then
    echo "Extracting package..."
    tar -xzf egagent.tar.gz
else
    echo "Already extracted"
fi

# -------------------------------
# Detect PHP version
# -------------------------------
PHP_VERSION=$(php -r "echo PHP_MAJOR_VERSION.'.'.PHP_MINOR_VERSION;")
echo "Detected PHP Version: $PHP_VERSION"

# -------------------------------
# Find correct .so dynamically
# -------------------------------
SO_RELATIVE=$(find egurkha/lib64 -name "eG_phpBTM_${PHP_VERSION}.so" | head -n 1)

if [ -z "$SO_RELATIVE" ]; then
    echo "No matching .so found for PHP $PHP_VERSION ❌"
    exit 1
fi

FULL_SO_PATH="$INSTALL_DIR/$SO_RELATIVE"
echo "Using SO file: $FULL_SO_PATH"

# -------------------------------
# Create ini file
# -------------------------------
echo "Creating INI file..."

echo "extension=$FULL_SO_PATH" > $INI_FILE
echo "egurkha.controller.host=YOUR_MANAGER_IP" >> $INI_FILE
echo "egurkha.controller.port=7077" >> $INI_FILE

# -------------------------------
# Load custom ini directory
# -------------------------------
export PHP_INI_SCAN_DIR="/usr/local/etc/php/conf.d:/home/site/wwwroot"
echo "PHP_INI_SCAN_DIR=$PHP_INI_SCAN_DIR"

# -------------------------------
# Verify installation
# -------------------------------
echo "Verifying extension..."
php -m | grep -i eg

# -------------------------------
# Done
# -------------------------------
echo "===== eG APM Setup Completed ====="

# Start the app
exec "$@"
