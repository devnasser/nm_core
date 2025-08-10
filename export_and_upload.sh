#!/usr/bin/env bash
#############################################################################
# export_and_upload.sh  —  تسليم المحاور الخمسة عشر إلى مركز ai_megred_learn
#############################################################################
BC_ID="bc-c6ad5e89-6078-478a-bc8f-9a0a9b2eaf07"  # ← معرف القائد
MODEL_DIR="$HOME/my_model_dir"    # ← مسار ملفات النموذج المحلية
REMOTE=""                         # ← user@HOST (إن احتجت rsync عبر SSH)

set -euo pipefail
TMP=$(mktemp -d)

echo "[*] نسخ المحاور إلى مجلد مؤقت …"
cp -v "$MODEL_DIR"/{weights.bin,config.json,tokenizer.json,io_schema.json,train_data_info.txt,hyperparams.json,fine_tune.sh,requirements.txt,baseline_metrics.txt,LICENSE.txt,README.md,safety.md,checkpoint.ckpt,postprocess.py,CHANGELOG.md} "$TMP/"

(cd "$TMP" && sha256sum * > manifest.sha256)

ARCHIVE="${BC_ID}.tar.zst"
echo "[*] ضغط الأرشيف بـ zstd -19 -T0 …"
tar -I 'zstd -19 -T0' -cf "$ARCHIVE" -C "$TMP" .

DEST="/workspace/ai_megred_learn/shard/$ARCHIVE"
if [[ -z "$REMOTE" ]]; then
  echo "[*] نسخ محلي إلى $DEST …"
  mkdir -p /workspace/ai_megred_learn/shard
  cp -v "$ARCHIVE" "$DEST"
else
  echo "[*] رفع عبر rsync إلى $REMOTE …"
  rsync -avP --compress-level=9 "$ARCHIVE" "$REMOTE:$DEST"
fi

echo "[✓] تم الرفع. سيُعالج النظام الملف خلال ثوانٍ."

###############################################################################
# نهاية الملف
###############################################################################
