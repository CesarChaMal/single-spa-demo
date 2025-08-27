# Getting Started Guide

## 🚀 Quick Setup (5 minutes)

### Step 1: Development Setup
```bash
# Clone or download this repository
# Navigate to the project directory
cd single-spa-demo

# Install all dependencies
npm run install:all

# Start all microfrontends
npm run start:all
```

Open http://localhost:9000 in your browser ✅

### Step 2: Deployment Setup (Optional)

**If you want to deploy to production:**

1. **Create AWS Account** (free): https://aws.amazon.com/
2. **Install AWS CLI**: https://aws.amazon.com/cli/
3. **Setup deployment**:
   ```bash
   npm run deploy:setup
   ```
4. **Deploy**:
   ```bash
   npm run deploy:all
   ```

## 📋 What You Need

### Required (for development):
- ✅ Node.js (v12+)
- ✅ npm or yarn

### Optional (for deployment):
- 🔧 AWS Account
- 🔧 AWS CLI
- 🔧 GitHub Account (for Travis CI)

## 🎯 Three Ways to Deploy

### 1. Manual (Easiest)
```bash
npm run deploy:setup  # One-time setup
npm run deploy:all    # Deploy when ready
```

### 2. Travis CI (Automatic)
- Push code to GitHub
- Enable Travis CI
- Automatic deployment on push

### 3. GitHub Actions (Modern)
- Add workflow file
- Push to GitHub
- Automatic deployment

## 🆘 Need Help?

**Development not working?**
- Check Node.js version: `node --version`
- Try: `npm run clean:install`

**Deployment failing?**
- Install AWS CLI first
- Check AWS credentials
- Verify S3 bucket exists

**Still stuck?**
- Check the full README.md
- Look at troubleshooting section