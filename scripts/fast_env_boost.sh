#!/usr/bin/env bash
# ------------------------------------------------------------
# Fast Environment Boost for Zero-Code Workspace
# ------------------------------------------------------------
# يجمع أفضل الممارسات لتسريع بيئة التطوير في خطوة واحدة.
# يتطلّب صلاحيات sudo لتثبيت الحزم وإنشاء RAM-disk.
# ------------------------------------------------------------
# الاستخدام:
#   chmod +x scripts/fast_env_boost.sh
#   ./scripts/fast_env_boost.sh
# ------------------------------------------------------------
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

## 1) تثبيت الحزم الأساس (PHP, Composer, Node, Docker)
sudo apt-get update -y
sudo apt-get install -y php-cli composer php-opcache
# Enable OPcache for CLI if not already
if ! php -i | grep -q "opcache.enable_cli => On"; then
  PHP_INI_DIR=$(php -r 'echo PHP_CONFIG_FILE_SCAN_DIR;')
  echo 'opcache.enable_cli=1' | sudo tee "$PHP_INI_DIR/99-opcache-cli.ini" >/dev/null
  echo "[+] Enabled opcache.enable_cli=1"
fi

## 2) إنشاء RAM-disk للكاش (1 جيجابايت)
RAMDISK=/mnt/ramdisk
if ! mountpoint -q "$RAMDISK"; then
  sudo mkdir -p "$RAMDISK"
  sudo mount -t tmpfs -o size=1G tmpfs "$RAMDISK"
fi
export COMPOSER_CACHE_DIR="$RAMDISK/composer"
mkdir -p "$COMPOSER_CACHE_DIR"

echo "[+] Composer cache directory set in RAM-disk"

# Skipping docker compose startup as per policy (no containers).

## 4) تثبيت اعتمادات PHP + JS إن لم تكن موجودة
if [[ -f code/zero-code/composer.json ]]; then
  pushd code/zero-code >/dev/null
  composer install --no-interaction --prefer-dist --no-progress --optimize-autoloader --no-dev
  popd >/dev/null
fi

# Skipping Node/npm operations as per policy.

## 5) توليد Makefile إن لم يكن موجوداً (اختصارات)
if [[ ! -f Makefile ]]; then
cat > Makefile <<'MK'
install:
	composer install --no-interaction --prefer-dist --no-progress
	npm ci --prefer-offline --no-audit --progress=false

gen:
	php code/zero-code/bin/zerocode schema.json

test:
	vendor/bin/pest --parallel || vendor/bin/phpunit --colors

up:
	docker compose up -d --build || docker-compose up -d --build
MK
  echo "[+] Makefile created with handy shortcuts"
fi

## 6) تشغيل اختبارات متوازية إن وُجدت
if [[ -f vendor/bin/pest ]]; then
  vendor/bin/pest --parallel || true
fi

echo -e "\n[✓] Fast environment boost completed. Happy coding!"