# Instagram風SNSアプリケーション

フリーランスエンジニアのポートフォリオプロジェクトとして開発した、**AWS本番環境で稼働するInstagram風SNSアプリケーション**です。

🔥 **本番環境デプロイ済み** - AWS ECS Fargate上で完全稼働中

## 🎯 プロジェクト概要

実務レベルのWebアプリケーション開発を実践し、**開発からAWSデプロイまで一貫して実装**したプロジェクトです。

## 🛠️ 技術スタック

### バックエンド
- **Ruby on Rails 7.2** - Webアプリケーションフレームワーク
- **PostgreSQL 16** - リレーショナルデータベース
- **Redis** - キャッシュ・ジョブキュー
- **Devise** - ユーザー認証
- **Sidekiq** - バックグラウンドジョブ処理
- **Active Storage + S3** - 画像アップロード管理

### インフラ（AWS）✅
- **ECS Fargate** - コンテナオーケストレーション
- **RDS PostgreSQL** - マネージドデータベース (db.t3.micro)
- **ElastiCache Redis** - マネージドキャッシュ
- **Application Load Balancer** - ロードバランサー
- **S3** - 画像ストレージ
- **ECR** - Dockerイメージレジストリ
- **VPC** - ネットワーク構成
- **Terraform** - Infrastructure as Code（47リソース）

### テスト
- **RSpec** - テストフレームワーク（77テストケース）
- **FactoryBot** - テストデータ作成
- **Capybara** - E2Eテスト
- **Shoulda Matchers** - バリデーションテスト

### フロントエンド
- **Stimulus.js** - JavaScriptフレームワーク
- **Importmap** - モジュール管理

## ✅ 実装済み機能

### ユーザー機能
- ✅ ユーザー認証（サインアップ/ログイン/ログアウト）
- ✅ プロフィール管理（画像アップロード、編集）
- ✅ パスワードリセット

### 投稿機能
- ✅ 画像投稿（複数画像対応、S3連携）
- ✅ キャプション入力
- ✅ 投稿削除

### ソーシャル機能
- ✅ フォロー/アンフォロー（Ajax対応）
- ✅ いいね機能（Ajax対応）
- ✅ コメント機能（Ajax対応）
- ✅ @メンション機能
- ✅ タイムライン（フォロー中ユーザー優先表示）

### 通知機能
- ✅ メンション時のメール通知（Sidekiq非同期処理）

### テスト
- ✅ 77テストケース（Model/Request/System Spec）

### インフラ
- ✅ **AWS本番環境デプロイ完了**
- ✅ Terraform IaCによるインフラ管理
- ✅ Docker本番イメージビルド
- ✅ ECS Fargate運用
- ✅ S3画像アップロード連携

## 🏗️ AWS構成
```
Internet
    ↓
Application Load Balancer (HTTP:80)
    ↓
ECS Fargate Cluster
├── Web Service (Fargate)
│   └── Rails App Container
└── Sidekiq Service (Fargate)
    └── Sidekiq Container
    ↓
├→ RDS PostgreSQL (db.t3.micro)
├→ ElastiCache Redis
└→ S3 Bucket (画像ストレージ)
```

**リソース構成:**
- VPC: 2 Public Subnets, 2 Private Subnets
- セキュリティグループ: ALB, ECS, RDS, Redis用
- IAMロール: ECS Task Execution/Task Role
- CloudWatch Logs: アプリケーションログ

## 💰 コスト最適化

**月額コスト: 約$5-15**

実施した最適化:
- ✅ NAT Gateway削除（-$60/月）
- ✅ RDS db.t3.micro化（無料枠対象）
- ✅ Multi-AZ無効化
- ✅ ECSをパブリックサブネットに配置
- ✅ 必要時のみ起動運用

## 💻 ローカル開発環境のセットアップ

### 必要な環境
- Ruby 3.3.2
- Rails 7.2.3
- PostgreSQL 14+
- Redis
- Node.js 18+

### インストール手順
```bash
# リポジトリをクローン
git clone https://github.com/tk53582005/instagram-app.git
cd instagram-app

# 依存関係をインストール
bundle install

# データベースのセットアップ
rails db:create
rails db:migrate

# Redisを起動
brew services start redis

# Sidekiqを起動（別ターミナル）
bundle exec sidekiq

# サーバーを起動
rails server
```

ブラウザで `http://localhost:3000` にアクセス

### テストの実行
```bash
# 全テストを実行
bundle exec rspec

# 特定のテストを実行
bundle exec rspec spec/models
bundle exec rspec spec/requests
bundle exec rspec spec/system
```

## 🚀 AWSデプロイ手順

### 前提条件
- AWSアカウント
- AWS CLI設定済み
- Terraform インストール済み
- Docker インストール済み

### デプロイ手順
```bash
# 1. ECRにログイン
aws ecr get-login-password --region ap-northeast-1 | \
  docker login --username AWS --password-stdin <AWS_ACCOUNT_ID>.dkr.ecr.ap-northeast-1.amazonaws.com

# 2. Dockerイメージをビルド
docker build -t instagram-app:latest .

# 3. ECRにプッシュ
docker tag instagram-app:latest <AWS_ACCOUNT_ID>.dkr.ecr.ap-northeast-1.amazonaws.com/instagram-app:latest
docker push <AWS_ACCOUNT_ID>.dkr.ecr.ap-northeast-1.amazonaws.com/instagram-app:latest

# 4. Terraformでインフラ構築
cd terraform
terraform init
terraform apply

# 5. 環境変数の設定
# terraform.tfvarsに以下を設定:
# - db_password
# - rails_master_key
# - s3_bucket_name

# 6. デプロイ完了後、ALBのDNS名でアクセス
```

### インフラの停止
```bash
# ECSタスクを停止（コスト削減）
aws ecs update-service --cluster instagram-app-cluster \
  --service instagram-app-web-service --desired-count 0 --region ap-northeast-1

# 完全削除
cd terraform
terraform destroy
```

## 📊 技術的ハイライト

### コスト最適化の実践
- NAT Gateway削除により月額$60削減
- RDS無料枠の活用
- ECSのパブリックサブネット配置

### インフラのコード化
- Terraformによる47リソースの管理
- 再現可能なインフラ構成
- バージョン管理された設定

### 本番環境対応
- Docker マルチステージビルド
- セキュリティグループの適切な設定
- ヘルスチェック実装
- ログ管理（CloudWatch Logs）

### テスト駆動開発
- 77テストケースによる品質保証
- Model/Request/System Specの包括的カバレッジ

## 🔐 セキュリティ

- Deviseによる認証
- Strong Parametersによるパラメータ検証
- CSRF保護
- 環境変数による機密情報の管理
- IAMロールによる最小権限の原則
- セキュリティグループによるネットワーク制御

## 📝 開発のポイント

1. **実務レベルのコード品質**
   - 可読性の高いコード
   - DRY原則の遵守
   - 適切なエラーハンドリング

2. **本番環境を意識した設計**
   - スケーラブルなアーキテクチャ
   - コスト最適化
   - 監視・ログ管理

3. **Infrastructure as Code**
   - Terraformによる管理
   - 再現可能な環境構築

## 👤 作成者

**Kazuhiro**
- GitHub: [@tk53582005](https://github.com/tk53582005)
- 目標: フリーランスAWSエンジニアとしてのキャリア構築

## 📅 開発履歴

- **Phase 1-4**: 基本機能実装（認証、投稿、コメント、フォロー）✅
- **Phase 5**: テスト実装（77テストケース）✅
- **Phase 6**: 本番環境設定 ✅
- **Phase 7**: Terraformインフラコード化 ✅
- **Phase 8**: Dockerイメージ作成 ✅
- **Phase 9-10**: **AWSデプロイ成功・動作確認完了** ✅

## ⭐ Star this repository

このプロジェクトが参考になった場合は、スターをつけていただけると嬉しいです!

## 📄 License

このプロジェクトはポートフォリオ目的で作成されています。
