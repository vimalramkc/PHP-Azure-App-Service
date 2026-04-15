#!/usr/bin/env bash
set -x

echo "===== eG APM Setup Starting ====="

# -------------------------------
# CONFIG
# -------------------------------
DOWNLOAD_URL="https://github.com/vimalramkc/eg-apm-package/releases/download/v1.1/eg-php-btm.tar.gz"
INSTALL_DIR="/home/site/wwwroot/egbtm"
INI_FILE="/home/site/wwwroot/99-egurkha.ini"

# -------------------------------
# CLEAN ALL APM CONFIGS (IMPORTANT)
# -------------------------------
echo "Cleaning existing APM configs..."

rm -f /usr/local/etc/php/conf.d/*ddtrace*
rm -f /usr/local/etc/php/conf.d/*datadog*
rm -f /usr/local/etc/php/conf.d/*appdynamics*
rm -f /usr/local/etc/php/conf.d/*eg*
rm -f /usr/local/etc/php/conf.d/*apm*
rm -f /home/site/wwwroot/*.ini

# -------------------------------
# PREPARE DIRECTORY
# -------------------------------
mkdir -p $INSTALL_DIR
cd $INSTALL_DIR

# -------------------------------
# DOWNLOAD
# -------------------------------
rm -f eg-php-btm.tar.gz

echo "Downloading eG PHP BTM package..."
curl -L --fail -o eg-php-btm.tar.gz $DOWNLOAD_URL || { echo "Download failed ❌"; exit 1; }

# -------------------------------
# EXTRACT
# -------------------------------
echo "Extracting package..."
tar -xzf eg-php-btm.tar.gz || { echo "Extraction failed ❌"; exit 1; }

# -------------------------------
# DETECT PHP VERSION
# -------------------------------
PHP_VERSION=$(php -r "echo PHP_MAJOR_VERSION.'.'.PHP_MINOR_VERSION;")
echo "Detected PHP Version: $PHP_VERSION"

# -------------------------------
# SELECT CORRECT .SO
# -------------------------------
SO_FILE="$INSTALL_DIR/debian/eG_phpBTM_${PHP_VERSION}.so"

if [ ! -f "$SO_FILE" ]; then
    echo "No matching .so found for PHP $PHP_VERSION ❌"
    exit 1
fi

echo "Using SO file: $SO_FILE"

# -------------------------------
# CREATE CLEAN INI
# -------------------------------
echo "Creating INI file..."
echo "extension=$SO_FILE" > $INI_FILE

# -------------------------------
# FORCE ONLY THIS INI
# -------------------------------
echo "Copying INI to PHP conf.d..."
cp $INI_FILE /usr/local/etc/php/conf.d/99-egurkha.ini
# -------------------------------
# VERIFY
# -------------------------------
echo "Verifying extension..."
php -m | grep -i eg

# -------------------------------
# DONE
# -------------------------------
echo "===== eG APM Setup Completed ====="

exec "$@"
