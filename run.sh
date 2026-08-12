#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT"

ENGINE=""
for candidate in \
  "$ROOT/../game/bazel-bin/game" \
  "$ROOT/../game/bazel-bin/game.exe" \
  "$ROOT/../game/game" \
  "$ROOT/../game/game.exe"
do
  if [[ -f "$candidate" ]]; then
    ENGINE="$candidate"
    break
  fi
done

if [[ -z "$ENGINE" ]]; then
  echo "Engine binary not found. Looked for:"
  echo "  ../game/bazel-bin/game[.exe]"
  echo "  ../game/game[.exe]"
  exit 1
fi

if [[ ! -f "$ROOT/game.json" ]]; then
  echo "Missing boot config: $ROOT/game.json"
  exit 1
fi

echo "Starting Galagus with $ENGINE"
exec "$ENGINE" "$ROOT/game.json"
