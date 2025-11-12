# Dynatrace Terraform Provider Documentation

## Provider Overview

**Provider**: `dynatrace-oss/dynatrace`  
**Latest Version**: `1.86.0`  
**Official Support**: Dynatrace officially supports this provider

The Dynatrace Terraform Provider provides resources to interact with the Dynatrace REST API, enabling Infrastructure as Code management of Dynatrace configurations.

## Provider Configuration

### Terraform Configuration
```hcl
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
```

### Authentication Methods

#### 1. API Token Authentication (Recommended)
```bash
export DYNATRACE_ENV_URL="https://########.live.dynatrace.com"  # SaaS
# OR
export DYNATRACE_ENV_URL="https://<dynatrace-host>/e/#####################"  # Managed

export DYNATRACE_API_TOKEN="dt0c01.TOKEN_HERE"
```

**Required API Token Permissions:**
- Read settings (`settings.read`)
- Write settings (`settings.write`)
- Read configuration (`ReadConfig`)
- Write configuration (`WriteConfig`)
- Capture request data (`CaptureRequestData`)
- Create and read synthetic monitors (`ExternalSyntheticIntegration`)
- Create/Read/Write ActiveGate tokens (`activeGateTokenManagement.*`)
- Read/Write API tokens (`apiTokens.*`)
- Read/Write attacks (`attacks.*`)
- Read/Write credential vault entries (`credentialVault.*`)
- Read Entities (`entities.read`)
- Write extensions (`extensions.write`)
- Read/Write extensions environment configuration (`extensionEnvironment.*`)
- Read/Write network zones (`networkZones.*`)
- Read/Write security problems (`securityProblems.*`)
- Read/Write SLO (`slo.*`)

#### 2. OAuth Authentication
```bash
export DT_CLIENT_ID="your-client-id"
export DT_CLIENT_SECRET="your-client-secret"
export DT_ACCOUNT_ID="your-account-id"
export DYNATRACE_HTTP_OAUTH_PREFERENCE=true
```

#### 3. Platform Token Authentication
```bash
export DYNATRACE_PLATFORM_TOKEN="your-platform-token"
export DYNATRACE_HTTP_OAUTH_PREFERENCE=true
```

## Export Utility

The provider includes a standalone export utility for extracting existing configurations:

### Basic Export Commands
```bash
# Export specific resource
./terraform-provider-dynatrace -export RESOURCE_NAME

# Export with state import (same environment)
./terraform-provider-dynatrace -export -import-state RESOURCE_NAME

# Export with references and dependencies
./terraform-provider-dynatrace -export -ref RESOURCE_NAME

# Export with ID comments
./terraform-provider-dynatrace -export -id RESOURCE_NAME

# Export without module structure
./terraform-provider-dynatrace -export -flat RESOURCE_NAME
```

### Export Flags
- `-export`: Basic export functionality
- `-import-state`: Initialize modules and import to Terraform state
- `-ref`: Include data sources and dependencies
- `-migrate`: Include dependencies, exclude data sources
- `-id`: Display commented ID output
- `-flat`: Store resources without module structure
- `-exclude`: Exclude specified resources

## Resource Categories

### Core Configuration (50+ resources)
- `dynatrace_data_privacy`: Data privacy settings
- `dynatrace_management_zone`: Management zones
- `dynatrace_management_zone_v2`: Management zones (v2)
- `dynatrace_alerting_profile`: Alert configurations
- `dynatrace_notification`: Notification configurations
- `dynatrace_credentials`: Credential management

### Monitoring & Detection (100+ resources)
- `dynatrace_host_monitoring`: Host monitoring settings
- `dynatrace_service_detection_rules`: Service detection
- `dynatrace_custom_service`: Custom service definitions
- `dynatrace_process_group_detection`: Process group detection
- `dynatrace_application_detection_rule`: Application detection
- `dynatrace_synthetic_location`: Synthetic monitoring locations
- `dynatrace_browser_monitor`: Browser monitors
- `dynatrace_http_monitor`: HTTP monitors

### Anomaly Detection (30+ resources)
- `dynatrace_host_anomalies`: Host anomaly detection
- `dynatrace_service_anomalies`: Service anomaly detection
- `dynatrace_database_anomalies`: Database anomaly detection
- `dynatrace_disk_anomalies`: Disk anomaly detection
- `dynatrace_aws_anomalies`: AWS anomaly detection
- `dynatrace_k8s_cluster_anomalies`: Kubernetes anomalies

### Cloud Integrations (20+ resources)
- `dynatrace_aws_credentials`: AWS integration
- `dynatrace_azure_credentials`: Azure integration
- `dynatrace_k8s_credentials`: Kubernetes integration
- `dynatrace_cloudfoundry_credentials`: Cloud Foundry integration
- `dynatrace_vmware`: VMware integration

### Dashboards & Reporting (10+ resources)
- `dynatrace_dashboard`: Standard dashboards
- `dynatrace_json_dashboard`: JSON-based dashboards
- `dynatrace_slo`: Service Level Objectives
- `dynatrace_slo_v2`: SLO (v2)
- `dynatrace_report`: Dashboard reports

### Automation & Workflows (15+ resources)
- `dynatrace_automation_workflow`: Workflow automation
- `dynatrace_automation_business_calendar`: Business calendars
- `dynatrace_automation_scheduling_rule`: Scheduling rules
- `dynatrace_maintenance_window`: Maintenance windows

### Security & Vulnerability (20+ resources)
- `dynatrace_attack_alerting`: Attack alerting
- `dynatrace_vulnerability_alerting`: Vulnerability alerts
- `dynatrace_security_context`: Security contexts
- `dynatrace_attack_settings`: Attack protection settings

### Log Management (15+ resources)
- `dynatrace_log_processing`: Log processing rules
- `dynatrace_log_events`: Log event detection
- `dynatrace_log_metrics`: Log-based metrics
- `dynatrace_log_storage`: Log storage configuration

### OpenPipeline (30+ resources)
- `dynatrace_openpipeline_logs`: Log pipeline configuration
- `dynatrace_openpipeline_metrics`: Metrics pipeline
- `dynatrace_openpipeline_events`: Events pipeline
- `dynatrace_openpipeline_spans`: Spans pipeline

### User Management (10+ resources)
- `dynatrace_user`: User configuration
- `dynatrace_user_group`: User groups
- `dynatrace_iam_group`: IAM groups (SaaS)
- `dynatrace_iam_policy`: IAM policies (SaaS)

### Notification Integrations (15+ resources)
- `dynatrace_slack_notification`: Slack integration
- `dynatrace_email_notification`: Email notifications
- `dynatrace_pager_duty_notification`: PagerDuty integration
- `dynatrace_jira_notification`: Jira integration
- `dynatrace_webhook_notification`: Webhook notifications

## Troubleshooting

### Debug Logging
```bash
export DYNATRACE_DEBUG=true
export DYNATRACE_LOG_HTTP=terraform-provider-dynatrace.http.log
export DYNATRACE_HTTP_RESPONSE=true
```

### Common Issues
1. **Authentication Errors**: Verify environment variables and token permissions
2. **Export Failures**: Check resource names against supported resources list
3. **State Import Issues**: Ensure proper resource IDs and state management

## Documentation Links
- [Official Dynatrace Terraform Documentation](https://dt-url.net/3s63qyj)
- [Export Utility Documentation](https://dt-url.net/h203qmc)
- [Terraform Registry](https://registry.terraform.io/providers/dynatrace-oss/dynatrace/latest/docs)
- [GitHub Repository](https://github.com/dynatrace-oss/terraform-provider-dynatrace)

## Total Resources Available
**400+ resources** covering comprehensive Dynatrace configuration management across all major functional areas.
