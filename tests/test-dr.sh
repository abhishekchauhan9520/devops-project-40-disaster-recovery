#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

bash -n scripts/run-dr-test.sh
bash -n scripts/failover.sh

output="$(./scripts/run-dr-test.sh)"
grep -q 'RECOVERY_READY' <<<"$output"
grep -q 'backup_verified' <<<"$output"
grep -q 'restore_verified' <<<"$output"

set +e
./scripts/failover.sh >/tmp/dr-failover.out 2>&1
rc=$?
set -e
[[ $rc -eq 2 ]]
grep -q 'Refusing failover' /tmp/dr-failover.out

CONFIRM_FAILOVER=FAILOVER-SECONDARY DR_WORK_DIR=.dr-work-test ./scripts/failover.sh >/tmp/dr-failover-ok.out
grep -q 'FAILOVER_EXECUTED' /tmp/dr-failover-ok.out

echo 'Project 40 DR tests passed.'
