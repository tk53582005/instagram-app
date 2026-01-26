# Instagram風SNSアプリケーション

フリーランスエンジニアのポートフォリオとして開発した、**AWS上で本番稼働（ECS Fargate）を確認済み**のInstagram風SNSアプリケーションです。

> コスト最適化のため、検証後は `terraform destroy` で停止・削除できる構成にしています。

## 🎯 プロジェクト概要
開発〜AWSデプロイまでを一貫して実装し、実務レベルの構成（Docker / IaC / 本番設定 / テスト）を再現しました。

## 🛠 技術スタック

### バックエンド
- Ruby on Rails 7.2
- PostgreSQL 16
- Redis（キャッシュ / Sidekiq）
- Devise（認証）
- Sidekiq（非同期ジョブ）
- Active Storage + S3（画像）

### インフラ（AWS）
- ECS Fargate
- RDS PostgreSQL（db.t3.micro）
- ElastiCache Redis
- Application Load Balancer（HTTP:80）
- S3（画像ストレージ）
- ECR（Dockerレジストリ）
- VPC / Security Group / IAM
- Terraform（IaC）

### テスト
- RSpec（77 tests）
- FactoryBot / Capybara / Shoulda Matchers

### フロントエンド
- Stimulus.js
- Importmap

## ✅ 実装済み機能

### ユーザー機能
- サインアップ/ログイン/ログアウト
- プロフィール編集（画像アップロード）
- パスワードリセット

### 投稿機能
- テキスト投稿
- 画像投稿（S3連携）
- 投稿削除

### ソーシャル機能
- フォロー/アンフォロー（Ajax）
- いいね（Ajax）
- コメント（Ajax）
- @メンション
- タイムライン（フォロー中ユーザー優先）

### 通知
- メンション時メール通知（Sidekiq）

### インフラ
- Docker本番イメージ
- Terraformで再現可能なAWS構成
- ECS上で稼働・動作確認（ログイン/投稿/画像アップロード）

## 🏗 AWS構成（概要）
```text
Internet
  ↓
ALB (HTTP:80)
  ↓
ECS Fargate Cluster
  ├─ Web Service (Rails)
  └─ Sidekiq Service
  ↓
  ├─ RDS PostgreSQL
  ├─ ElastiCache Redis
  └─ S3 (画像)
```

## 💰 コスト最適化（目安）
- NAT Gateway削除（コスト削減）
- RDS db.t3.micro / Multi-AZ無効化
- 必要時のみ起動 → 検証後は `terraform destroy` で課金停止

## 💻 ローカル開発

### 必要環境
- Ruby 3.3.2
- Rails 7.2.x
- PostgreSQL 14+
- Redis
- Node.js 18+（任意）

### 起動
```bash
git clone https://github.com/tk53582005/instagram-app.git
cd instagram-app

bundle install
rails db:create db:migrate

# Redis（例: macOS）
brew services start redis

# Sidekiq（別ターミナル）
bundle exec sidekiq

# Rails
rails server
```

http://localhost:3000

### テスト
```bash
bundle exec rspec
```

## 🚀 AWSデプロイ（再現手順）

### 前提
- AWS CLI設定済み
- Terraform / Docker インストール済み

### 1) ECRへpush
```bash
aws ecr get-login-password --region ap-northeast-1 | \
  docker login --username AWS --password-stdin <AWS_ACCOUNT_ID>.dkr.ecr.ap-northeast-1.amazonaws.com

docker build -t instagram-app:latest .

docker tag instagram-app:latest <AWS_ACCOUNT_ID>.dkr.ecr.ap-northeast-1.amazonaws.com/instagram-app:latest
docker push <AWS_ACCOUNT_ID>.dkr.ecr.ap-northeast-1.amazonaws.com/instagram-app:latest
```

### 2) Terraform apply
```bash
cd terraform
terraform init

# 例: terraform.tfvars を用意（値は環境に合わせて設定）
# db_password = "..."
# secret_key_base = "..."
# s3_bucket_name = "..."

terraform apply
```

### 3) アクセス

Terraform出力のALB DNSにアクセスして動作確認します。

## 🧾 技術的ハイライト
- Dockerマルチステージビルド
- TerraformによるIaC（再現可能な構築）
- ECS/ALB/RDS/Redis/S3の連携
- 77テストによる品質担保
- コスト最適化（NAT削除、必要時起動）

## 👤 作成者

Kazuhiro（GitHub: @tk53582005）

## 📄 License

ポートフォリオ目的のプロジェクトです。
