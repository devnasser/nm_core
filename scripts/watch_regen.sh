#!/usr/bin/env bash
while inotifywait -e close_write schema.json rules.json 2>/dev/null; do
  php /workspace/zerocode.phar schema.json && echo "[watch] regenerated $(date)" >> /workspace/logs/watch.log
done
