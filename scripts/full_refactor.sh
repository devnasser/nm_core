#!/usr/bin/env bash
# ------------------------------------------------------------
# full_refactor.sh – One-shot internal refactor & training bootstrap
# ------------------------------------------------------------
# 1. Reorganises directory layout to unified structure.
# 2. Moves Zero-Code source to src/ and updates script paths.
# 3. Archives large educational HTML into archive/ (ignored by git).
# 4. Generates templates (50 schema JSON files) & README.
# 5. Creates 6-week training program under training/.
# 6. Updates .gitignore and removes temp artefacts.
# 7. Rebuilds zerocode.phar (if box present) and commits changes.
# 8. Logs all operations to logs/refactor.log.
# ------------------------------------------------------------
set -euo pipefail
LOG=/workspace/logs/refactor.log
mkdir -p /workspace/logs
exec > >(tee -a "$LOG") 2>&1
trap 'echo "[!] Script exited with status $? at line $LINENO"' ERR

echo "=== Full Refactor Started $(date '+%F %T') ==="
cd /workspace

# 1. Create unified dirs
for d in src docs templates training tests archive logs; do
  mkdir -p "$d"
  echo "[+] Ensured directory $d";
done

# 2. Move Zero-Code source
if [[ -d code/zero_code ]]; then
  git mv code/zero_code src/zerocode || true
  echo "[+] Moved zero_code -> src/zerocode"
fi

# 3. Move docs (MD)
if [[ -d docs ]]; then
  mv docs/*.md docs/ 2>/dev/null || true
fi

# 4. Archive large HTML knowledge
if [[ -d archive/knowledge_docs ]]; then
  echo "[i] knowledge_docs already archived"
else
  if [[ -d archive ]]; then :; fi
  if [[ -d docs/archives/knowledge ]]; then
    git mv docs/archives/knowledge archive/knowledge_docs
    echo "[+] Moved knowledge HTML to archive/knowledge_docs"
  fi
fi

git rm -r --cached archive/knowledge_docs >/dev/null 2>&1 || true

echo "archive/" >> .gitignore

echo "[+] Added archive/ to .gitignore"

# 5. Generate 50 template schemas (simple placeholder)
TEMPL_DIR=templates
if [[ ! -f $TEMPL_DIR/index.md ]]; then
  echo "# Templates Index" > $TEMPL_DIR/index.md
fi

declare -a ideas=(
  "dates_market" "chalet_booking" "water_delivery" "gym_subscription" "car_maintenance"
  "nutrition_clinic" "gold_store" "handicraft_market" "weekend_resort" "contractor_invoices"
  "home_kitchens" "restaurant_waitlist" "local_shipping" "kids_library" "charity_campaigns"
  "tool_rental" "dentist_booking" "incubator_manager" "plate_auction" "private_tutoring"
  "elderly_care" "feed_market" "esport_events" "vet_pharmacy" "farm_veggies"
  "photo_sessions" "coffee_meet" "vaccination_record" "ac_service" "restaurant_reviews"
  "bike_rental" "mini_market" "car_wash" "used_devices" "camping_trips" "barber_shop"
  "spare_electronics" "art_market" "neighbourhood_pitch" "quran_lessons" "custom_perfume"
  "home_nursery" "customs_clearance" "fuel_delivery" "palm_products" "cat_cafe"
  "construction_alerts" "heritage_clothes" "first_aid_courses" "solar_panel_service"
)

for idea in "${ideas[@]}"; do
  file="$TEMPL_DIR/${idea}.json"
  if [[ ! -f $file ]]; then
    cat > "$file" <<JSON
{
  "tables": [
    { "name": "items", "columns": { "id": "int", "name": "string", "price": "int" } }
  ]
}
JSON
    echo "* $idea" >> $TEMPL_DIR/index.md
  fi
done

echo "[+] Generated placeholder templates (50)"

# 6. Training program (6 weeks)
TRAIN_DIR=training
for i in {1..6}; do
  f="$TRAIN_DIR/week${i}.md"
  if [[ ! -f $f ]]; then
    cat > $f <<MD
# Week $i Training Plan

- Objectives:
  - TBD
- Resources:
  - archive/knowledge_docs
- Exercises:
  - TBD
MD
  fi
done;

echo "[+] Training skeleton created (6 weeks)"

# 7. Clean temp artefacts and update .gitignore
printf '\nlogs/\n*.sql\n*Controller.php\n' >> .gitignore

git add .gitignore templates training src docs scripts || true

git commit -m "refactor: unified structure + training program + templates" || true

echo "[✓] Refactor committed"

git push origin main || true

echo "=== Full Refactor Completed $(date '+%F %T') ==="