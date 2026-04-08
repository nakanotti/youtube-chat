#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

echo "[update-modules-safe] precheck: supply chain scan"
npm run check-supply-chain

echo "[update-modules-safe] show outdated top-level packages"
npm run check-updates || true

echo "[update-modules-safe] updating dependency ranges respecting package.json"
npm update

echo "[update-modules-safe] pin axios to safe version"
npm install axios@1.14.0

echo "[update-modules-safe] security checks"
npm run audit-security
npm run audit-signatures

echo "[update-modules-safe] validation"
npm run check-supply-chain
npm run build
npm run test
npm run lint

echo "[update-modules-safe] done"
