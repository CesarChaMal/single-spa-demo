# GitHub Secrets Setup

To set up GitHub Actions deployment, you need to configure these secrets in your GitHub repository:

## How to Add Secrets

1. Go to your GitHub repository
2. Click **Settings** tab
3. Click **Secrets and variables** → **Actions**
4. Click **New repository secret**
5. Add each secret below:

## Required Secrets

| Secret Name | Description | Example Value |
|-------------|-------------|---------------|
| `AWS_ACCESS_KEY_ID` | Your AWS Access Key ID | `AKIAIOSFODNN7EXAMPLE` |
| `AWS_SECRET_ACCESS_KEY` | Your AWS Secret Access Key | `wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY` |
| `S3_BUCKET` | Your S3 bucket name | `single-spa-demo-774145483743` |
| `AWS_REGION` | AWS region (optional) | `eu-central-1` |
| `ORG_NAME` | Organization name (optional) | `cesarchamal` |

## Getting AWS Credentials

1. Go to AWS IAM Console
2. Create new user with S3 full access
3. Generate Access Key ID and Secret Access Key
4. Copy these values to GitHub secrets

## Default Values

If not set, these defaults will be used:
- `AWS_REGION`: `eu-central-1`
- `ORG_NAME`: `cesarchamal`