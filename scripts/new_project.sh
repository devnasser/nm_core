#!/usr/bin/env bash
# Usage: ./scripts/new_project.sh <template-name> <output-schema.json>
set -euo pipefail
TEMPLATE=$1
OUT=$2
cp "templates/${TEMPLATE}.json" "$OUT"
echo "[+] Copied template to $OUT – edit as needed then run make gen"
