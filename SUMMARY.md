# Project Summary

This is a **clean and simple** Terraform project for AWS infrastructure.

## What's Included

✅ All 4 Meta-Arguments (count, for_each, depends_on, lifecycle)  
✅ 4 Modules (VPC, Security Groups, EC2, S3)  
✅ AWS Services (VPC, EC2, S3, IAM, CloudWatch)  
✅ GitHub Actions CI/CD  
✅ Environment Support (dev, uat, preprod, prod)  
✅ Terraform Best Practices  

## Essential Files Only

```
provider.tf              - AWS configuration
variables.tf            - Input variables  
outputs.tf              - Output values
main.tf                 - Module integration
terraform.tfvars        - Variable values (EDIT THIS)
README.md               - Documentation
.github/workflows/      - CI/CD pipeline
modules/                - Reusable infrastructure
```

## Start Using It

1. Edit `terraform.tfvars`
2. Run `terraform init`
3. Run `terraform plan`
4. Run `terraform apply`

## Meta-Argument Examples

### COUNT - Multiple VPCs
```hcl
module "vpc" {
  count = var.vpc_count
  # Creates var.vpc_count VPCs
}
```

### FOR_EACH - Security Groups Map
```hcl
module "security_group" {
  for_each = var.security_groups
  # Creates SG for each map entry
}
```

### DEPENDS_ON - Explicit Dependencies
```hcl
module "ec2" {
  depends_on = [module.vpc, module.security_group]
  # Ensures VPC and SG created first
}
```

### LIFECYCLE - Resource Management
```hcl
lifecycle {
  prevent_destroy = false
  ignore_changes = [tags["UpdatedAt"]]
}
```

## GitHub Actions

Automatic validation and deployment:
- **Validate**: On every push
- **Plan**: On pull requests
- **Apply**: On main branch push

Add `AWS_ROLE_ARN` secret for AWS access.

## Cleanup

```bash
terraform destroy
```

---

**That's it! Simple, clear, and ready to use.**
