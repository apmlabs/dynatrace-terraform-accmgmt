# Amazon Q CLI Agent Instructions: Dynatrace Terraform Export

## Purpose
This agent specializes in exporting Dynatrace configurations using the Dynatrace Terraform provider's export tool. It can export any supported Dynatrace resource and create reusable Terraform modules.

## Core Capabilities
- Export Dynatrace configurations to Terraform format
- Set up proper directory structure and Terraform initialization
- Handle environment variable configuration
- Generate comprehensive reports of exported resources
- Create documentation and guides

## Key Knowledge
- **Dynatrace Provider Export Tool**: Uses the provider executable directly with `-export` flag
- **Supported Resources**: All resources listed at https://github.com/dynatrace-oss/terraform-provider-dynatrace/blob/main/documentation/supported-resources.md
- **Documentation**: Full resource docs at https://github.com/dynatrace-oss/terraform-provider-dynatrace/tree/main/docs
- **Environment Variables**: Requires `DT_ENV_URL` and `DT_API_TOKEN`

## Standard Workflow

### 1. Setup Phase
```bash
# Create working directory
mkdir dynatrace-terraform && cd dynatrace-terraform

# Create main.tf with provider configuration
terraform {
  required_providers {
    dynatrace = {
      source  = "dynatrace-oss/dynatrace"
      version = "~> 1.0"
    }
  }
}

provider "dynatrace" {
  # Configuration via environment variables
}

# Initialize Terraform
terraform init
```

### 2. Environment Configuration
```bash
# Add to ~/.bashrc
export DT_ENV_URL="https://environment-id.live.dynatrace.com"
export DT_API_TOKEN="dt0c01.TOKEN_HERE"

# Source environment
source ~/.bashrc
```

### 3. Export Execution
```bash
# Export specific resource
source ~/.bashrc && ./.terraform/providers/registry.terraform.io/dynatrace-oss/dynatrace/VERSION/linux_amd64/terraform-provider-dynatrace_VERSION -export RESOURCE_NAME

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
- `-export`: Basic export
- `-ref`: Include data sources and dependencies
- `-migrate`: Include dependencies, exclude data sources
- `-import-state`: Initialize modules and import to state
- `-id`: Display commented ID output
- `-flat`: Store resources without module structure
- `-exclude`: Exclude specified resources

## Common Resources to Export
- `dynatrace_data_privacy`: Data privacy settings
- `dynatrace_alerting_profile`: Alert configurations
- `dynatrace_management_zone`: Management zones
- `dynatrace_dashboard`: Dashboards (excluded by default)
- `dynatrace_slo`: Service level objectives
- `dynatrace_notification`: Notification configurations

## Error Handling
- Always check if environment variables are set before export
- Use inline environment variables if sourcing fails
- Verify Terraform provider path exists
- Handle authentication errors gracefully

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

## Reporting Template
After successful export, provide:
1. **Export Summary**: What resources were exported
2. **Configuration Analysis**: Key settings and values found
3. **File Structure**: What files were created and where
4. **Usage Instructions**: How to apply to other environments
5. **Security Check**: Confirm no secrets in exported files

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

## Best Practices
- Always create a dedicated working directory
- Use modular structure for reusability
- Document exported configurations
- Verify no secrets in output before sharing
- Create step-by-step guides for reproducibility
- Check resource documentation for specific requirements
- Always verify environment variables are set before operations

## Authentication Requirements
- Platform token or OAuth client with appropriate permissions
- Permissions depend on resources being exported
- Refer to API documentation for specific permission requirements

## Troubleshooting
- If export fails, check authentication and permissions
- Verify resource names against supported resources list
- Use `-list-exclusions` to see excluded resources
- Check Dynatrace environment connectivity

## Reference Links
- Supported Resources: https://github.com/dynatrace-oss/terraform-provider-dynatrace/blob/main/documentation/supported-resources.md
- Resource Documentation: https://github.com/dynatrace-oss/terraform-provider-dynatrace/tree/main/docs
- Terraform Registry: https://registry.terraform.io/providers/dynatrace-oss/dynatrace/latest/docs
