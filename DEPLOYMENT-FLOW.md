# Deployment Flow Explanation

## File Relationships

### Travis CI (Original)
```
.travis.yml → after_deploy.sh → update-importmap.mjs → S3
```

### GitHub Actions (New)
```
github-deploy.yml → after_deploy.sh → update-importmap.mjs → S3
```

## Detailed Flow

### 1. CI/CD Trigger (.travis.yml vs github-deploy.yml)
**Travis CI:**
```yaml
script:
  - yarn build
  - mkdir -p dist/@org/app/$TRAVIS_COMMIT
  - mv dist/*.* dist/@org/app/$TRAVIS_COMMIT/
after_deploy:
  - ./after_deploy.sh
```

**GitHub Actions:**
```yaml
- name: Build
  run: npm run build
- name: Deploy
  run: |
    export GITHUB_SHA=${{ github.sha }}
    ./after_deploy.sh
```

### 2. Deployment Script (after_deploy.sh)
**Purpose:** Orchestrates the deployment process
```bash
# 1. Check/create S3 bucket
# 2. Deploy built files with commit SHA folder structure
# 3. Download current import map
# 4. Update import map with new version
# 5. Upload updated import map
```

**Key Changes:**
- Travis: Uses `$TRAVIS_COMMIT`
- GitHub: Uses `$GITHUB_SHA` (mapped to `TRAVIS_COMMIT` for compatibility)

### 3. Import Map Updater (update-importmap.mjs)
**Purpose:** Updates the central import map with new bundle URL

**Process:**
1. **Build URL:** `https://bucket.s3-region.amazonaws.com/@org/app/commit-sha/bundle.js`
2. **Verify:** Makes HTTPS request to ensure file exists
3. **Update:** Modifies importmap.json with new URL
4. **Save:** Writes updated import map to disk

**Environment Variables Used:**
- `S3_BUCKET` - Your S3 bucket name
- `AWS_REGION` - AWS region
- `ORG_NAME` - Organization name for namespacing
- `TRAVIS_COMMIT` or `GITHUB_SHA` - Commit hash for versioning

## Import Map Structure

### Before Deployment:
```json
{
  "imports": {
    "@myorg/nav": "https://mybucket.s3.amazonaws.com/@myorg/nav/abc123/bundle.js",
    "@myorg/page-1": "https://mybucket.s3.amazonaws.com/@myorg/page-1/def456/bundle.js"
  }
}
```

### After Page-1 Deployment:
```json
{
  "imports": {
    "@myorg/nav": "https://mybucket.s3.amazonaws.com/@myorg/nav/abc123/bundle.js",
    "@myorg/page-1": "https://mybucket.s3.amazonaws.com/@myorg/page-1/xyz789/bundle.js"
  }
}
```

## S3 Folder Structure

```
s3://your-bucket/
├── @yourorg/
│   ├── root-config/
│   │   ├── abc123/
│   │   │   └── root-config.js
│   │   └── def456/
│   │       └── root-config.js
│   ├── single-spa-demo-nav/
│   │   ├── abc123/
│   │   │   └── yourorg-single-spa-demo-nav.js
│   │   └── def456/
│   │       └── yourorg-single-spa-demo-nav.js
│   └── importmap.json
```

## Key Differences: Travis vs GitHub Actions

| Aspect | Travis CI | GitHub Actions |
|--------|-----------|----------------|
| **Trigger File** | `.travis.yml` | `.github/workflows/deploy.yml` |
| **Commit Variable** | `$TRAVIS_COMMIT` | `$GITHUB_SHA` |
| **Environment** | Travis CI servers | GitHub runners |
| **Secrets** | Travis dashboard | GitHub repository secrets |
| **Cost** | Paid service | Free (2000 min/month) |
| **Setup** | External service | Built into GitHub |

## Benefits of New Flow

1. **Free:** GitHub Actions is free for public repos
2. **Integrated:** No external CI service needed
3. **Flexible:** Easy to customize workflows
4. **Secure:** Secrets managed in GitHub
5. **Fast:** Runs on GitHub's infrastructure

## Troubleshooting

**Import map not updating?**
- Check `update-importmap.mjs` can reach the deployed file
- Verify S3 bucket has public read permissions
- Ensure CORS is configured on S3 bucket

**Deployment failing?**
- Check AWS credentials in GitHub secrets
- Verify S3 bucket exists and has correct permissions
- Check `after_deploy.sh` has execute permissions