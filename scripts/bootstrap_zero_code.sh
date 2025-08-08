#!/usr/bin/env bash
# ---------------------------------------------
# Zero-Code Platform: One-Shot Bootstrap Script
# ---------------------------------------------
# هذا السكربت يهيّئ بيئة التطوير كاملة ويولّد مثالاً جاهزاً
# للتشغيل باستخدام محرّك Zero-Code.
# 
# التنفيذ:
#   chmod +x scripts/bootstrap_zero_code.sh
#   ./scripts/bootstrap_zero_code.sh
# ---------------------------------------------
set -euo pipefail

# 1) تحديث باقات النظام وتثبيت المتطلّبات الأساسيّة
sudo apt-get update -y
sudo apt-get install -y php-cli composer docker.io docker-compose-plugin

# 2) تشغيل حاويات التطوير (إن وُجد ملف docker-compose.yml)
if [[ -f "docker-compose.yml" || -f "docker-compose.yaml" ]]; then
  echo "[+] Building & starting local containers…"
  docker compose pull --quiet || true
  docker compose up -d --build
fi

# 3) تثبيت تبعيات Composer لمحرّك Zero-Code
pushd code/zero-code >/dev/null
if [[ ! -f vendor/autoload.php ]]; then
  echo "[+] Installing PHP dependencies (Composer)…"
  composer install --no-interaction --no-progress --prefer-dist
fi

# 4) تحضير مخطّط مثال (demo_schema.json)
cat > demo_schema.json <<'JSON'
{
  "tables": [
    {
      "name": "products",
      "columns": {
        "id": "int",
        "name": "string",
        "price": "int",
        "created_at": "datetime"
      }
    }
  ]
}
JSON

# 5) توليد النظام التجريبي
php bin/zerocode demo_schema.json

# 6) عرض المخرجات
echo -e "\n[✓] Generation done. Created files:"
ls -1 generated.sql *Controller.php
popd >/dev/null

echo -e "\n💡 البيئة جاهزة! يمكنك تعديل demo_schema.json وتكرار الخطوة 5 للتوليد السريع."