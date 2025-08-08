#!/usr/bin/env bash
# ------------------------------------------------------------
# extra_speed_boost.sh – System-wide micro-tuning for Zero-Code
# ------------------------------------------------------------
# • Enables OPcache file_cache + JIT targeting the RAM-disk
# • Builds zerocode.phar via humbug/box for ultra-fast execution
# • Adds nightly composer audit cronjob (00:30)
# ------------------------------------------------------------
# --------------------------------- Logging ---------------------------------
# ensure all output (success or error) is captured
set -euo pipefail
LOG_FILE=/workspace/logs/extra_boost.log
mkdir -p /workspace/logs
exec > >(tee -a "$LOG_FILE") 2>&1

# ---------------------------------------------------------------------------

cd "$(dirname "$0")/.."   # /workspace root

PHP_VER="$(php -r 'echo PHP_MAJOR_VERSION.".".PHP_MINOR_VERSION;')"
INI_DIR="/etc/php/${PHP_VER}/cli/conf.d"

if [[ $EUID -ne 0 ]]; then
  echo "[!] Please run this script with sudo or as root." >&2
  exit 1
fi

# 1) Enable OPcache file cache and JIT
mkdir -p /mnt/ramdisk/opcache || true
cat > "${INI_DIR}/99-opcache-file.ini" <<INI
opcache.file_cache=/mnt/ramdisk/opcache
opcache.file_cache_only=0
INI

cat > "${INI_DIR}/99-opcache-jit.ini" <<INI
opcache.jit_buffer_size=64M
opcache.jit=tracing
INI

echo "[+] OPcache file_cache & JIT configured."

# 2) Install Box & build PHAR
if ! composer global show humbug/box 2>/dev/null >/dev/null; then
  composer global require --optimize-autoloader humbug/box --no-interaction --no-progress
fi
export PATH="$HOME/.composer/vendor/bin:$HOME/.config/composer/vendor/bin:$PATH"
box compile --working-dir=code/zero-code -o /workspace/zerocode.phar
chmod +x zerocode.phar

echo "[+] zerocode.phar built at /workspace/zerocode.phar"

# 3) Nightly composer audit cron job
CRON_LINE="30 0 * * * cd /workspace && COMPOSER_CACHE_DIR=/mnt/ramdisk/composer-cache composer audit --format=json > logs/composer_audit.json 2>&1"
(crontab -l 2>/dev/null | grep -Fv "composer audit"; echo "$CRON_LINE") | crontab -

echo "[+] Nightly composer audit task added to crontab."

echo -e "\n✅ Extra speed boost applied. Use: php zerocode.phar schema.json"