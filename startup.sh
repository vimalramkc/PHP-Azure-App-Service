#!/bin/bash

echo "========================================"
echo " eGurkha PHP BTM Azure Startup"
echo "========================================"

# -------- CONFIG --------
AGENT_PATH="/opt/egurkha"

# -------- DETECT PHP VERSION --------
PHP_MAJOR=$(php -r 'echo PHP_MAJOR_VERSION;')
PHP_MINOR=$(php -r 'echo PHP_MINOR_VERSION;')
PHP_VERSION="${PHP_MAJOR}.${PHP_MINOR}"

echo "Detected PHP version: $PHP_VERSION"

# -------- DETECT ARCH --------
if uname -m | grep -q "64"; then
    EXT_BASE="$AGENT_PATH/lib/lib64/phpBTM"
else
    EXT_BASE="$AGENT_PATH/lib/phpBTM"
fi

# -------- OS CHECK --------
if grep -qi "debian" /etc/*-release; then
    EXT_BASE="$EXT_BASE/debian"
fi

# -------- SELECT .SO --------
SO_FILE="$EXT_BASE/eG_phpBTM_${PHP_VERSION}.so"

if [ ! -f "$SO_FILE" ]; then
    echo "ERROR: .so file not found for PHP $PHP_VERSION"
    echo "Expected: $SO_FILE"
    exec /opt/startup/startup.sh
fi

echo "Using SO file: $SO_FILE"

# -------- SET AZURE SAFE INI DIRECTORY --------
INI_DIR="/home/site/wwwroot/php.d"
mkdir -p "$INI_DIR"

export PHP_INI_SCAN_DIR="$INI_DIR"

INI_FILE="$INI_DIR/99-egurkha.ini"

echo "Creating INI file at: $INI_FILE"

cat > "$INI_FILE" <<EOF
extension=$SO_FILE
egagent.configpath=$AGENT_PATH
EOF

# -------- OPTIONAL: TRY DISABLE DATADOG (best effort) --------
rm -f /etc/php/*/conf.d/*ddtrace.ini 2>/dev/null

# -------- DEBUG OUTPUT --------
echo "----------------------------------------"
echo "PHP modules after injection:"
php -m | grep -E "eG|ddtrace"
echo "----------------------------------------"
echo "Startup script completed"

# -------- IMPORTANT: START AZURE DEFAULT PROCESS --------
exec /opt/startup/startup.sh

