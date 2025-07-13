# AWS Terraform Foundation

This project provisions foundational AWS infrastructure using Terraform. It includes modules for networking (VPC/Subnets), EKS clusters, RDS databases, and other shared cloud resources to support scalable environments.

## 📦 Modules Overview

The setup is composed of multiple Terraform modules:

- `environment`: Provisions EKS cluster and supporting resources.
- `database-env`: Provisions RDS instance and related components.
- `vpc`: Uses existing VPC, private and public subnets.
- `iam`: Uses existing IAM role for administration.
- `secretsmanager`: Reads sensitive information from AWS Secrets Manager.

---

## ⚙️ Configuration Requirements

Before running Terraform, make sure to configure the following data sources and variables.

### 🔐 Secrets Manager

```hcl
data "aws_secretsmanager_secret" "read-db-secrets" {
  name = "<your-db-secret-name>"
}
````

* This secret should contain credentials or sensitive config for your RDS database.

---

### 🧠 IAM Role

```hcl
data "aws_iam_role" "ku_learn_admin_role" {
  name = "<existing-iam-role-name>"
}
```

* This role should have permissions for managing infrastructure and accessing shared AWS resources.

---

### 🗃️ S3 Bucket for Terraform Backend

```hcl
terraform {
  backend "s3" {
    encrypt = true
    bucket  = "<your-terraform-state-bucket>"
    key     = "foundation/terraform.tfstate"
    region  = "ap-southeast-7"
    profile = "default"
  }
}
```

Also add:

```hcl
data "aws_s3_bucket" "s3_my_bucket" {
  bucket = "<your-bucket-name>"
}
```

---

### ☁️ VPC and Subnets (Existing)

```hcl
data "aws_vpc" "selected" {
  id = "<your-vpc-id>"
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
  filter {
    name   = "tag:Name"
    values = ["*Private*"]
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
  filter {
    name   = "tag:Name"
    values = ["*Public*"]
  }
}
```

---

## 🚀 Module Inputs Example

### EKS Module

```hcl
module "environment-dev" {
  source              = "./modules/environment"
  ENV_NAME            = "dev"
  EKS_CLUSTER_VERSION = "1.32"
  DESIRED_SIZE        = 3
  MAX_SIZE            = 5
  MIN_SIZE            = 3
  PRIVATE_SUBNETS_ID  = data.aws_subnets.private.ids
  PUBLIC_SUBNETS_ID   = data.aws_subnets.public.ids
  INSTANCE_NODE_TYPE  = "t3.medium"
}
```

### RDS Module

```hcl
module "database-my-env-dev" {
  source              = "./modules/database-env"
  ENV_NAME            = "dev"
  RDS_INSTANCE_TYPE   = "Serverless v2"
  PRIVATE_SUBNETS     = data.aws_subnet.private_subnet
  VPC_ID              = data.aws_vpc.selected.id
  INTERNAL_SG         = aws_security_group.internal-sg.id
  ROUTE53_ZONE_ID     = "<your-route53-zone-id>"
  SKIP_FINAL_SNAPSHOT = false
}
```

---

## 🧪 Usage

1. Clone this repository:

   ```bash
   git clone https://github.com/JiratchayaPhinyodom/aws-terraform-foundation.git
   cd aws-terraform-foundation
   ```

2. Set up AWS credentials (e.g., via `~/.aws/credentials` or environment variables).

3. Fill in required configuration requirements.

4. Initialize Terraform:

   ```bash
   terraform init
   ```

5. Preview the changes:

   ```bash
   terraform plan
   ```

6. Apply the configuration:

   ```bash
   terraform apply
   ```

---

## 📝 Requirements

* Terraform >= 1.0.5
* AWS CLI configured with necessary credentials
* Existing VPC with public and private subnets
* Pre-created S3 bucket for remote state
* Secrets Manager and IAM roles already provisioned

---

## 📂 Directory Structure

```
.
├── main.tf
├── provider.tf
├── variables.tf
├── modules/
│   ├── environment/
│   └── database-env/
```

---

## 📬 Contact

For questions or feedback, please open an issue or contact [Jiratchaya Phinyodom](https://github.com/JiratchayaPhinyodom).
