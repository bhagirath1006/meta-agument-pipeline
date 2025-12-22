# Terraform Meta-Arguments Pipeline

A simple and clear Terraform project demonstrating all meta-arguments with AWS infrastructure.

## Meta-Arguments Demonstrated

- **count** - VPC module (multiple VPCs)
- **for_each** - Security Groups and S3 buckets
- **depends_on** - EC2 depends on VPC and Security Groups
- **lifecycle** - S3 lifecycle rules and resource management

## Structure

```
├── provider.tf              # AWS provider
├── variables.tf             # Input variables
├── outputs.tf               # Output values
├── main.tf                  # Root module configuration
├── terraform.tfvars         # Variable values
├── modules/
│   ├── vpc/                 # VPC with count
│   ├── security_group/      # Security groups with for_each
│   ├── ec2/                 # EC2 with depends_on
│   └── s3/                  # S3 with lifecycle
└── .github/workflows/       # GitHub Actions CI/CD
```

## Quick Start

```bash
# Initialize
terraform init

# Plan
terraform plan

# Apply
terraform apply
```

## Customize

Edit `terraform.tfvars`:


project_name     = "myproject"
vpc_count        = 1
ec2_instance_count = 1
```

## Environment

Validate environment:
```bash
terraform validate
```

Format code:
```bash
terraform fmt -recursive
```

Destroy:
```bash
terraform destroy
```

## GitHub Actions

- **Validate**: Checks syntax on every push
- **Plan**: Creates plan on pull requests
- **Apply**: Applies changes on main branch push

Set `AWS_ROLE_ARN` secret in GitHub for AWS access.

## Files

| File | Purpose |
|------|---------|
| `provider.tf` | AWS provider setup |
| `variables.tf` | Variable definitions |
| `main.tf` | Module integration |
| `terraform.tfvars` | Variable values (edit this) |
| `modules/` | Reusable infrastructure modules |

## Notes

- AWS credentials required (via GitHub Actions secrets or local AWS CLI config)
- Creates real AWS resources - monitor costs
- State file stored locally (enable remote state in provider.tf)

## Resources Created

- 1 VPC with subnets and internet gateway
- 2 security groups (app, database)
- 1 EC2 instance
- 2 S3 buckets with versioning and encryption
