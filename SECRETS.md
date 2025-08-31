# GitHub Secrets Setup

## Quick Setup Methods

### Method 1: Automated Script (Recommended)
```bash
# Using GitHub CLI (proper encryption)
bash create-secrets-gh.sh
# or
create-github-secrets.bat
```

### Method 2: Manual Setup
1. Go to: https://github.com/CesarChaMal/single-spa-demo/settings/secrets/actions
2. Click **New repository secret**
3. Add these 5 secrets:

| Secret Name | Description | Value |
|-------------|-------------|-------|
| `AWS_ACCESS_KEY_ID` | Your AWS Access Key ID | Your AWS access key |
| `AWS_SECRET_ACCESS_KEY` | Your AWS Secret Access Key | Your AWS secret key |
| `S3_BUCKET` | Your S3 bucket name | `single-spa-demo-774145483743` |
| `AWS_REGION` | AWS region | `eu-central-1` |
| `ORG_NAME` | Organization name | `cesarchamal` |

### Method 3: GitHub CLI
```bash
gh secret set AWS_ACCESS_KEY_ID --body "YOUR_KEY"
gh secret set AWS_SECRET_ACCESS_KEY --body "YOUR_SECRET"
gh secret set S3_BUCKET --body "single-spa-demo-774145483743"
gh secret set AWS_REGION --body "eu-central-1"
gh secret set ORG_NAME --body "cesarchamal"
```

## Getting AWS Credentials

1. **Go to AWS IAM Console**: https://console.aws.amazon.com/iam/
2. **Create new user** with S3 full access permissions
3. **Generate Access Key ID and Secret Access Key**
4. **Copy these values** to use in GitHub secrets

## Verification

**Check secrets exist:**
```bash
bash check-github-secrets.sh
```

**Test in GitHub Actions:**
1. Go to Actions tab in your repository
2. Run "Debug Secrets" workflow manually
3. Check output shows correct values

## Troubleshooting

**"Credentials could not be loaded"**
→ Secrets are empty or incorrectly encrypted
→ Use automated scripts for proper encryption

**"Access Denied"** 
→ AWS credentials are invalid or expired
→ Verify credentials with: `bash test-aws-credentials.sh`

**Workflows not triggering**
→ Make changes in microfrontend directories, not root
→ Check workflow path filters in `.github/workflows/`

## Default Values

If not set, these defaults will be used:
- `AWS_REGION`: `eu-central-1`
- `ORG_NAME`: `cesarchamal`