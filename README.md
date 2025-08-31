# Single-SPA Microfrontend Demo

A complete microfrontend application built with [single-spa](https://single-spa.js.org/) demonstrating how to architect, develop, and deploy independent microfrontends that work together as a cohesive application.

## Architecture Overview

This project consists of four main components:

- **Root Config** (`single-spa-demo-root-config/`) - The orchestrator that registers and manages all microfrontends
- **Navigation App** (`single-spa-demo-nav/`) - React-based navigation microfrontend
- **Page 1 App** (`single-spa-demo-page-1/`) - React-based content microfrontend
- **Page 2 App** (`single-spa-demo-page-2/`) - React-based content microfrontend

Each microfrontend can be developed, tested, and deployed independently while working together seamlessly in the browser.

## Technology Stack

- **Framework**: single-spa for microfrontend orchestration
- **Frontend**: React 16.12+ for microfrontend applications
- **Module Loader**: SystemJS for dynamic module loading
- **Build Tool**: Webpack 4 with custom single-spa configurations
- **Development**: Webpack Dev Server for local development
- **Testing**: Jest for unit testing
- **Linting**: ESLint with Prettier for code quality
- **CI/CD**: GitHub Actions for automated deployment
- **Hosting**: AWS S3 for static asset hosting
- **Import Maps**: SystemJS import maps for module resolution

## Requirements & Setup

### What You Need

**For Development:**
- Node.js (v12 or higher)
- npm or yarn package manager
- Git (for version control)

**For Deployment:**
- AWS Account (free tier available)
- AWS CLI installed
- GitHub Account (for automated deployment)

### AWS Setup (Required for Deployment)

1. **Create AWS Account**: Sign up at https://aws.amazon.com/
2. **Create S3 Bucket**: 
   - Go to AWS S3 Console
   - Create a new bucket (e.g., `my-microfrontends`)
   - Enable public access for static website hosting
3. **Get AWS Credentials**:
   - Go to AWS IAM Console
   - Create new user with S3 full access
   - Save Access Key ID and Secret Access Key

### AWS CLI Installation

**Windows:**
```bash
# Download from: https://aws.amazon.com/cli/
# Or use chocolatey:
choco install awscli
```

**macOS:**
```bash
brew install awscli
```

**Linux:**
```bash
sudo apt install awscli  # Ubuntu/Debian
sudo yum install awscli  # CentOS/RHEL
```

### GitHub Actions Setup (Recommended - Free)

1. **Push code to GitHub repository**
2. **Add AWS credentials** to GitHub Secrets:
   - Go to repository Settings → Secrets and variables → Actions
   - Add `AWS_ACCESS_KEY_ID`
   - Add `AWS_SECRET_ACCESS_KEY`
   - Add `S3_BUCKET`
3. **GitHub Actions workflow** will be created automatically
4. **Push to main branch** triggers deployment

### Alternative Free CI/CD Options

- **GitHub Actions** (Recommended) - 2000 minutes/month free
- **GitLab CI/CD** - 400 minutes/month free
- **Netlify** - Free for static sites
- **Vercel** - Free for personal projects

## Quick Start

### Prerequisites

- Node.js (v16.20.0 recommended - see .nvmrc)
- npm or yarn package manager
- nvm (optional but recommended for Node.js version management)

### Installation & Development

1. **Use correct Node.js version (if using nvm):**
   ```bash
   nvm use
   ```

2. **Install dependencies for all microfrontends:**
   ```bash
   npm run install:all
   ```

2. **Start all microfrontends in development mode:**
   ```bash
   npm run start:all
   ```

3. **Open your browser:**
   Navigate to `http://localhost:9000` to see the application

### Individual Microfrontend Development

Each microfrontend runs on its own port:
- Root Config: `http://localhost:9000`
- Navigation: `http://localhost:9001`
- Page 1: `http://localhost:9002`
- Page 2: `http://localhost:9003`

To work on individual microfrontends:
```bash
# Start only the root config
npm run start:root

# Start only the navigation app
npm run start:nav

# Start only page 1 app
npm run start:page1

# Start only page 2 app
npm run start:page2
```

## Available Scripts

### Development
- `npm run install:all` - Install dependencies for all microfrontends
- `npm run start:all` - Start all microfrontends in development mode
- `npm run start:root` - Start only the root config
- `npm run start:nav` - Start only the navigation app
- `npm run start:page1` - Start only page 1 app
- `npm run start:page2` - Start only page 2 app

### Building & Testing
- `npm run build:all` - Build all microfrontends for production
- `npm run test:all` - Run tests for all microfrontends
- `npm run lint:all` - Lint all microfrontends
- `npm run prettier:all` - Format code for all microfrontends

### Utilities
- `npm run clean` - Clean all node_modules and build artifacts
- `npm run clean:install` - Clean and reinstall all dependencies

### Deployment
- `npm run deploy:setup` - Setup deployment configuration
- `npm run deploy:all` - Deploy all microfrontends to production
- `npm run deploy:root` - Deploy only root config
- `npm run deploy:nav` - Deploy only navigation app
- `npm run deploy:page1` - Deploy only page 1 app
- `npm run deploy:page2` - Deploy only page 2 app

## Project Structure

```
single-spa-demo/
├── single-spa-demo-root-config/     # Root orchestrator
│   ├── src/
│   │   ├── index.ejs               # Main HTML template
│   │   ├── root-config.js          # Single-spa configuration
│   │   └── activity-functions.js   # Route matching logic
│   └── package.json
├── single-spa-demo-nav/            # Navigation microfrontend
│   ├── src/
│   │   └── root.component.js       # React navigation component
│   └── package.json
├── single-spa-demo-page-1/         # Page 1 microfrontend
│   ├── src/
│   │   └── root.component.js       # React page component
│   └── package.json
├── single-spa-demo-page-2/         # Page 2 microfrontend
│   ├── src/
│   │   └── root.component.js       # React page component
│   └── package.json
├── package.json                    # Root package.json with scripts
└── README.md                       # This file
```

## How It Works

1. **Root Config**: Acts as the single-spa orchestrator, defining which microfrontends should be active based on the current route
2. **Import Maps**: SystemJS import maps define where to find each microfrontend's JavaScript bundle
3. **Dynamic Loading**: Microfrontends are loaded on-demand based on routing rules
4. **Independent Deployment**: Each microfrontend can be built and deployed separately
5. **Shared Dependencies**: Common dependencies like React are shared between microfrontends

## Import Maps Explained

**Import Maps** are a web standard that allows you to control how JavaScript modules are resolved. In this project, SystemJS uses import maps to:

- **Map module names to URLs**: `@cesarchamal/single-spa-demo-nav` → `http://localhost:9001/bundle.js`
- **Enable independent deployment**: Each microfrontend can update its URL without affecting others
- **Support versioning**: Production URLs include commit SHAs for cache busting
- **Provide environment flexibility**: Different URLs for development vs production

Example import map:
```json
{
  "imports": {
    "@cesarchamal/single-spa-demo-nav": "http://localhost:9001/bundle.js",
    "@cesarchamal/single-spa-demo-page-1": "http://localhost:9002/bundle.js"
  }
}
```

## CI/CD with GitHub Actions

**GitHub Actions** is GitHub's free CI/CD service that automatically builds and deploys your code when changes are pushed.

### What GitHub Actions Does:

1. **Triggers on Push**: Automatically runs when code is pushed to the main branch
2. **Builds the Project**: Runs `npm run build` to create production bundles
3. **Runs Tests**: Executes test suites to ensure code quality
4. **Deploys to AWS S3**: Uploads built assets to Amazon S3 for hosting
5. **Updates Import Map**: Automatically updates the import map to point to new versions

### Deployment Flow:

```
Code Push → GitHub Actions → Build → Test → Deploy to S3 → Update Import Map → Live
```

### Benefits:

- **Free**: 2000 minutes/month for public repos, unlimited for public repos
- **Zero Downtime**: New versions go live instantly
- **Independent Releases**: Each microfrontend deploys separately
- **Automatic Rollbacks**: Easy to revert to previous versions
- **Version Management**: Each deployment is tagged with commit SHA

## Development Workflow

1. **Local Development**: All microfrontends run simultaneously with hot reloading
2. **Independent Testing**: Each microfrontend has its own test suite
3. **Code Quality**: Consistent linting and formatting across all projects
4. **Build Process**: Production builds create optimized bundles for each microfrontend

## Deployment Options

### Option 1: Manual Deployment (Recommended for Beginners)

1. **Install AWS CLI** (see setup section above)
2. **Configure credentials:**
   ```bash
   npm run deploy:setup
   ```
3. **Deploy all microfrontends:**
   ```bash
   npm run deploy:all
   # or double-click deploy-all.bat on Windows
   ```

### Option 2: GitHub Actions (Automated - Recommended)

**Setup Steps:**
1. Push code to GitHub repository
2. Add environment variables in GitHub Secrets:
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY` 
   - `S3_BUCKET`
3. Push to main branch → automatic deployment

### Option 3: Alternative Free Platforms

**Netlify** (Free static hosting):
- Connect GitHub repository
- Automatic builds on push
- No AWS needed

**Vercel** (Free for personal projects):
- Connect GitHub repository  
- Automatic deployments
- Built-in CDN

### Production Deployment (Travis CI)

Each microfrontend automatically deploys when code is pushed to master:

1. **Travis CI Configuration**: `.travis.yml` in each microfrontend directory
2. **Build Process**: Compiles and tests the code
3. **S3 Upload**: Deploys assets to AWS S3 with versioned URLs
4. **Import Map Update**: `after_deploy.sh` updates the central import map

### Manual Deployment

For individual microfrontends:
```bash
# Build the microfrontend
npm run build

# Deploy to S3 (requires AWS CLI setup)
aws s3 sync dist/ s3://your-bucket/path/

# Update import map
node update-importmap.mjs
```

### Environment Variables Required:

- `AWS_ACCESS_KEY_ID`: AWS access key for S3 deployment
- `AWS_SECRET_ACCESS_KEY`: AWS secret key for S3 deployment
- `S3_BUCKET`: Your S3 bucket name
- `S3_REGION`: AWS region (default: eu-central-1)
- `TRAVIS_COMMIT`: Git commit SHA (automatically set by Travis CI)

## Troubleshooting

### Common Issues

**"AWS CLI not found"**
- Install AWS CLI from https://aws.amazon.com/cli/
- Restart terminal after installation

**"Access Denied" errors**
- Check AWS credentials are correct
- Ensure S3 bucket exists and has proper permissions
- Verify IAM user has S3 full access

**"Module not found" in browser**
- Check import map is updated correctly
- Verify S3 bucket allows public access
- Check CORS settings on S3 bucket

**GitHub Actions not deploying**
- Verify environment variables are set in GitHub Secrets
- Check workflow file exists: `.github/workflows/deploy.yml`
- Ensure you're pushing to `main` or `master` branch
- Check Actions tab in GitHub repository for error logs

### Development vs Production

**Development (Local):**
- Uses `localhost` URLs in import map
- Hot reloading enabled
- No deployment needed

**Production:**
- Uses S3 URLs in import map
- Optimized builds
- Requires deployment setup

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes in the appropriate microfrontend directory
4. Run tests and linting: `npm run test:all && npm run lint:all`
5. Submit a pull request

## Learn More

- [single-spa Documentation](https://single-spa.js.org/)
- [Microfrontend Architecture Guide](https://micro-frontends.org/)
- [SystemJS Documentation](https://github.com/systemjs/systemjs)
- [AWS S3 Static Website Hosting](https://docs.aws.amazon.com/s3/latest/userguide/WebsiteHosting.html)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Netlify Documentation](https://docs.netlify.com/)
- [Vercel Documentation](https://vercel.com/docs)

## License

MIT License - see individual package.json files for details.