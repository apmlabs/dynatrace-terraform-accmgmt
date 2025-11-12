terraform {
  required_providers {
    dynatrace = {
      source  = "dynatrace-oss/dynatrace"
      version = "~> 1.86"
    }
  }
}

provider "dynatrace" {
  # Account management configuration
  # Uses DT_ENV_URL and DT_API_TOKEN environment variables
}

# This is the root configuration for Dynatrace account management
# Account-level resources are managed in ./dynatrace-terraform-accmgmt/
# Environment-level resources are safely stored in ./dynatrace-env-configs-backup/
