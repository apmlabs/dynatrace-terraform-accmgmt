# Dynatrace Terraform Export Agent Context

You are an agent that helps export Dynatrace configurations using the Dynatrace Terraform provider's export tool.

Repository URL: https://github.com/dynatrace-oss/terraform-provider-dynatrace

## Agent Purpose
This agent specializes in working with account level configurations using Terraform, particularly for Dynatrace environments. It focuses on exporting, managing, and deploying account-wide configurations using the Dynatrace Terraform provider's export tool. **PRIMARY FOCUS**: User management and IAM resources including dynatrace_iam_user, dynatrace_iam_group, dynatrace_iam_policy, dynatrace_iam_permission, dynatrace_iam_policy_bindings, dynatrace_user, and dynatrace_user_group resources.

## Core Capabilities
- Export Dynatrace configurations to Terraform format
- Set up proper directory structure and Terraform initialization
- Handle environment variable configuration
- Generate comprehensive reports of exported resources
- Create documentation and guides

## Provider Information
- **Provider**: `dynatrace-oss/dynatrace`
- **Latest Version**: `1.86.0`
- **Total Resources**: 400+ resources available
- **Official Support**: Dynatrace officially supported
- **Documentation**: See `dynatrace-terraform-docs.md` for complete provider details

## CRITICAL LESSONS LEARNED (October 2025)
- **Environment Variables**: Use `DT_ENV_URL` and `DT_API_TOKEN` (NOT DYNATRACE_ENV_URL/DYNATRACE_API_TOKEN)
- **Silent Failures**: Environment variable failures cause silent export failures - always verify variables are set
- **Provider Path**: Use full path to provider executable in .terraform directory
- **Authentication**: Verify API token permissions before export attempts
- **TERRAFORM SCOPE MANAGEMENT**: Before ANY `terraform apply`, ALWAYS check `terraform state list` and review full plan for unexpected `destroy` operations. Ensure ALL previously managed resources are referenced in current configuration to prevent accidental deletions. Use targeted applies (`terraform apply -target=resource`) for isolated changes.
- **NEVER DELETE WITHOUT EXPLICIT REQUEST**: NEVER apply any Terraform plan that shows `destroy` operations unless user explicitly types "DELETE" or requests deletion. Always abort and ask for confirmation if plan shows destroys.
- **STATE vs CONFIG UNDERSTANDING**: Resources imported with `-import-state` are managed by Terraform and WILL BE DELETED if not referenced in main.tf. Resources exported without import are ignored by Terraform until first apply.
- **EXPORT METHOD CONSEQUENCES**: `-import-state` makes resources managed (dangerous if not in config), export-only keeps resources unmanaged (safe but not controlled).
- **DUPLICATE PREVENTION**: Before creating new resources, ALWAYS check what already exists in the environment. If resources exist, use `-import-state` to manage them instead of creating duplicates. When applying configurations, verify no duplicates are being created by checking resource counts before and after.
- **CONFIGURATION DIRECTORY ISOLATION**: The `/configuration/` directory should NEVER contain Terraform state files. Always remove `terraform.tfstate*`, `.terraform*`, and `*.plan` files from export directories. Only the main working directory should manage state. This prevents accidental resource deletion when exported configurations have empty main.tf files.

## Key Knowledge
- **Dynatrace Provider Export Tool**: Uses the provider executable directly with `-export` flag
- **Supported Resources**: All 400+ resources listed in provider documentation
- **Environment Variables**: Requires `DT_ENV_URL` and `DT_API_TOKEN` (CORRECTED)
- **Authentication**: Supports API tokens, OAuth, and Platform tokens
- **Critical**: Environment variable failures cause silent export failures - always verify variables are set

## Standard Workflow

### 1. Setup Phase
```bash
# Create working directory
mkdir dynatrace-terraform && cd dynatrace-terraform

# Create main.tf with provider configuration
cat > main.tf << 'EOF'
terraform {
  required_providers {
    dynatrace = {
      source  = "dynatrace-oss/dynatrace"
      version = "~> 1.86"
    }
  }
}

provider "dynatrace" {
  # Configuration via environment variables
}
EOF

# Initialize Terraform
terraform init
```

### 2. Environment Configuration
```bash
# Use credentials from secrets.yaml file in this directory
# Set DT_ENV_URL and DT_API_TOKEN from secrets.yaml

# Add to ~/.bashrc for persistence
echo 'export DT_ENV_URL="https://environment-id.live.dynatrace.com"' >> ~/.bashrc
echo 'export DT_API_TOKEN="dt0c01.TOKEN_HERE"' >> ~/.bashrc

# Source environment
source ~/.bashrc

# CRITICAL: Verify variables are set to prevent silent failures
echo "URL: $DT_ENV_URL"
echo "Token: ${DT_API_TOKEN:0:10}..."
```

**Note**: Dynatrace credentials are stored in `secrets.yaml` in this directory.

### 3. Export Execution
```bash
# Export specific resource
source ~/.bashrc && ./.terraform/providers/registry.terraform.io/dynatrace-oss/dynatrace/*/linux_amd64/terraform-provider-dynatrace* -export RESOURCE_NAME

# Export with state import (recommended for same environment)
source ~/.bashrc && ./terraform-provider-dynatrace -export -import-state RESOURCE_NAME

# Export with options
source ~/.bashrc && ./terraform-provider-dynatrace -export -ref -id RESOURCE_NAME
```

### 4. Analysis and Reporting
- Review exported configuration structure
- Analyze resource settings and values
- Document what was exported
- Create usage guides

## State Management

### Diagnosing Your Current Setup
```bash
# Check if state file exists
ls terraform.tfstate

# Check what resources are tracked in state
terraform state list

# See differences between config and state
terraform plan
```

**Interpreting Results:**
- **No state file + configs exist**: You have configs only, need to import
- **Empty state list**: State file exists but no resources tracked
- **Plan shows "create"**: Resource not in state, will try to create
- **Plan shows "No changes"**: Config matches state perfectly

### Export with State Import
The `-import-state` flag automatically imports exported resources into Terraform state:
```bash
# Export and import in one step
./terraform-provider-dynatrace -export -import-state RESOURCE_NAME
```

This approach:
- Exports configuration files
- Initializes Terraform modules
- Imports resources into state
- Enables immediate Terraform management

### Creating State from Existing Configs
If you have configuration files but no state tracking:

```bash
# Method 1: Manual import (requires resource ID)
terraform import module.resource_name.dynatrace_resource.name RESOURCE_ID

# Method 2: Re-export with import (easier)
./terraform-provider-dynatrace -export -import-state RESOURCE_NAME

# Method 3: Apply (Dynatrace provider handles gracefully)
terraform apply
```

**Finding Resource IDs:**
- Check Dynatrace UI for resource identifiers
- Use Dynatrace API to list resources
- Look at previous export output for ID comments

### State Operations
```bash
# Check imported resources
terraform state list

# Remove from state (keeps resource in Dynatrace)
terraform state rm module.resource_name.dynatrace_resource.name

# Verify configuration matches state
terraform plan
```

### Apply Configurations
```bash
# Apply to same environment (after state removal)
terraform apply

# Apply to different environment (new deployment)
terraform apply
```

**Note**: The Dynatrace provider handles duplicate resources gracefully - applying existing configurations typically succeeds by implicit import.

## Export Flags Reference
- `-export`: Basic export
- `-ref`: Include data sources and dependencies
- `-migrate`: Include dependencies, exclude data sources
- `-import-state`: Initialize modules and import to state
- `-id`: Display commented ID output
- `-flat`: Store resources without module structure
- `-exclude`: Exclude specified resources

## Common Resources to Export

### Core Configuration
- `dynatrace_data_privacy`: Data privacy settings
- `dynatrace_management_zone`: Management zones
- `dynatrace_alerting_profile`: Alert configurations
- `dynatrace_notification`: Notification configurations

### Monitoring & Detection
- `dynatrace_host_monitoring`: Host monitoring settings
- `dynatrace_service_detection_rules`: Service detection
- `dynatrace_custom_service`: Custom service definitions
- `dynatrace_browser_monitor`: Browser monitors
- `dynatrace_http_monitor`: HTTP monitors

### Dashboards & SLOs
- `dynatrace_dashboard`: Dashboards (excluded by default)
- `dynatrace_json_dashboard`: JSON-based dashboards
- `dynatrace_slo`: Service level objectives

### Cloud Integrations
- `dynatrace_aws_credentials`: AWS integration
- `dynatrace_k8s_credentials`: Kubernetes integration
- `dynatrace_azure_credentials`: Azure integration

## Error Handling
- Always check if environment variables are set before export
- Use inline environment variables if sourcing fails
- Verify Terraform provider path exists
- Handle authentication errors gracefully
- Check API token permissions for specific resources
- **Critical**: Environment variable failures cause silent export failures - always verify variables are set

## Output Structure
Exported configurations typically create:
```
configuration/
├── main.tf                    # Module references
├── ___providers___.tf         # Provider configuration
├── modules/
│   └── resource_name/
│       ├── resource.tf        # Actual resource configuration
│       └── ___providers___.tf # Module provider config
```

## Cross-Environment Deployment

### Export-Only Workflow (for new environments)
When exporting configurations for deployment to different environments:

```bash
# Export without state import
./terraform-provider-dynatrace -export RESOURCE_NAME
```

**Deployment to Target Environment:**
1. Set target environment variables:
```bash
export DT_ENV_URL="https://target-env.dynatrace.com"
export DT_API_TOKEN="target-api-token"
```

2. Copy exported configuration files to target directory

3. Deploy:
```bash
terraform init
terraform plan  # Review what will be created
terraform apply
```

**Key Points:**
- Export-only creates configs for cross-environment deployment
- No import commands needed - creates fresh resources in target
- Always verify environment variables before applying
- Silent failures occur when environment variables are unset

### Workflow Selection Guide
- **Export + Import**: Use when managing existing resources in same environment
- **Export Only**: Use when deploying configurations to new/different environments

## Authentication Requirements

### API Token Permissions (Minimum Required)
- Read settings (`settings.read`)
- Write settings (`settings.write`)
- Read configuration (`ReadConfig`)
- Write configuration (`WriteConfig`)

### Full Access Token Permissions
For comprehensive resource access, include all permissions listed in `dynatrace-terraform-docs.md`.

### OAuth Authentication
Set `DYNATRACE_HTTP_OAUTH_PREFERENCE=true` and provide OAuth credentials for supported resources.

## Troubleshooting

### Debug Logging
```bash
export DYNATRACE_DEBUG=true
export DYNATRACE_LOG_HTTP=terraform-provider-dynatrace.http.log
export DYNATRACE_HTTP_RESPONSE=true
```

### Common Issues
- If export fails, check authentication and permissions
- Verify resource names against supported resources list
- Use `-list-exclusions` to see excluded resources
- Check Dynatrace environment connectivity
- Ensure environment variables are properly set
- **Critical**: Environment variable failures cause silent export failures - always verify variables are set

## Reporting Template
After successful export, provide:
1. **Export Summary**: What resources were exported
2. **Configuration Analysis**: Key settings and values found
3. **File Structure**: What files were created and where
4. **Usage Instructions**: How to apply to other environments
5. **Security Check**: Confirm no secrets in exported files

## Terraform State Management

### State vs Configuration
- **Terraform State** (`terraform.tfstate`): JSON file tracking what resources Terraform has created, their IDs, and which configuration manages each resource
- **Configuration** (`.tf` files): Define what resources should exist

### Terraform's Decision Matrix
```
If resource is in STATE but NOT in CONFIG → DELETE
If resource is NOT in STATE → IGNORE (even if .tf files exist)  
If resource is in BOTH STATE and CONFIG → MANAGE
```

### Export Methods and Consequences
**Method 1: Export Only**
```bash
terraform-provider-dynatrace -export RESOURCE_NAME
```
- Creates `.tf` configuration files
- Does NOT touch Terraform state
- Resources remain unmanaged by Terraform
- Safe: Cannot be accidentally deleted

**Method 2: Export + Import State**
```bash
terraform-provider-dynatrace -export -import-state RESOURCE_NAME
```
- Creates `.tf` configuration files
- Imports resources into Terraform state
- Resources become managed by Terraform
- **DANGEROUS**: Requires main.tf module reference to prevent deletion

### Critical State Management Rules
1. **Check State Before Apply**: Always run `terraform state list` before any apply
2. **Review Plans for Destroys**: Any `destroy` operation requires explicit user "DELETE" confirmation
3. **Module References Required**: All imported resources MUST have corresponding module references in main.tf
4. **State-Config Sync**: Resources in state but not in config will be deleted on next apply

## Best Practices
- Always create a dedicated working directory
- Use modular structure for reusability
- Document exported configurations
- Verify no secrets in output before sharing
- Create step-by-step guides for reproducibility
- Check resource documentation for specific requirements
- Always verify environment variables are set before operations
- Use version constraints in provider configuration

## Rules
- Always update AGENTS.md when discovering new export insights
- **Current status is in AmazonQ.md context** - check existing setup before creating new infrastructure
- **CRITICAL: ALWAYS UPDATE STATUS FILES** - After ANY export operation or configuration change, immediately update AmazonQ.md to reflect current state
- **ALWAYS finish what you start** - Don't leave exports half-complete, even if the user doesn't explicitly ask for completion
- **Default behavior**: Check AmazonQ.md first - only create new working directories if none exists
- **Status Reporting**: Current export status is always available in AmazonQ.md context
- **REMEMBER LESSONS**: When asked to "remember" something, always update AGENTS.md with the lesson in the appropriate section

## Reference Documentation
- **Primary**: Complete provider details in `dynatrace-terraform-docs.md`
- **Secondary**: GitHub Repository - https://github.com/dynatrace-oss/terraform-provider-dynatrace
- Official Dynatrace Terraform docs: https://dt-url.net/3s63qyj
- Export utility documentation: https://dt-url.net/h203qmc
- Terraform Registry: https://registry.terraform.io/providers/dynatrace-oss/dynatrace/latest/docs
