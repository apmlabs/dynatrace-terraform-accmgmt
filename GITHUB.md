# GitHub Repository Setup Guide

This guide shows how to create a private GitHub repository from your local project while protecting sensitive information.

## Critical Git Rules

**ALWAYS check .gitignore before committing!** These files must NEVER be committed:
- `secrets.yaml` - contains Dynatrace credentials
- `*.tfstate` files - contains Terraform state with sensitive data
- `*.tfvars` files - may contain sensitive variables
- AWS credentials and environment files

## Step 1: Create .gitignore File

Create a `.gitignore` file to protect sensitive data:

```bash
cat > .gitignore << 'EOF'
# Sensitive files
secrets.yaml
*.tfvars
*.tfvars.json

# Terraform state files
*.tfstate
*.tfstate.*
.terraform/
.terraform.lock.hcl

# AWS credentials
.aws/
aws-credentials*

# Environment files
.env
.env.local
.env.production

# Logs
*.log
logs/

# Temporary files
*.tmp
*.temp
.DS_Store
Thumbs.db

# IDE files
.vscode/
.idea/
*.swp
*.swo

# Dynamic status files
AmazonQ.md
EOF
```

## Step 2: Initialize Git Repository

```bash
# Initialize git repository
git init

# Check what files will be tracked (secrets.yaml and AmazonQ.md should NOT appear)
git status

# Add all files
git add .

# Make initial commit
git commit -m "Initial commit: Dynatrace Terraform export tools and documentation"
```

## Step 3: Create Private GitHub Repository

### Option A: Using GitHub CLI (if available)
```bash
# Create private repository
gh repo create dynatrace-terraform --private --description "Dynatrace Terraform export tools and documentation"

# Push code
git push -u origin main
```

### Option B: Manual Creation
1. Go to https://github.com/new
2. Repository name: `dynatrace-terraform`
3. Set to **Private**
4. Don't initialize with README (you already have one)
5. Click "Create repository"

Then push your code:
```bash
# Add remote (replace YOUR_USERNAME)
git remote add origin https://github.com/YOUR_USERNAME/dynatrace-terraform.git

# Push code
git branch -M main
git push -u origin main
```

## Verification

After pushing, verify that sensitive files are protected:

1. Check your GitHub repository - `secrets.yaml` and `AmazonQ.md` should NOT be visible
2. Verify `.gitignore` is working: `git status` should not show ignored files
3. Confirm repository is private in GitHub settings

## Important Security Notes

- **Never commit secrets.yaml** - contains sensitive Dynatrace credentials
- **Never commit *.tfstate files** - contains Terraform state with sensitive data
- **Never commit AmazonQ.md** - dynamic status file
- **Always verify .gitignore** before first commit
- **Keep repository private** for security

## Future Updates

To update the repository:
```bash
# Always check .gitignore first!
git status

# Add only non-ignored files
git add .

# Commit changes
git commit -m "Description of changes"

# Push to remote
git push
```

The .gitignore will continue protecting sensitive files automatically.
