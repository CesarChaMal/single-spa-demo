# Environment Variables Setup

## File Names & Usage

| File | Purpose | Committed to Repo | Used By |
|------|---------|-------------------|---------|
| `.env.example` | Template with placeholder values | ✅ Yes | Documentation |
| `.env` | Your actual credentials | ❌ **NEVER** | Scripts & deployment |

## Setup Steps

1. **Copy the template:**
   ```bash
   cp .env.example .env
   ```

2. **Edit `.env` with your real values:**
   ```bash
   S3_BUCKET=single-spa-demo-774145483743
   AWS_REGION=eu-central-1
   ORG_NAME=cesarchamal
   AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
   AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
   ```

## Scripts That Use These Variables

- `create-github-secrets.sh` - Creates GitHub secrets
- `deploy-to-s3.js` - Deploys to AWS S3
- `setup-deployment.js` - Initial deployment setup

## Security

- ✅ `.env.example` is safe to commit (has placeholder values)
- ❌ `.env` is in `.gitignore` and **NEVER committed**
- 🔒 Real credentials only exist locally

## Loading Environment Variables

```bash
# Load variables for current session
source .env

# Or export them
export $(cat .env | xargs)
```