
# Terraform AWS Learning Roadmap (Beginner to Expert)

## 🟢 Phase 1: Beginner – Terraform Basics (1 week)
Learn core Terraform syntax and local usage.

### ✅ Topics:
- What is Terraform?
- Installation & CLI Basics
- Providers, Resources, Data Sources
- Variables, Outputs
- State management (local)

### 🛠️ Practice Projects:
- Provision an EC2 instance
- Create an S3 bucket
- Use variables & outputs

📁 Folder: `01-basics/`

---

## 🟡 Phase 2: Intermediate – AWS-Specific Usage (2–3 weeks)
Understand AWS resources in depth and how to manage them via Terraform.

### ✅ Topics:
- AWS Provider Configuration
- IAM (Users, Roles, Policies)
- EC2, VPC, Security Groups
- S3, CloudWatch Logs, CloudTrail
- State storage in S3 + state locking via DynamoDB
- Remote Backends

### 🛠️ Practice Projects:
- Create a VPC with subnets, NAT, IGW
- Deploy a simple 2-tier app (web + db)
- Set up remote backend with S3 and DynamoDB

📁 Folder: `02-aws-core/`

---

## 🟠 Phase 3: Advanced – Modules, Workspaces, CI/CD (3–4 weeks)
Make Terraform scalable and production-ready.

### ✅ Topics:
- Modules (creating, consuming)
- Workspaces
- Environments (dev/stage/prod)
- CI/CD with Terraform (GitHub Actions, GitLab CI)
- Terraform Cloud & Sentinel (optional)
- Secrets handling (SSM, Secrets Manager, Vault)

### 🛠️ Practice Projects:
- Create reusable modules (e.g., VPC, EC2, RDS)
- Set up GitHub Actions to deploy infrastructure
- Use parameter store or secrets manager

📁 Folder: `03-advanced/`

---

## 🔴 Phase 4: Expert – Real-World Architecture + Best Practices (ongoing)
Work with real-world patterns, large scale infra, and contribute to infra repos.

### ✅ Topics:
- Terraform Best Practices (file structure, linting, versioning)
- Large-scale project structure
- State migration
- Terraform with Kubernetes (EKS module)
- Zero-downtime deployments
- Cost estimation (Infracost)

### 🛠️ Practice Projects:
- Full EKS Cluster with monitoring & logging
- Full production-ready architecture
- Use Terragrunt (optional)
- Multi-account strategy using Organizations + cross-account IAM

📁 Folder: `04-expert/`

---

## 🧠 Continuous Learning:
- Follow the HashiCorp blog & changelog
- Contribute to public Terraform modules
- Build your own custom provider or module

---

## 📚 Resources:
- [Official Docs](https://developer.hashicorp.com/terraform/docs)
- [AWS Provider Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Learn Terraform](https://learn.hashicorp.com/collections/terraform/aws-get-started)
- [Terraform Best Practices](https://www.terraform-best-practices.com/)
