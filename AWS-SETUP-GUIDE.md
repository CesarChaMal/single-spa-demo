# AWS Setup Guide

## What is ORG_NAME?

**ORG_NAME** is simply a namespace/prefix for organizing your microfrontends. It's like a folder name in your S3 bucket.

### Examples:
- `ORG_NAME=mycompany` → `@mycompany/nav`, `@mycompany/page-1`
- `ORG_NAME=johnsmith` → `@johnsmith/nav`, `@johnsmith/page-1`
- `ORG_NAME=myproject` → `@myproject/nav`, `@myproject/page-1`

### What it does:
1. **Import Map Names**: `@yourorg/nav` instead of `@cesarchamal/nav`
2. **S3 Folder Structure**: `s3://bucket/@yourorg/nav/` instead of `s3://bucket/@cesarchamal/nav/`
3. **Bundle URLs**: `https://bucket.s3.amazonaws.com/@yourorg/nav/commit/bundle.js`

## Get Your AWS Information

Run this script to get your AWS details:

**Windows:**
```bash
get-aws-info.bat
```

**Unix/Linux/macOS:**
```bash
./get-aws-info.sh
```

## Typical AWS Setup

### 1. AWS Account ID
- **What it is**: Your unique AWS account identifier (12 digits)
- **Example**: `123456789012`
- **Used for**: Creating unique S3 bucket names

### 2. AWS Region
- **What it is**: Geographic location for your AWS resources
- **Examples**: `eu-central-1`, `us-west-2`, `eu-west-1`
- **Used for**: S3 bucket location and URLs

### 3. S3 Bucket Name
- **Recommendation**: `single-spa-demo-{your-account-id}`
- **Example**: `single-spa-demo-123456789012`
- **Why unique**: S3 bucket names must be globally unique

### 4. Organization Name
- **Recommendation**: Your GitHub username or company name
- **Examples**: `mycompany`, `johnsmith`, `acmecorp`
- **Used for**: Namespacing your microfrontends

## Example Configuration

If your AWS account ID is `123456789012` and your name is `johnsmith`:

```env
S3_BUCKET=single-spa-demo-123456789012
AWS_REGION=us-west-2
ORG_NAME=johnsmith
AWS_ACCESS_KEY_ID=AKIA...
AWS_SECRET_ACCESS_KEY=...
```

This creates:
- **S3 Bucket**: `single-spa-demo-123456789012`
- **Import Map**: `@johnsmith/nav`, `@johnsmith/page-1`
- **URLs**: `https://single-spa-demo-123456789012.s3-us-west-2.amazonaws.com/@johnsmith/nav/abc123/bundle.js`

## Quick Setup Steps

1. **Get AWS info**: Run `get-aws-info.bat` or `get-aws-info.sh`
2. **Setup deployment**: Run `npm run deploy:setup`
3. **Use recommended values** from the script output
4. **Deploy**: Run `npm run deploy:all`

## Troubleshooting

**"Could not get AWS Account ID"**
- Run `aws configure` to set up AWS CLI
- Provide your Access Key ID and Secret Access Key

**"Bucket already exists"**
- Choose a different bucket name
- Add your account ID to make it unique

**"Access Denied"**
- Check your AWS credentials have S3 permissions
- Ensure IAM user has `AmazonS3FullAccess` policy