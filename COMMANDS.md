# TTD プロジェクト ターミナルコマンドログ

## Git初期設定・リモート登録

```bash
# リモートリポジトリを確認
git remote -v

# リモートoriginを追加（SSH）
git remote add origin git@github.com:SORA112117/TTD.git

# リモートURLをHTTPS+PAT形式に変更
git remote set-url origin https://<TOKEN>@github.com/SORA112117/TTD.git
```

## Phase 1 MVP実装後のコミット・プッシュ

```bash
# 変更ファイルをステージング
git add DESIGN.md UI_DESIGN.md TTD/TTDApp.swift TTD/Models/ TTD/Services/ TTD/Shared/ TTD/ViewModels/ TTD/Views/

# ContentView.swift（削除済みファイル）をステージング
git add -u TTD/ContentView.swift

# コミット
git commit -m "feat: Phase 1 MVP実装 - MVVM基盤・全画面構築"

# GitHubにプッシュ（初回 -u でトラッキングブランチ設定）
git push -u origin main
```

## 開発中によく使うコマンド

```bash
# 状態確認
git status

# 差分確認
git diff

# コミット履歴
git log --oneline

# 変更を全てステージング（注意: 機密ファイルが含まれていないか確認してから使う）
git add .

# プッシュ
git push
```

## Xcodeビルド・テスト

```bash
# ビルド確認
xcodebuild build -scheme TTD -destination 'platform=iOS Simulator,name=iPhone 16 Pro'

# テスト実行
xcodebuild test -scheme TTD -destination 'platform=iOS Simulator,name=iPhone 16 Pro'

# ビルドエラーのみ抽出
xcodebuild build -scheme TTD -destination 'platform=iOS Simulator,name=iPhone 16 Pro' 2>&1 | grep -E "error:|warning:"
```

## ローカルサーバー（Web確認用）

```bash
python3 -m http.server 8000
```

---

*作成日: 2026/03/15*
