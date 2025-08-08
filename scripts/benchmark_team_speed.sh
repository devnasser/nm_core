#!/usr/bin/env bash
# ------------------------------------------------------------
# benchmark_team_speed.sh – Measures Zero-Code generation time
#   for each team member's representative task.
# ------------------------------------------------------------
set -euo pipefail
cd "$(dirname "$0")/../code/zero-code"

# determine php binary
PHP_BIN=$(command -v php)

declare -A SCHEMAS=(
  [Ahmed]='{"tables":[{"name":"orders","columns":{"id":"int","total":"int"}}]}'
  [Sara]='{"tables":[{"name":"users","columns":{"id":"int","email":"string"}}]}'
  [Mohamed]='{"tables":[{"name":"posts","columns":{"id":"int","title":"string"}}]}'
  [Fatima]='{"tables":[{"name":"inventory","columns":{"id":"int","sku":"string"}}]}'
)

echo -e "\n🔬 Benchmark: Zero-Code Generation Time"
echo "----------------------------------------------"
printf "%-10s | %-10s\n" "Member" "Seconds"
echo "-----------|-----------"

for member in "Ahmed" "Sara" "Mohamed" "Fatima"; do
  schema_file="/tmp/${member,,}_schema.json"
  echo "${SCHEMAS[$member]}" > "$schema_file"
  start=$(date +%s%N)
  $PHP_BIN bin/zerocode "$schema_file" >/dev/null 2>&1
  end=$(date +%s%N)
  ms=$(( (end - start)/1000000 ))
  printf "%-10s | %-10s ms\n" "$member" "$ms"
  rm -f "$schema_file"
  # Cleanup any generated files to avoid pollution
  rm -f *Controller.php generated.sql
done
echo "----------------------------------------------"