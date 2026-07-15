#!/bin/bash
set -e

# スクリプトのあるディレクトリへ移動（どこから実行しても動作するように）
cd "$(dirname "$0")"

# .nvmrc に従って Node.js バージョンを切り替え
if command -v nvm &>/dev/null; then
  nvm use
elif [ -f "$NVM_DIR/nvm.sh" ]; then
  source "$NVM_DIR/nvm.sh"
  nvm use
fi

# 古いパッケージファイルの削除
rm -f youtube-chat-*.tgz

# 依存関係のインストール
npm install

# ビルド
echo "Building..."
npm run build

# テスト
echo "Testing..."
npm test

# パッケージの作成
echo "Packing..."
npm pack

# 完了メッセージと利用方法の表示
PACKAGE_FILE=$(ls youtube-chat-*.tgz | head -n 1)
echo ""
echo "✅ Package created successfully: $PACKAGE_FILE"
echo ""
echo "To use this package in another local project, run:"
echo "npm install $(pwd)/$PACKAGE_FILE"
