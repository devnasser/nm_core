#!/usr/bin/env bash
# ------------------------------------------------------------
# productivity_pack.sh – Apply extra productivity boosters
# ------------------------------------------------------------
# 1. Installs helpful CLI tools (if missing)
# 2. Creates git pre-commit hook to lint PHP
# 3. Provides template system & generator script
# ------------------------------------------------------------
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

## 1) Install small CLI helpers (requires sudo) – skip if not available
if command -v sudo >/dev/null 2>&1; then
  sudo apt-get update -qq
  sudo apt-get install -y inotify-tools htop >/dev/null 2>&1 || true
fi

## 2) Git pre-commit hook for PHP syntax check
HOOK_FILE=".git/hooks/pre-commit"
if [[ ! -f $HOOK_FILE ]]; then
  cat > "$HOOK_FILE" <<'HOCK'
#!/usr/bin/env bash
files=$(git diff --cached --name-only --diff-filter=ACM | grep -E '\.php$' || true)
if [[ -n "$files" ]]; then
  for f in $files; do
    php -l "$f" >/dev/null || {
      echo "[pre-commit] Syntax error in $f" >&2; exit 1;
    }
  done
fi
exit 0
HOCK
  chmod +x "$HOOK_FILE"
  echo "[+] Git pre-commit hook added (PHP lint)."
fi

## 3) Templates library
TEMPLATE_DIR="templates"
mkdir -p "$TEMPLATE_DIR"
if [[ ! -f "$TEMPLATE_DIR/blog.json" ]]; then
cat > "$TEMPLATE_DIR/blog.json" <<'JSON'
{
  "tables": [
    { "name": "posts", "columns": { "id": "int", "title": "string", "body": "text" } },
    { "name": "comments", "columns": { "id": "int", "post_id": "int", "content": "text" } }
  ]
}
JSON
  echo "[+] Added sample template: blog.json"
fi

## 4) new_project.sh generator
GEN_SCRIPT="scripts/new_project.sh"
if [[ ! -f $GEN_SCRIPT ]]; then
cat > "$GEN_SCRIPT" <<'GEN'
#!/usr/bin/env bash
# Usage: ./scripts/new_project.sh <template-name> <output-schema.json>
set -euo pipefail
TEMPLATE=$1
OUT=$2
cp "templates/${TEMPLATE}.json" "$OUT"
echo "[+] Copied template to $OUT – edit as needed then run make gen"
GEN
  chmod +x "$GEN_SCRIPT"
  echo "[+] new_project.sh created"
fi

echo "\n✅ Productivity pack applied."
echo "- Use ./scripts/new_project.sh blog schema.json to start a new project."
echo "- Git pre-commit hook enforces PHP syntax checks."