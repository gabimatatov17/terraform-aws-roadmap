# Phase 2 - Terraform AWS Setup

## Overview

This project sets up a VPC with public and private subnets, EC2 instances for web and database tiers, and stores Terraform state remotely in S3.

---

## 📦 Requirements

- Terraform >= 1.9.5
- AWS CLI configured
- Access to an AWS account

---

## 📁 Folder Structure

```
.
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
├── s3-state-resources.tf
├── backend/
│   └── backend.tf
├── user_data/
│   ├── web
│   └── db
```

---

## 🚀 Deployment Steps

1. **Clone the repository**

```bash
git clone <repo_url>
cd <project_dir>
```

2. **Configure your variables**
   Edit `terraform.tfvars` to match your desired CIDRs, AMIs, instance types, etc.

3. **Initialize Terraform**

```bash
terraform init
terraform plan -var-file=vpc.tfvars -out=planfile.planfile
```

4. **Deploy the infrastructure**

```bash
terraform apply planfile.planfile
```

5. **Copy state file to s3 beckend bucket**
**For future terraform updates start from this step to init state from backend, then plan/apply.**

```bash
cp backend/s3-backend.tf .
terraform init -reconfigure
```

6. **Verify**
   - Check S3 bucket for `terraform.tfstate`
   - SSH to the web server (if SSH rule is in place)
   - Access public IP in browser (web server)
   - Check logs or connection to DB server from web

---

## 🩹 Destroying Resources

To destroy all:
```bash
terraform destroy
```

To destroy one:
```bash
terraform destroy -target=aws_instance.web
```

---

## 🔐 Notes

- State is stored in: `s3://gabi-terraform-state/phase2/terraform.tfstate`
- Versioning and encryption are enabled on the S3 bucket.
- Avoid editing state manually in S3.

---

## 🛠️ TODO

- Add DynamoDB locking (optional but recommended for teams)
