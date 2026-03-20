# TTD 実装進捗ログ
> Claude Codeセッション復帰用リファレンス
> 最終更新: 2026/03/20

---

## プロジェクト基本情報

| 項目 | 内容 |
|------|------|
| アプリ名 | TTD（Tomorrow To Do） |
| 概要 | 前日夜に翌日の準備物・タスク・予定をリスト化し、翌朝確認するiOSアプリ |
| プロジェクトパス | `/Users/sora1/CODE/TTD/` |
| Xcodeプロジェクト | `TTD/TTD.xcodeproj` |
| GitHub | `https://github.com/SORA112117/TTD` |
| リモートURL | `https://ghp_<TOKEN>@github.com/SORA112117/TTD.git` |
| 現在のブランチ | `main` |
| 最小iOS | iOS 17.0+ |
| 言語 | Swift 5.9+ / SwiftUI / SwiftData |
| アーキテクチャ | MVVM |

---

## 現在のファイル構成

```
TTD/
├── DESIGN.md                      # アプリ設計ドキュメント（機能・技術スタック）
├── UI_DESIGN.md                   # UI詳細設計（画面・コンポーネント・デザイントークン）
├── VIBE_CODING_GUIDE.md           # Claude Code × Vibe Coding 手法リファレンス
├── COMMANDS.md                    # 使用コマンドログ
├── PROGRESS_LOG.md                # 本ファイル（実装進捗・セッション復帰用）
│
└── TTD/                           # Xcodeプロジェクト本体
    ├── TTDApp.swift               # エントリポイント（SwiftDataコンテナ設定済み）
    ├── Models/
    │   ├── TaskCategory.swift     # カテゴリ定義（持ち物/やること/予定/準備チェック）
    │   ├── TaskItem.swift         # タスクのSwiftDataモデル（@Model）
    │   └── TaskTemplate.swift     # テンプレートのSwiftDataモデル（@Model）
    ├── ViewModels/
    │   ├── HomeViewModel.swift    # ホーム画面ロジック（完了検知・全完了演出）
    │   └── SettingsViewModel.swift # 設定画面ロジック（通知・UserDefaults）
    ├── Views/
    │   ├── RootTabView.swift      # 3タブ構成のルートナビゲーション
    │   ├── Home/
    │   │   ├── HomeView.swift          # メイン画面（今日の残 + 明日のリスト）
    │   │   └── CategorySectionView.swift # カテゴリ別セクション
    │   ├── Template/
    │   │   └── TemplateView.swift      # テンプレート一覧・作成
    │   ├── Settings/
    │   │   └── SettingsView.swift      # 通知設定
    │   └── Components/
    │       ├── TaskRowView.swift        # タスク行UI（チェック・スワイプ削除）
    │       ├── InlineTaskInputView.swift # インライン入力フィールド
    │       └── AllDoneBannerView.swift  # 全完了バナー
    ├── Services/
    │   └── NotificationService.swift   # UNUserNotificationCenter管理
    ├── Shared/
    │   └── DesignTokens.swift          # Spacing / Radius / Animation定数
    └── Assets.xcassets/               # アイコン・カラーセット（初期状態）
```

---

## 実装フェーズ進捗

### ✅ Phase 1: MVP基盤（完了）

**実施内容:**
- MVVM全体構造の構築
- SwiftDataモデル定義（TaskItem / TaskTemplate）
- 全画面実装（Home / Template / Settings）
- 共通コンポーネント実装（TaskRow / InlineInput / AllDoneBanner）
- 通知サービス実装
- デザイントークン定義
- GitHubへのプッシュ

**既知の修正済みバグ:**
- `TaskRowView.swift`: `.strikethrough(color:)` に `ShapeStyle` を渡していた型エラー → `Color(.tertiaryLabel)` に修正（PR #1）
- `RootTabView.swift`: `#Preview` で `SwiftData` が未import → `import SwiftData` 追加（PR #2）

---

### 🔲 Phase 2: コア機能の完成（未着手）

- [ ] **ConfettiSwiftUI 導入**（SPM追加）
  - URL: `https://github.com/simibac/ConfettiSwiftUI.git`
  - バージョン: `3.0.0`
  - 追加後: `HomeView.swift` の `.confettiCannon` コメントアウトを解除（77行目付近）

- [ ] **翌日自動リセット機能**
  - アプリ起動時に「最終リセット日 ≠ 今日」なら昨日のリストを自動削除
  - `HomeViewModel.swift` に実装、UserDefaultsで最終リセット日を管理

- [ ] **ウィジェット実装**
  - Xcodeでターゲット追加: `File > New > Target > Widget Extension`
  - 名前: `TTDWidget`
  - AppGroupでSwiftDataのデータ共有
  - 小サイズ: 未完了タスク数 + 上位3件
  - ロック画面: 完了率インジケーター

---

### 🔲 Phase 3: テンプレート機能強化（未着手）

- [ ] テンプレートから明日のリストへの適用（長押しコンテキストメニュー）
- [ ] テンプレート内タスクの編集・並べ替え

---

### 🔲 Phase 4: UX磨き込み（未着手）

- [ ] **Lottie チェックアニメーション**
  - URL: `https://github.com/airbnb/lottie-spm.git`
  - バージョン: `4.6.0`
  - `TaskRowView.swift` のチェックボックスに組み込み

- [ ] Empty State（タスクが0件のカテゴリ表示）
- [ ] ダークモード全画面確認・調整

---

### 🔲 Phase 5: 品質保証（未着手）

- [ ] XCTestによる単体テスト（HomeViewModel中心）
- [ ] ビルド最終確認コマンド実行

---

## コミット履歴

| ハッシュ | 内容 | PR |
|---------|------|----|
| `a732c39` | fix: RootTabViewにSwiftDataのimportを追加 | #2（マージ済み） |
| `b706509` | fix: RootTabViewにSwiftDataのimportを追加（ブランチコミット） | — |
| `e967b7e` | fix: TaskRowViewの打ち消し線カラー型エラーを修正 | #1（マージ済み） |
| `24c6092` | fix: TaskRowViewの打ち消し線カラー型エラーを修正（ブランチコミット） | — |
| `c0ee97a` | docs: Claude Code × Vibe Coding 完全ガイドを追加 | — |
| `17e283a` | docs: コマンドログファイルを追加（COMMANDS.md） | — |
| `6c3308a` | feat: Phase 1 MVP実装 - MVVM基盤・全画面構築 | — |
| `62ab538` | Initial Commit | — |

---

## 使用したコマンド一覧

### Git操作

```bash
# リモートorigin確認
git remote -v

# リモートを追加（SSH）
git remote add origin git@github.com:SORA112117/TTD.git

# リモートURLをHTTPS+PAT形式に変更
git remote set-url origin https://<TOKEN>@github.com/SORA112117/TTD.git

# 現在の状態確認
git status

# ブランチ作成・切り替え
git checkout -b fix/ブランチ名
git checkout -b feature/ブランチ名

# mainに戻る
git checkout main

# ファイルをステージング
git add <ファイルパス>
git add -u <削除済みファイルパス>  # 削除されたファイル

# コミット（HEREDOCで複数行メッセージ）
git commit -m "$(cat <<'EOF'
type: 説明

- 詳細1
- 詳細2

🤖 Generated with [Claude Code](https://claude.ai/code)
Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"

# ブランチをプッシュ（初回・トラッキング設定）
git push -u origin ブランチ名

# プッシュ（2回目以降）
git push

# mainを最新に同期
git pull origin main

# コミット履歴確認
git log --oneline

# ブランチ一覧
git branch -a
```

### GitHub API（gh コマンドが使えない場合のcurl代替）

```bash
# PRを作成
curl -s -X POST \
  -H "Authorization: token <TOKEN>" \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/repos/SORA112117/TTD/pulls \
  -d '{
    "title": "PRタイトル",
    "body": "PR本文（\\nで改行）",
    "head": "ブランチ名",
    "base": "main"
  }' | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('html_url', d.get('message','')))"

# PRをマージ
curl -s -X PUT \
  -H "Authorization: token <TOKEN>" \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/repos/SORA112117/TTD/pulls/<PR番号>/merge \
  -d '{
    "commit_title": "コミットタイトル (#PR番号)",
    "merge_method": "merge"
  }' | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('message',''))"
```

### Xcodeビルド・テスト

```bash
# ビルド確認
xcodebuild build \
  -scheme TTD \
  -destination 'platform=iOS Simulator,name=iPhone 16 Pro'

# テスト実行
xcodebuild test \
  -scheme TTD \
  -destination 'platform=iOS Simulator,name=iPhone 16 Pro'

# エラーのみ抽出
xcodebuild build \
  -scheme TTD \
  -destination 'platform=iOS Simulator,name=iPhone 16 Pro' \
  2>&1 | grep -E "error:|warning:"

# 利用可能なシミュレーター一覧
xcrun simctl list devices available | grep iPhone
```

---

## 開発フロー（ルール）

### 各セッションの進め方

```
1. セッション開始時
   - git status で現在のブランチ・変更状態を確認
   - git log --oneline で最新コミットを確認
   - PROGRESS_LOG.md（本ファイル）で現在のフェーズを確認

2. 実装・修正時
   - 必ず feature/fix ブランチを切ってから作業
   - 1タスク = 1ブランチ = 1PR
   - 変更後はビルド確認を実施

3. PR フロー
   - git checkout -b fix/or/feature/ブランチ名
   - 実装・コミット
   - git push -u origin ブランチ名
   - GitHub APIでPR作成
   - AIがコードレビュー
   - 承認 → GitHub APIでマージ
   - git checkout main && git pull origin main

4. セッション終了時
   - PROGRESS_LOG.md を更新
   - 動作している状態で git commit & git push
```

### コミットメッセージのプレフィックス

| プレフィックス | 用途 |
|--------------|------|
| `feat:` | 新機能追加 |
| `fix:` | バグ修正 |
| `refactor:` | リファクタリング |
| `docs:` | ドキュメント更新 |
| `test:` | テスト追加・修正 |
| `chore:` | ビルド設定・依存関係など |

---

## 設計ドキュメント参照先

| ドキュメント | 内容 |
|------------|------|
| `DESIGN.md` | アプリ概要・機能要件・技術スタック・開発フェーズ |
| `UI_DESIGN.md` | 画面設計・コンポーネント仕様・カラー・タイポグラフィ・アニメーション |
| `VIBE_CODING_GUIDE.md` | Claude Code × Vibe Coding 手法・プロンプト戦略・失敗対策 |
| `COMMANDS.md` | よく使うコマンド集（簡易版） |

---

## 次のセッションで最初にやること

```
1. git status と git log --oneline を実行して状態確認
2. Xcodeでビルドして残りのエラーを確認
3. エラーがあればここに貼り付けてfixブランチで1件ずつ修正
4. ビルドが通ったら Phase 2 の ConfettiSwiftUI 導入から開始
```

---

*作成: 2026/03/20*
