#!/usr/bin/env bash
# ------------------------------------------------------------
# ultimate_speed.sh – Apply additional hyper-speed tweaks
# ------------------------------------------------------------
# 1. Creates preload.php & enables opcache.preload (requires sudo)
# 2. Starts background inotify watcher to auto-regenerate on schema/rules change
# 3. Configures global Composer artifact cache (optional path param)
# 4. Installs Pest parallel & coverage stub, adds Make target
# 5. Adds Git post-merge hook to auto-build zerocode.phar
# ------------------------------------------------------------
set -euo pipefail
LOG=/workspace/logs/ultimate_speed.log
mkdir -p /workspace/logs
exec > >(tee -a "$LOG") 2>&1
trap 'echo "[!] Exited with status $? line $LINENO"' ERR

cd /workspace

PHP_VER=$(php -r 'echo PHP_MAJOR_VERSION.".".PHP_MINOR_VERSION;')
INI_DIR="/etc/php/${PHP_VER}/cli/conf.d"
PRELOAD_FILE=/workspace/preload.php

# 1) Preload setup
if [[ ! -f $PRELOAD_FILE ]]; then
  echo "<?php foreach (glob(__DIR__.'/code/zero-code/src/*.php') as \$f) opcache_compile_file(\$f);" > $PRELOAD_FILE
  echo "[+] preload.php created."
fi
if [[ $EUID -eq 0 ]]; then
  echo "opcache.preload=$PRELOAD_FILE" | tee $INI_DIR/99-preload.ini >/dev/null
  echo "[✓] opcache.preload enabled (CLI)."
else
  echo "[!] Run as root to enable opcache.preload in php.ini" >&2
fi

# 2) inotify watcher (runs only if inotify-tools present)
if command -v inotifywait >/dev/null 2>&1; then
  WATCH_SCRIPT=/workspace/scripts/watch_regen.sh
  cat > $WATCH_SCRIPT <<'SH'
#!/usr/bin/env bash
while inotifywait -e close_write schema.json rules.json 2>/dev/null; do
  php /workspace/zerocode.phar schema.json && echo "[watch] regenerated $(date)" >> /workspace/logs/watch.log
done
SH
  chmod +x $WATCH_SCRIPT
  pkill -f watch_regen.sh 2>/dev/null || true
  nohup bash $WATCH_SCRIPT >/dev/null 2>&1 &
  echo "[+] inotify auto-regen watcher started (background)."
else
  echo "[!] inotifywait not found – watcher skipped."
fi

# 3) Composer artifact cache directory (optional)
CACHE_DIR=/mnt/ramdisk/composer-cache
mkdir -p $CACHE_DIR
composer config --global cache-dir $CACHE_DIR || true
echo "[+] Composer cache set to $CACHE_DIR"

# 4) Install Pest parallel + coverage stub if not present
if ! composer show --working-dir=code/zero-code pestphp/pest-parallel >/dev/null 2>&1; then
  composer require --dev --working-dir=code/zero-code pestphp/pest-parallel jetbrains/phpstorm-coverage-stub --no-interaction --no-progress
  echo "[+] Pest parallel & coverage stub installed."
fi
# Add Make target if absent
if ! grep -q '^coverage:' Makefile 2>/dev/null; then
  echo -e '\ncoverage:\n\tvendor/bin/pest --parallel --coverage --min=80' >> Makefile
  echo "[+] coverage target added to Makefile."
fi

# 5) Git post-merge hook for PHAR rebuild
HOOK=.git/hooks/post-merge
if [[ ! -f $HOOK ]]; then
  cat > $HOOK <<'H'
#!/usr/bin/env bash
if command -v box >/dev/null 2>&1; then
  box compile --working-dir=code/zero-code -q || echo "[post-merge] Box compile failed." >&2
fi
H
  chmod +x $HOOK
  echo "[+] Git post-merge hook added."
fi

echo "\n✨ Ultimate speed tweaks applied. Log: $LOG"