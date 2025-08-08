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
sudo apt-get install -y php-cli composer nodejs npm docker.io docker-compose-plugin || sudo apt-get install -y docker-compose

## 2) إنشاء RAM-disk للكاش (1 جيجابايت)
RAMDISK=/mnt/ramdisk
if ! mountpoint -q "$RAMDISK"; then
  sudo mkdir -p "$RAMDISK"
  sudo mount -t tmpfs -o size=1G tmpfs "$RAMDISK"
fi
export COMPOSER_CACHE_DIR="$RAMDISK/composer"
export NPM_CONFIG_CACHE="$RAMDISK/npm"
mkdir -p "$COMPOSER_CACHE_DIR" "$NPM_CONFIG_CACHE"

echo "[+] Composer & NPM cache directories set in RAM-disk"

## 3) تشغيل حاويات docker-compose إن وُجدت
if [[ -f docker-compose.yml || -f docker-compose.yaml ]]; then
  if command -v "docker" >/dev/null 2>&1; then
    COMPOSE_CMD="docker compose"
    if ! $COMPOSE_CMD version >/dev/null 2>&1; then
      COMPOSE_CMD="docker-compose"
    fi
    echo "[+] Starting containers via $COMPOSE_CMD …"
    $COMPOSE_CMD pull --quiet || true
    $COMPOSE_CMD up -d --build
  fi
fi

## 4) تثبيت اعتمادات PHP + JS إن لم تكن موجودة
if [[ -f code/zero-code/composer.json ]]; then
  pushd code/zero-code >/dev/null
  composer install --no-interaction --prefer-dist --no-progress
  popd >/dev/null
fi

if [[ -f package.json ]]; then
  npm ci --prefer-offline --no-audit --progress=false
fi

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