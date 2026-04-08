#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

echo "[update-dev-environment] target Node.js major: 25"
if command -v node >/dev/null 2>&1; then
  NODE_VERSION="$(node -v)"
  echo "[update-dev-environment] current node: ${NODE_VERSION}"
fi

if command -v nvm >/dev/null 2>&1; then
  nvm install 25
  nvm use 25
else
  echo "[update-dev-environment] nvm not found. Please ensure Node.js 25 is active."
fi

echo "[update-dev-environment] refreshing npm metadata"
npm --version

echo "[update-dev-environment] reinstalling dependencies from lockfile"
npm ci

echo "[update-dev-environment] running baseline checks"
npm run check-supply-chain
npm run build
npm run test
npm run lint

echo "[update-dev-environment] done"
