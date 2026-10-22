#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

NODE_VERSION="$(<.nvmrc)"
echo "[update-dev-environment] target Node.js version: ${NODE_VERSION}"
if command -v node >/dev/null 2>&1; then
  ACTIVE_NODE_VERSION="$(node -v)"
  echo "[update-dev-environment] current node: ${ACTIVE_NODE_VERSION}"
fi

if command -v nvm >/dev/null 2>&1; then
  nvm install "${NODE_VERSION}"
  nvm use "${NODE_VERSION}"
else
  echo "[update-dev-environment] nvm not found. Please install Node.js ${NODE_VERSION} using a version manager."
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
