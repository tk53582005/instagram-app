# 基本設定
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "instagram-app"
}

# VPC設定
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# RDS設定
variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t4g.micro"
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "instagram_app_production"
}

variable "db_username" {
  description = "Database master username"
  type        = string
  default     = "instagram_admin"
}

variable "db_password" {
  description = "Database master password"
  type        = string
  sensitive   = true
}

# ElastiCache設定
variable "redis_node_type" {
  description = "ElastiCache Redis node type"
  type        = string
  default     = "cache.t4g.micro"
}

# ECS設定
variable "ecs_task_cpu" {
  description = "ECS task CPU units"
  type        = string
  default     = "256" # 0.25 vCPU
}

variable "ecs_task_memory" {
  description = "ECS task memory in MB"
  type        = string
  default     = "512" # 0.5 GB
}

variable "app_image" {
  description = "Docker image URL"
  type        = string
}

variable "rails_master_key" {
  description = "Rails master key"
  type        = string
  sensitive   = true
}

# S3設定
variable "s3_bucket_name" {
  description = "S3 bucket name for Active Storage"
  type        = string
}
