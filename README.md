---

````markdown
# AWS Terraform Foundation

This repository provides Terraform configurations to bootstrap a foundational AWS infrastructure, including VPCs, subnets, security groups, S3 buckets (with optional SSL cert), and backend state with S3 + DynamoDB for locks.

---

## 🔧 Prerequisites

- **Terraform CLI** ≥ 1.2  
- AWS CLI installed and configured with credentials  
- IAM permissions sufficient for:
  - Creating VPCs, subnets, security groups, route tables
  - S3 buckets and objects, DynamoDB tables
  - IAM roles/policies, ACM certificates
  - (Optional) Route53 updates if managing SSL

---

## 🛡️ Required IAM Permissions

Ensure the executing IAM role/user has at least:

- `ec2:*` on VPCs, subnets, internet gateways
- `s3:*` on the designated state bucket
- `dynamodb:*` on the Terraform lock table
- `iam:*` if creating roles or policies
- `acm:*` for SSL cert operations
- `route53:*` *(only if validating certificates via DNS)*

---

## ⚙️ Configuration & Variables

All configurable values are in `variables.tf`. Example:

```hcl
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Target environment (dev, staging, prod)"
  type        = string
}

variable "state_bucket" {
  description = "S3 bucket name for Terraform state"
  type        = string
}

variable "lock_table_name" {
  description = "DynamoDB table name for state locking"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "List of CIDRs for public subnets"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of CIDRs for private subnets"
  type        = list(string)
}

variable "allowed_ssh_cidr" {
  description = "CIDR blocks allowed for SSH access"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "cert_domain_name" {
  description = "(Optional) Domain name for ACM SSL certificate"
  type        = string
  default     = ""
}
````

---

## 🚀 Usage

1. **Setup backend**: Create the S3 bucket and DynamoDB table manually or via Terraform.
2. Initialize:

   ```bash
   terraform init \
     -backend-config="bucket=<YOUR_BUCKET>" \
     -backend-config="key=terraform.tfstate" \
     -backend-config="region=<YOUR_REGION>" \
     -backend-config="dynamodb_table=<YOUR_DDB_TABLE>"
   ```
3. Plan:

   ```bash
   terraform plan \
     -var="environment=dev" \
     -var="state_bucket=<YOUR_BUCKET>" \
     -var="lock_table_name=<YOUR_TABLE>" \
     -var="public_subnets=[\"10.0.1.0/24\",\"10.0.2.0/24\"]" \
     -var="private_subnets=[\"10.0.3.0/24\",\"10.0.4.0/24\"]"
   ```
4. Apply:

   ```bash
   terraform apply \
     -auto-approve \
     -var="environment=dev" \
     ... (same as above)
   ```

---

## 📁 Module Structure

* `main.tf` — orchestrates resources
* `provider.tf` — sets up AWS provider
* `s3.tf` — state bucket config
* `vpc.tf` — VPC, subnets, IGW, route tables
* `sg.tf` — default/inbound security groups
* `cert-ssl.tf` — optional ACM certificate
* `variables.tf` — all configurable inputs

---

## 🔐 IAM Role & Policies

If using an assumed IAM role, ensure it has these policies attached:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:*",
        "s3:*",
        "dynamodb:*",
        "iam:*",
        "acm:*",
        "route53:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
```

For least-privilege, scope down resource ARNs where possible (e.g., bucket/table names).

---

## ✅ What You Should Have Before Running

| Item                        | Example                      |
| --------------------------- | ---------------------------- |
| S3 Bucket (terraform state) | `my-org-tf-state`            |
| DynamoDB Table (locking)    | `my-org-tf-lock`             |
| AWS Permissions             | Full EC2/S3/DynamoDB/IAM/ACM |
| Variables defined           | In `terraform.tfvars` or CLI |

---

## 📞 Contact & Contributions

If you encounter issues or have enhancement ideas, please open an issue or submit a PR here.

---

## 📄 License

Licensed under [Apache‑2.0](LICENSE).

---

### ✅ Summary Checklist

* [ ] Create S3 + DynamoDB backend
* [ ] Grant IAM permissions
* [ ] Populate `terraform.tfvars` or `-var` CLI args
* [ ] `terraform init`, `plan`, and `apply`

---

```yaml
# Example terraform.tfvars
aws_region         = "us-east-1"
environment        = "dev"
state_bucket       = "my-org-tf-state"
lock_table_name    = "my-org-tf-lock"
vpc_cidr           = "10.0.0.0/16"
public_subnets     = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets    = ["10.0.3.0/24", "10.0.4.0/24"]
allowed_ssh_cidr   = ["198.51.100.0/24"]
cert_domain_name   = "example.com"  # optional
```

---

### 🧩 Next Steps

Consider adding:

* Module inputs for NAT gateways or endpoints
* DNS provisioning (Route53)
* CI/CD pipeline automation (GitHub Actions, etc.)

```

---
```
