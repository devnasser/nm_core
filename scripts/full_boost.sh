#!/usr/bin/env bash
# ------------------------------------------------------------
# full_boost.sh – One-stop performance booster for Zero-Code
# ------------------------------------------------------------
# • Configures OPcache (file_cache + JIT) on RAM-disk
# • Ensures latest Box v4 is installed, compiles zerocode.phar
# • Adds nightly composer audit cronjob
# • Logs every action to /workspace/logs/full_boost.log (success OR failure)
# ------------------------------------------------------------
set -euo pipefail

# ---------- Logging setup ----------
LOG_DIR="/workspace/logs"
LOG_FILE="$LOG_DIR/full_boost.log"
mkdir -p "$LOG_DIR"
exec > >(tee -a "$LOG_FILE") 2>&1
trap 'echo "[!] Script exited with status $? at line $LINENO"' ERR

echo "=== Zero-Code Full Boost $(date '+%Y-%m-%d %H:%M:%S') ==="

# ---------- Root check ----------
if [[ $EUID -ne 0 ]]; then
  echo "[!] Please run this script with sudo or as root." >&2
  exit 1
fi

echo "[+] Running as root…"

cd /workspace  # Ensure working directory

# ---------- RAM-disk for OPcache & Composer cache ----------
RAMDISK=/mnt/ramdisk
mkdir -p "$RAMDISK/opcache" || true

# ---------- OPcache configuration ----------
PHP_VER="$(php -r 'echo PHP_MAJOR_VERSION.".".PHP_MINOR_VERSION;')"
INI_DIR="/etc/php/${PHP_VER}/cli/conf.d"

echo "[+] Configuring OPcache file_cache + JIT …"
cat > "$INI_DIR/99-opcache-file.ini" <<INI
opcache.file_cache=$RAMDISK/opcache
opcache.file_cache_only=0
INI

cat > "$INI_DIR/99-opcache-jit.ini" <<INI
opcache.jit_buffer_size=64M
opcache.jit=tracing
INI

echo "[✓] OPcache configured (file_cache on RAM-disk, JIT tracing)."

# ---------- Composer cache on RAM-disk ----------
export COMPOSER_CACHE_DIR="$RAMDISK/composer-cache"
mkdir -p "$COMPOSER_CACHE_DIR"

echo "[+] Composer cache dir set to $COMPOSER_CACHE_DIR"

# ---------- Install/upgrade Box CLI ----------
BOX_HOME=$(composer global config home 2>/dev/null || echo "$HOME/.config/composer")
BOX_BIN="$BOX_HOME/vendor/bin/box"

# Ensure composer global bin path in PATH
export PATH="$BOX_HOME/vendor/bin:$PATH"

# ensure curl available
apt-get update -qq && apt-get install -y curl >/dev/null 2>&1 || true

# Attempt composer global require box; fallback to direct download if slow
BOX_READY=false
{
  timeout 120 composer global require humbug/box:^4 --no-interaction --no-progress && BOX_READY=true
} || echo "[!] Composer install of Box timed out or failed, falling back to direct download."

if [[ "$BOX_READY" == false ]]; then
  BOX_BIN=/usr/local/bin/box
  if [[ ! -f $BOX_BIN ]]; then
    echo "[+] Downloading Box PHAR directly …"
    curl -sL https://github.com/box-project/box/releases/latest/download/box.phar -o "$BOX_BIN" \
      && chmod +x "$BOX_BIN" && echo "[✓] Box downloaded to $BOX_BIN"
  fi
  export PATH="/usr/local/bin:$PATH"
fi

if ! command -v box >/dev/null 2>&1; then
  echo "[!] Box installation still missing. Aborting PHAR build."; PHAR_SKIP=1
else
  echo "[✓] Box $(box --version) ready."
fi

# Skip PHAR build if box missing
if [[ ${PHAR_SKIP:-0} -eq 0 ]]; then

  # ---------- Create box.json in source directory ----------
  SRC_DIR="code/zero_code"
  BOX_JSON="$SRC_DIR/box.json"
  if [[ ! -f "$BOX_JSON" ]]; then
    cat > "$BOX_JSON" <<JSON
{
  "output": "/workspace/zerocode.phar",
  "chmod": "0755",
  "files": [
    "src/*",
    "bin/zerocode"
  ]
}
JSON
    echo "[+] box.json created in $SRC_DIR"
  fi
  # ---------- Compile PHAR ----------
  if box compile --working-dir="$SRC_DIR" >/dev/null; then
    echo "[✓] zerocode.phar built at /workspace/zerocode.phar"
  else
    echo "[!] Box compilation failed. zerocode.phar NOT created."
  fi

  # ---------- Nightly composer audit cron job ----------
  CRON_JOB="30 0 * * * cd /workspace && COMPOSER_CACHE_DIR=$COMPOSER_CACHE_DIR composer audit --format=json > $LOG_DIR/composer_audit.json 2>&1"
  (crontab -l 2>/dev/null | grep -Fv 'composer audit' ; echo "$CRON_JOB") | crontab -

  echo "[✓] Nightly composer audit cronjob installed."
fi

echo "=== Full boost completed ==="