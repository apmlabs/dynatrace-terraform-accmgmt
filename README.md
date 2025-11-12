# Dynatrace Terraform Account Management

Terraform configurations for managing Dynatrace account-level resources including IAM users, groups, policies, and permissions.

## Overview

This repository focuses exclusively on account-level management resources:
- IAM Users (`dynatrace_iam_user`)
- IAM Groups (`dynatrace_iam_group`) 
- IAM Policies (`dynatrace_iam_policy`)
- IAM Permissions (`dynatrace_iam_permission`)
- IAM Policy Bindings (`dynatrace_iam_policy_bindings`)
- User Management (`dynatrace_user`)
- User Groups (`dynatrace_user_group`)

## Quick Start

### Prerequisites
- Terraform >= 1.0
- Dynatrace API token with account management permissions
- Access to Dynatrace account management APIs

### Setup
```bash
# Clone repository
git clone https://github.com/YOUR_USERNAME/dynatrace-terraform-accmgmt.git
cd dynatrace-terraform-accmgmt

# Set environment variables
export DT_ENV_URL="https://your-tenant.dynatrace.com"
export DT_API_TOKEN="dt0c01.YOUR_TOKEN_HERE"

# Initialize Terraform
terraform init

# Plan changes
terraform plan

# Apply changes
terraform apply
```

## Configuration

### Environment Variables
```bash
export DT_ENV_URL="https://your-tenant.dynatrace.com"
export DT_API_TOKEN="dt0c01.YOUR_TOKEN_HERE"
```

### Provider Configuration
The Dynatrace provider is configured to use environment variables for authentication:

```hcl
terraform {
  required_providers {
    dynatrace = {
      source  = "dynatrace-oss/dynatrace"
      version = "~> 1.86"
    }
  }
}

provider "dynatrace" {
  # Uses DT_ENV_URL and DT_API_TOKEN environment variables
}
```

## Security

- Never commit `secrets.yaml` or credential files
- Use environment variables for sensitive data
- Review `.gitignore` to ensure secrets are excluded
- Verify exported configurations contain no hardcoded credentials

## Documentation

- **[AGENTS.md](./AGENTS.md)** - Detailed agent instructions and workflows
- **[dynatrace-terraform-docs.md](./dynatrace-terraform-docs.md)** - Complete provider documentation

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

MIT License - see LICENSE file for details
