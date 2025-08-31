# GitHub Secrets via API

## Prerequisites

1. **GitHub Personal Access Token** with `repo` scope
   - Go to GitHub → Settings → Developer settings → Personal access tokens
   - Generate new token with `repo` permissions

2. **Install jq** (JSON processor)
   ```bash
   # Windows (chocolatey)
   choco install jq
   
   # macOS
   brew install jq
   
   # Linux
   sudo apt install jq
   ```

## Usage

### Option 1: Shell Script (Recommended)
```bash
chmod +x setup-github-secrets.sh
./setup-github-secrets.sh
```

### Option 2: Node.js Script
```bash
node setup-github-secrets.js
```

### Option 3: Manual curl Commands

1. **Get repository public key:**
```bash
curl -H "Authorization: token YOUR_TOKEN" \
  https://api.github.com/repos/OWNER/REPO/actions/secrets/public-key
```

2. **Create secret (simplified):**
```bash
curl -X PUT \
  -H "Authorization: token YOUR_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/repos/OWNER/REPO/actions/secrets/SECRET_NAME \
  -d '{"encrypted_value":"BASE64_ENCRYPTED_VALUE","key_id":"KEY_ID"}'
```

## Required Secrets

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `S3_BUCKET`
- `AWS_REGION`
- `ORG_NAME`

## Security Note

⚠️ **The provided scripts use simplified encryption for demo purposes.**

For production, use proper **libsodium sealed box encryption** with the repository's public key.

Consider using:
- [@octokit/rest](https://www.npmjs.com/package/@octokit/rest) for Node.js
- [GitHub CLI](https://cli.github.com/) for command line