# Deployment Guide

## Quick Setup

### 1. GitHub Actions (Recommended - Free)
```bash
# Secrets are already configured
# Just push code to trigger deployment
git push origin main
```

### 2. Manual Deployment
```bash
npm run deploy:all
```

## Deployment Flow Explanation

### File Relationships

**Travis CI (Original):**
```
.travis.yml → after_deploy.sh → update-importmap.mjs → S3
```

**GitHub Actions (New):**
```
github-deploy.yml → after_deploy.sh → update-importmap.mjs → S3
```

### Detailed Flow

#### 1. CI/CD Trigger (.travis.yml vs github-deploy.yml)
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

#### 2. Deployment Script (after_deploy.sh)
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

#### 3. Import Map Updater (update-importmap.mjs)
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

### Import Map Structure

**Before Deployment:**
```json
{
  "imports": {
    "@cesarchamal/single-spa-demo-nav": "https://bucket.s3.amazonaws.com/@cesarchamal/nav/abc123/bundle.js",
    "@cesarchamal/single-spa-demo-page-1": "https://bucket.s3.amazonaws.com/@cesarchamal/page-1/def456/bundle.js"
  }
}
```

**After Page-1 Deployment:**
```json
{
  "imports": {
    "@cesarchamal/single-spa-demo-nav": "https://bucket.s3.amazonaws.com/@cesarchamal/nav/abc123/bundle.js",
    "@cesarchamal/single-spa-demo-page-1": "https://bucket.s3.amazonaws.com/@cesarchamal/page-1/xyz789/bundle.js"
  }
}
```

### S3 Folder Structure

```
s3://single-spa-demo-774145483743/
├── @cesarchamal/
│   ├── root-config/
│   │   ├── abc123/
│   │   │   └── root-config.js
│   │   └── def456/
│   │       └── root-config.js
│   ├── single-spa-demo-nav/
│   │   ├── abc123/
│   │   │   └── cesarchamal-single-spa-demo-nav.js
│   │   └── def456/
│   │       └── cesarchamal-single-spa-demo-nav.js
│   ├── single-spa-demo-page-1/
│   │   └── xyz789/
│   │       └── cesarchamal-single-spa-demo-page-1.js
│   └── importmap.json
```

### Key Differences: Travis vs GitHub Actions

| Aspect | Travis CI | GitHub Actions |
|--------|-----------|----------------|
| **Trigger File** | `.travis.yml` | `.github/workflows/deploy.yml` |
| **Commit Variable** | `$TRAVIS_COMMIT` | `$GITHUB_SHA` |
| **Environment** | Travis CI servers | GitHub runners |
| **Secrets** | Travis dashboard | GitHub repository secrets |
| **Cost** | Paid service | Free (2000 min/month) |
| **Setup** | External service | Built into GitHub |

### Benefits of New Flow

1. **Free:** GitHub Actions is free for public repos
2. **Integrated:** No external CI service needed
3. **Flexible:** Easy to customize workflows
4. **Secure:** Secrets managed in GitHub
5. **Fast:** Runs on GitHub's infrastructure

## Deployment Scripts

### GitHub Actions Workflow
- **Location**: `.github/workflows/deploy-*.yml`
- **Triggers**: Changes in specific microfrontend directories
- **Process**: Build → Deploy → Update import map

### After Deploy Script
- **Location**: `*/after_deploy.sh`
- **Purpose**: 
  - Create S3 bucket if needed
  - Upload built files with commit SHA
  - Download/update/upload import map

### Import Map Updater
- **Location**: `*/update-importmap.mjs`
- **Purpose**: Update central import map with new bundle URLs
- **Verification**: Checks if deployed file is accessible

## Environment Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `S3_BUCKET` | S3 bucket name | `single-spa-demo-774145483743` |
| `AWS_REGION` | AWS region | `eu-central-1` |
| `ORG_NAME` | Organization name | `cesarchamal` |
| `GITHUB_SHA` | Commit hash | `abc123...` |

## Troubleshooting

**Import map not updating?**
- Check `update-importmap.mjs` can reach the deployed file
- Verify S3 bucket has public read permissions
- Ensure CORS is configured on S3 bucket

**Deployment failing?**
- Check GitHub secrets: `bash check-github-secrets.sh`
- Verify AWS credentials: `bash test-aws-credentials.sh`
- Check workflow logs in GitHub Actions tab

**Workflows not triggering?**
- Make changes in microfrontend directories (not root)
- Check workflow path filters in `.github/workflows/`

## Alternative Deployment Options

### Netlify Deployment Flow

**File Relationships:**
```
GitHub Push → Netlify Build → Static Hosting → CDN
```

**Setup Process:**
1. **Connect Repository**: Link GitHub repo to Netlify
2. **Build Settings**: Netlify detects build commands automatically
3. **Deploy**: Automatic deployments on every push
4. **CDN**: Built-in global CDN distribution

**Netlify Configuration (netlify.toml):**
```toml
[build]
  command = "npm run build:all"
  publish = "dist"

[[redirects]]
  from = "/*"
  to = "/index.html"
  status = 200
```

**Benefits:**
- No AWS setup required
- Automatic HTTPS certificates
- Built-in form handling
- Branch previews

### Vercel Deployment Flow

**File Relationships:**
```
GitHub Push → Vercel Build → Edge Network → Global CDN
```

**Setup Process:**
1. **Import Repository**: Connect GitHub repo to Vercel
2. **Zero Config**: Automatically detects framework and build settings
3. **Deploy**: Instant deployments on push
4. **Edge**: Deployed to global edge network

**Vercel Configuration (vercel.json):**
```json
{
  "builds": [{
    "src": "package.json",
    "use": "@vercel/static-build",
    "config": {
      "buildCommand": "npm run build:all"
    }
  }],
  "routes": [{
    "src": "/(.*)",
    "dest": "/index.html"
  }]
}
```

**Benefits:**
- Fastest global deployment
- Automatic performance optimization
- Preview deployments for PRs
- Built-in analytics

### Manual S3 Deployment
```bash
# Build all
npm run build:all

# Deploy manually
aws s3 sync dist/ s3://your-bucket/ --region eu-central-1
```

## Benefits

- **Independent Deployments**: Each microfrontend deploys separately
- **Zero Downtime**: New versions go live instantly
- **Version Control**: Each deployment tagged with commit SHA
- **Rollback Ready**: Easy to revert to previous versions
- **Cost Effective**: GitHub Actions free for public repos