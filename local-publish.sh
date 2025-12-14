#!/bin/bash
set -e

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
