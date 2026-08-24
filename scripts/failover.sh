#!/usr/bin/env bash
set -euo pipefail

: "${CONFIRM_FAILOVER:=}"
if [[ "$CONFIRM_FAILOVER" != "FAILOVER-SECONDARY" ]]; then
  echo "Refusing failover. Set CONFIRM_FAILOVER=FAILOVER-SECONDARY explicitly." >&2
  exit 2
fi

WORK_DIR="${DR_WORK_DIR:-.dr-work}"
REPORT="$WORK_DIR/failover.json"
mkdir -p "$WORK_DIR"

python - "$REPORT" <<'PY'
import json, sys
from datetime import datetime, timezone
path = sys.argv[1]
with open(path, 'w', encoding='utf-8') as fh:
    json.dump({
        'status': 'FAILOVER_EXECUTED',
        'target': 'secondary-simulated',
        'executed_at': datetime.now(timezone.utc).isoformat()
    }, fh, indent=2)
PY

cat "$REPORT"
