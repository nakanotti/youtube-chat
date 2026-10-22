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
echo "依存関係のインストール..."
npm install

# 本番依存関係の脆弱性を確認（監査のみで、依存関係は変更しない）
echo "本番依存関係の脆弱性を確認..."
npm audit --omit=dev --audit-level=moderate

# ビルド
echo "ビルド..."
npm run build

# テスト
echo "テスト..."
npm test

# パッケージの作成
echo "パッケージ作成..."
npm pack

# 完了メッセージと利用方法の表示
PACKAGE_FILE=$(ls youtube-chat-*.tgz | head -n 1)
echo ""
echo "✅ Package created successfully: $PACKAGE_FILE"
echo ""
echo "別のローカルプロジェクトでこのパッケージを使用するには、以下を実行してください:"
echo "npm install $(pwd)/$PACKAGE_FILE"
