# Claude Code × Vibe Coding 完全ガイド
> 2025〜2026年最新手法に基づく実践リファレンス

---

## 目次

1. [Vibe Codingとは](#1-vibe-codingとは)
2. [Claude Code 固有のワークフロー](#2-claude-code-固有のワークフロー)
3. [CLAUDE.md の設計と管理](#3-claudemd-の設計と管理)
4. [Plan Mode の活用](#4-plan-mode-の活用)
5. [Spec-First 開発プロセス](#5-spec-first-開発プロセス)
6. [効果的なプロンプト戦略](#6-効果的なプロンプト戦略)
7. [上級テクニック](#7-上級テクニック)
8. [よくある失敗と対策](#8-よくある失敗と対策)
9. [モデル選択ガイド](#9-モデル選択ガイド)
10. [TTDプロジェクト適用計画](#10-TTDプロジェクト適用計画)
11. [参考資料](#11-参考資料)

---

## 1. Vibe Codingとは

### 定義

**Andrej Karpathy（元OpenAI研究者）** が2025年2月に提唱した開発スタイル。

> "There's a new kind of coding I call 'vibe coding', where you fully give in to the vibes, embrace exponentials, and forget that the code even exists."
> — Andrej Karpathy, 2025

**自然言語でAIに指示し、AIが生成したコードを信頼して受け入れる開発スタイル。**

### 2026年時点での進化

| 時期 | 解釈 |
|------|------|
| 2025年初 | 「AIに任せる」実験的アプローチ |
| 2025年中 | Spec-First・TDDとの統合 |
| 2026年現在 | 構造化されたAI駆動エンタープライズ開発 |

### 従来開発との違い

| 要素 | 従来の開発 | Vibe Coding |
|------|-----------|-------------|
| 開発者の役割 | 手でコードを書く人 | AIを指揮するアーキテクト |
| 作業単位 | 数行〜数十行 | 複数ファイルの変更を一度に |
| 検証 | 途中で手動確認 | AIが自動検証→報告 |
| スピード | 線形（1時間1機能） | 指数関数的（1プロンプトで複雑な変更） |

---

## 2. Claude Code 固有のワークフロー

### 主要スラッシュコマンド一覧

| コマンド | 機能 | 使うタイミング |
|---------|------|---------------|
| `/init` | CLAUDE.md 自動生成 | プロジェクト初期化時 |
| `/clear` | コンテキストリセット | 別タスクに切り替える時 |
| `/compact` | 会話を圧縮 | トークン節約したい時 |
| `/plan` | Plan Mode に切り替え | 大規模変更の計画時 |
| `/context` | トークン使用状況確認 | 長いセッションの途中 |
| `/model` | モデル切り替え | Opus/Sonnet を切り替える時 |
| `/commit` | Git 自動コミット | 変更を保存する時 |
| `/batch` | 並列エージェント実行 | 大量の同種変更時 |
| `/resume` | セッション再開 | 以前の会話を引き継ぐ時 |
| `/rewind` | チェックポイント復帰 | 変更を取り消したい時 |

### TodoWrite ツールの活用

タスクを明確に分解して管理する：

```
タスク作成時に含めること:
- 詳細な説明（何を・なぜ・どう）
- ステップの前後関係（dependencies）
- 完了条件（テストが通る、ビルドが通る等）
```

---

## 3. CLAUDE.md の設計と管理

### 配置場所と優先順位

```
~/.claude/CLAUDE.md          # グローバル（全プロジェクト共通）
./CLAUDE.md                  # プロジェクトルート（チーム共有）
./src/CLAUDE.md             # サブディレクトリ（特定領域向け）
```

### 書くべき内容

```markdown
# Code Style
- インデント・命名規則・import順序など

# Workflow
- テスト実行コマンド
- ビルドコマンド
- コミット前にやること

# Architecture Decisions
- 採用しているパターン（MVVM等）
- 避けるべき実装方法

# Common Gotchas（よくあるミス・注意点）
- このプロジェクト固有の落とし穴
- 外部ライブラリの癖・注意事項
```

### 書くべきでない内容

```markdown
❌ 細かいAPI仕様（ドキュメントにリンクするだけでよい）
❌ 標準的な言語慣例（Claudeは既に知っている）
❌ 変更頻度の高い情報
❌ 長い説明やチュートリアル
❌ ファイル構造の詳細な説明
```

### 品質チェック

> **「この行を削除したら、Claudeは間違いを犯すか？」**
> - YES → 残す
> - NO → 削除する

**推奨: 200行以下に収める。長すぎると重要なルールが埋もれる。**

### ファイルのインポート機能

```markdown
# CLAUDE.md 内での他ファイル参照
See @README.md for project overview.
@docs/architecture.md
@~/.claude/personal-preferences.md
```

---

## 4. Plan Mode の活用

### Plan Mode とは

**読み取り専用の分析モード。** ファイルの読み込み・検索のみ行い、変更は一切しない。
実装前に変更計画をレビューできる。

### アクティベーション

```bash
# セッション開始時にPlan Modeで起動
claude --permission-mode plan

# 実行中の切り替え
Shift + Tab を2回押す
# Normal Mode → Auto-Accept Mode → Plan Mode
```

### 使うべきタイミング

**✅ Plan Mode を使う場合:**
- 3ファイル以上の変更が必要
- 既存モジュールへの影響がある新機能
- 複雑なリファクタリング
- 設計の相談・ブレインストーミング

**❌ Plan Mode を飛ばす場合:**
- タイポ修正
- ログ追加
- 変数名変更
- **一文で説明できる変更すべて**

### 実践フロー

```bash
# 1. Plan Modeで起動
claude --permission-mode plan

# 2. 計画を立てる
"OAuth2への移行計画を詳細に立てて"

# 3. 計画をエディタでレビュー
Ctrl + G

# 4. Normal Modeに切り替えて実装
Shift + Tab × 2
```

---

## 5. Spec-First 開発プロセス

### なぜ仕様を先に書くのか

曖昧な指示では：
- AIの解釈が自由になりすぎる
- 「動く」が「正しくない」実装になりやすい
- エッジケースが漏れる
- 修正が連鎖的に必要になる

### Prompt Contract（プロンプト契約書）

```markdown
---
role: iOSアプリ開発者
success_criteria:
  - すべての画面でSwiftUIのベストプラクティスに従う
  - SwiftDataでデータが正しく永続化される
  - 通知が設定した時刻に正確に届く
  - ウィジェットがホーム画面で正常に表示される

constraints:
  - iOS 17.0以上のみ対応
  - 外部ライブラリは承認済みのもののみ使用
  - MVVMアーキテクチャを厳守

uncertainty_handling: |
  実装方法が曖昧な場合は推測せず、必ず質問する。
  複数の実装方法がある場合はトレードオフを説明して選択肢を提示する。
---
```

### 4フェーズ開発サイクル

#### Phase 0: 仕様策定（Spec Phase）

```bash
claude --permission-mode plan
```

```
この機能を実装する前に、AskUserQuestion ツールで以下を確認してください：
- ユーザーはどのような操作をするか
- エラーケースはどのように扱うか
- 既存の機能との依存関係は
確認が完了したら SPEC.md を作成してください。
```

#### Phase 1: テストファースト（Red Phase）

```bash
# 新規セッションで
/clear
```

```
SPEC.md を参照して、まず失敗するテストを書いてください。
実装は一切せず、テストのみ作成してください。
テストを実行して失敗することを確認してください。
```

#### Phase 2: 最小実装（Green Phase）

```
テストを通過する最小限の実装をしてください。
各ファイルを変更したら即座にテストを実行して結果を見せてください。
```

#### Phase 3: リファクタリング（Refactor Phase）

```
テストが通った状態を維持しながらリファクタリングしてください。
各変更後にテストを実行して、何も壊れていないことを確認してください。
```

---

## 6. 効果的なプロンプト戦略

### ACID 原則

| 原則 | 説明 | 例 |
|------|------|-----|
| **S**pecific（具体的） | ファイル名・行番号を指定 | `@src/auth.ts line 45 の null check` |
| **C**oncise（簡潔） | 必要な情報だけ | 1つのプロンプトで1つのタスク |
| **I**terative（段階的） | フェーズごとに指示 | 全体を一度に指示しない |
| **D**irect（明確） | 曖昧さを排除 | 「実装してください」と明言 |

### プロンプトテンプレート

```
[対象ファイル]
@src/ViewModels/HomeViewModel.swift を見てください。

[問題]
toggleComplete メソッドが全タスク完了を検知できていません。

[要求]
明日のタスクがすべて完了した時に confettiTrigger をインクリメントするよう修正してください。

[検証]
修正後、ビルドが通ることを確認してください。
```

### スコープを絞るレベル

```
レベル1（曖昧） ❌
"このプロジェクトを改善して"

レベル2（広い） △
"認証を修正して"

レベル3（中） △
"@HomeViewModel.swift のトグル処理を修正して"

レベル4（明確） ✅
"@HomeViewModel.swift の toggleComplete メソッドが
 全タスク完了時に confettiTrigger を増加させていない。
 テストを書いてから修正して、ビルド確認してください。"
```

### エラー時の対処プロンプト

```
# ❌ 悪い例
"エラーが出ました。直してください"

# ✅ 良い例
"以下のエラーが出ています：
[完全なエラーメッセージ・スタックトレース]

根本原因を特定して修正し、ビルドが通ることを確認してください。
エラーを隠すのではなく、根本原因を解決してください。"
```

---

## 7. 上級テクニック

### 並列開発（Git Worktree）

異なるブランチで同時に作業する：

```bash
# Feature AをWorktreeで実装
claude --worktree feature-auth

# 別ウィンドウでBug Bを修正
claude --worktree bugfix-notification

# メインブランチでレビュー
cd .claude/worktrees/feature-auth
git diff main
```

**.gitignore に追加推奨:**
```
.claude/worktrees/
```

### /batch コマンドで並列マイグレーション

```bash
/batch すべてのViewファイルにPreviewを追加する
```

動作フロー：
1. コードベースを調査
2. 独立した単位に分解
3. 承認を求める
4. 各単位を並列で実行

### カスタムスキル（スラッシュコマンド）

`.claude/skills/` にスキルファイルを作成：

```markdown
# .claude/skills/ios-tdd/SKILL.md
---
name: ios-tdd
description: iOSアプリをTDDで実装する
---

# iOS TDD ワークフロー

1. RED: XCTestで失敗するテストを書く
   - xcodebuildで失敗を確認

2. GREEN: テストを通す最小限の実装
   - xcodebuildで成功を確認

3. REFACTOR: テストを通したままリファクタリング

各フェーズで結果を報告してから次へ進む。
```

実行: `/ios-tdd タスク完了アニメーションを実装`

### MCP サーバー連携

```bash
# GitHub MCPサーバーの追加
claude mcp add

# 設定確認
cat ~/.claude.json
```

```json
{
  "mcpServers": {
    "github": {
      "type": "stdio",
      "command": "node",
      "args": ["/path/to/github-mcp-server.js"],
      "env": { "GITHUB_TOKEN": "ghp_..." }
    }
  }
}
```

---

## 8. よくある失敗と対策

### ① コンテキスト汚染

**症状:** ハルシネーションが会話に残り続け、AIが誤情報を繰り返す。

```
対策:
- /clear で会話をリセット
- 「この属性はありません」より「@model.swift を見直して」
- 汚染が疑われたら即座に新セッション開始
```

### ② コンテキスト劣化（長いセッション）

**症状:** セッション後半で最初の指示（コーディング規約等）を忘れる。

**原因:** コンテキストの中盤のトークンが無視されやすい特性。

```
対策:
- 重要な指示は CLAUDE.md に移す
- 3〜4時間以上の作業は /clear で分割
- /context でトークン使用状況を常時確認
```

### ③ ハルシネーション

**3つのレベル:**
1. 一度限りの間違い → 訂正で解決
2. 繰り返しハルシネーション → セッションリセット
3. 自信ある嘘（存在しないメソッド等）→ @ファイル参照で確認させる

```
対策:
"このメソッドは @src/file.swift に存在するか？
ファイルを開いて行番号を示してから答えてください。"
```

### ④ コードが壊れていく問題

**症状:** 最初は動くが、3〜4回の修正後に別の部分が壊れる。

```
対策:
1. 段階的な実行: 1変更 → テスト → 次へ（まとめて変更しない）
2. 頻繁なgitコミット: 動いている状態を常にチェックポイントに
3. 一度に変更するファイルは3〜5個まで
4. テスト・lintを各ステップで実行
```

### ⑤ スコープ肥大化（Scope Creep）

**症状:** 小さな修正を頼んだはずが、大量のファイルが書き変わる。

```
対策:
"今回は @HomeView.swift のバナー表示のみ修正してください。
他のファイルは変更しないでください。"
```

---

## 9. モデル選択ガイド

| 指標 | Opus 4.6 | Sonnet 4.6 |
|------|---------|-----------|
| コーディング精度 | ◎ | ○ |
| 実装スピード | △ | ◎ |
| 複雑な設計判断 | ◎ | ○ |
| コスト | $15/MTok | $3/MTok |

### 推奨使い分け（Sonnet : Opus = 4 : 1）

```
Sonnet 4.6（日常の80%）:
- バグ修正・小さな機能追加
- テスト作成
- ドキュメント生成
- リファクタリング

Opus 4.6（複雑な20%）:
- アーキテクチャ設計
- セキュリティクリティカルな実装
- 大規模リファクタリング
- 複雑なデバッグ
```

切り替え方:
```bash
/model  # モデル選択メニューが開く
```

---

## 10. TTDプロジェクント 適用計画

TTD（Tomorrow To Do）iOSアプリへのVibe Coding手法適用ロードマップ。

---

### 現在の状態（Phase 1 完了済み）

- [x] Models（TaskItem / TaskCategory / TaskTemplate）
- [x] ViewModels（HomeViewModel / SettingsViewModel）
- [x] Views（HomeView / TemplateView / SettingsView）
- [x] Services（NotificationService）
- [x] Shared（DesignTokens）
- [x] GitHubへのプッシュ

---

### Phase 2: コア機能の完成

#### Step 2-1: ビルド確認・バグ修正
```
Xcodeでビルドして、エラーがあればここに貼り付けてください。
根本原因を特定して1件ずつ修正します。
```

#### Step 2-2: ConfettiSwiftUI 導入
```bash
# SPMで追加
# https://github.com/simibac/ConfettiSwiftUI.git バージョン 3.0.0
```

```
# Xcodeで追加後に指示:
"@HomeView.swift の .confettiCannon コメントアウトを解除して、
全タスク完了時のコンフェッティ演出を有効にしてください"
```

#### Step 2-3: 今日→明日の自動リセット
```
"毎朝指定時刻に昨日のリストを自動リセットするロジックを
@HomeViewModel.swift に追加してください。
UserDefaultsで最終リセット日を管理して、
アプリ起動時にチェックしてください。"
```

#### Step 2-4: ウィジェット実装
```bash
# Xcodeでターゲット追加: File > New > Target > Widget Extension
```

```
"TTDWidgetという名前のWidget Extensionを作成しました。
@TTD/TTD/Models/TaskItem.swift のデータを参照して、
明日の未完了タスク数と上位3件を表示する
小サイズウィジェットを実装してください。
AppGroupを使ってデータを共有してください。"
```

---

### Phase 3: テンプレート機能の強化

#### Step 3-1: テンプレートから明日のリストに適用
```
"@TemplateView.swift のテンプレートを長押しした時に
コンテキストメニュー「明日のリストに追加」を表示して、
テンプレートのタスクをすべて明日の targetDate で追加する
機能を実装してください。"
```

#### Step 3-2: テンプレートの編集機能
```
"テンプレート詳細画面でタスクの追加・削除・並べ替えができるよう
@TemplateView.swift を拡張してください。"
```

---

### Phase 4: UX磨き込み

#### Step 4-1: Lottie チェックアニメーション
```bash
# SPMで追加
# https://github.com/airbnb/lottie-spm.git バージョン 4.6.0
```

```
"タスク完了時のチェックボックスに Lottie アニメーションを
組み込んでください。LottieFiles からフリーのチェックマーク
アニメーションを使用する形で @TaskRowView.swift を更新してください。"
```

#### Step 4-2: 空の状態（Empty State）
```
"各カテゴリにタスクが1件もない場合、
「+ タップして追加」という案内を表示する
Empty State を @CategorySectionView.swift に追加してください。"
```

#### Step 4-3: ダークモード確認
```
"すべての画面でダークモードが正しく表示されるか確認して、
問題があれば @DesignTokens.swift のカラーを調整してください。"
```

---

### Phase 5: 品質保証

#### Step 5-1: 単体テスト
```
"@HomeViewModel.swift の以下のテストを XCTest で書いてください：
- addTask: タイトルが空の場合はタスクが追加されない
- toggleComplete: 全タスク完了時に confettiTrigger が増加する
- deleteTask: 削除後にタスクが存在しない
テストを実行して全件通ることを確認してください。"
```

#### Step 5-2: ビルド最終確認
```bash
xcodebuild build -scheme TTD -destination 'platform=iOS Simulator,name=iPhone 16 Pro'
xcodebuild test -scheme TTD -destination 'platform=iOS Simulator,name=iPhone 16 Pro'
```

---

### Vibe Coding セッション進め方のルール（TTD専用）

```markdown
## 各セッション開始時
1. git status で現在の状態確認
2. /context でトークン残量確認
3. 前回の続きは「前回 〇〇 まで完了しました。続きは〜」と明示

## セッション中
- 1タスクずつ依頼（まとめて頼まない）
- 変更後は必ずビルド確認を指示
- エラーは完全なメッセージをコピペ
- 3ファイル以上の変更は Plan Mode を先に使う

## セッション終了時
- 動いている状態で git commit
- git push でGitHubに反映
- 次回やることをコメントに残す

## モデル使い分け
- 通常の実装・修正 → Sonnet 4.6
- アーキテクチャ相談・複雑なバグ → Opus 4.6
```

---

## 11. 参考資料

### 公式ドキュメント

- [Claude Code Best Practices](https://code.claude.com/docs/en/best-practices)
- [Claude Code Common Workflows](https://code.claude.com/docs/en/common-workflows)
- [Slash Commands](https://code.claude.com/docs/en/slash-commands)
- [Sub-Agents](https://code.claude.com/docs/en/sub-agents)
- [MCP Integration](https://code.claude.com/docs/en/mcp)

### ベストプラクティス・上級テクニック

- [Claude Code Ultimate Guide (GitHub)](https://github.com/FlorianBruniaux/claude-code-ultimate-guide)
- [Awesome Claude Code](https://github.com/hesreallyhim/awesome-claude-code)
- [Prompt Contracts で品質向上（Medium）](https://medium.com/@rentierdigital/i-stopped-vibe-coding-and-started-prompt-contracts-claude-code-went-from-gambling-to-shipping-4080ef23efac)
- [Parallel AI Coding with Git Worktrees](https://docs.agentinterviews.com/blog/parallel-ai-coding-with-gitworktrees/)
- [CLAUDE.md Complete Guide](https://www.claudedirectory.org/blog/claude-md-guide)

### Plan Mode

- [Plan Mode 解説（DataCamp）](https://www.datacamp.com/tutorial/claude-code-plan-mode)
- [Plan Mode の実態（Armin Ronacher）](https://lucumr.pocoo.org/2025/12/17/what-is-plan-mode/)

### TDD との統合

- [TDD with Claude Code（The New Stack）](https://thenewstack.io/claude-code-and-the-art-of-test-driven-development/)
- [TDD Skill for Claude Code](https://www.aihero.dev/skill-test-driven-development-claude-code)

### 失敗事例・対策

- [よくある Vibe Coding の10の失敗](https://atarim.io/blog/the-10-most-common-vibe-coding-mistakes-and-how-to-avoid-them/)
- [コンテキストがどのように失敗するか](https://www.dbreunig.com/2025/06/22/how-contexts-fail-and-how-to-fix-them.html)

### iOS 開発特化

- [Claude Code iOS Dev Guide (GitHub)](https://github.com/keskinonur/claude-code-ios-dev-guide)

### 日本語リソース

- [個人的 Vibe Coding のやり方（Zenn）](https://zenn.dev/yoshiko/articles/my-vibe-coding)
- [バイブコーディングチュートリアル（azukiazusa.dev）](https://azukiazusa.dev/blog/vibe-coding-tutorial-create-app-with-claude-code/)
- [Vibe Coding とは（AI総合研究所）](https://www.ai-souken.com/article/what-is-vibe-coding)

---

*作成日: 2026/03/16*
*バージョン: 1.0（最新リサーチ統合版）*
