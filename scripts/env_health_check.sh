#!/usr/bin/env bash
# ------------------------------------------------------------
# env_health_check.sh – Quick report of Zero-Code workspace state
# ------------------------------------------------------------
set -euo pipefail
printf "\n==== Zero-Code Environment Health Check ===="

printf "\n[1] PHP Version\n" && php -v | head -n1

printf "\n[2] Composer Version\n" && composer --version || echo "Composer not found"

printf "\n[3] OPcache CLI Status\n"
php -d detect_unicode=0 -r 'echo ini_get("opcache.enable_cli")?"Enabled":"Disabled"; echo PHP_EOL;'

printf "\n[4] RAM-disk Mounts (/mnt/ramdisk)\n"
if mountpoint -q /mnt/ramdisk; then
  mount | grep /mnt/ramdisk
  df -h /mnt/ramdisk | tail -1
else
  echo "[!] /mnt/ramdisk not mounted"
fi

printf "\n[5] Composer Cache Dir\n" && echo ${COMPOSER_CACHE_DIR:-"Not set"}

printf "\n[6] Repo Size (files tracked)\n" && du -sh --exclude=.git .

printf "\n[7] Untracked/Modified Files\n" && git -C /workspace status --short

printf "\n==== End of Report ===="