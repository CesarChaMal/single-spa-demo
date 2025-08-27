const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

// Load environment variables
require('dotenv').config();

const microfrontendType = process.argv[2];
if (!microfrontendType) {
  console.error('❌ Please specify microfrontend type: root-config, nav, page-1, or page-2');
  process.exit(1);
}

const config = {
  AWS_ACCESS_KEY_ID: process.env.AWS_ACCESS_KEY_ID,
  AWS_SECRET_ACCESS_KEY: process.env.AWS_SECRET_ACCESS_KEY,
  S3_BUCKET: process.env.S3_BUCKET || 'single-spa-demo',
  S3_REGION: process.env.S3_REGION || 'us-west-2',
  ORG_NAME: process.env.ORG_NAME || 'thawkin3'
};

// Validate required config
if (!config.AWS_ACCESS_KEY_ID || !config.AWS_SECRET_ACCESS_KEY) {
  console.error('❌ AWS credentials not found. Run "npm run deploy:setup" first.');
  process.exit(1);
}

const microfrontendConfig = {
  'root-config': {
    name: 'root-config',
    folder: 'single-spa-demo-root-config'
  },
  'nav': {
    name: 'single-spa-demo-nav',
    folder: 'single-spa-demo-nav'
  },
  'page-1': {
    name: 'single-spa-demo-page-1',
    folder: 'single-spa-demo-page-1'
  },
  'page-2': {
    name: 'single-spa-demo-page-2',
    folder: 'single-spa-demo-page-2'
  }
};

const mfConfig = microfrontendConfig[microfrontendType];
if (!mfConfig) {
  console.error('❌ Invalid microfrontend type');
  process.exit(1);
}

console.log(`🚀 Deploying ${mfConfig.name}...`);

try {
  // Generate commit hash (or use timestamp if not in git repo)
  let commitHash;
  try {
    commitHash = execSync('git rev-parse HEAD', { encoding: 'utf8' }).trim();
  } catch {
    commitHash = Date.now().toString();
  }

  const distPath = path.join(mfConfig.folder, 'dist');
  const s3Path = `s3://${config.S3_BUCKET}/@${config.ORG_NAME}/${mfConfig.name}/${commitHash}/`;

  // Check if dist folder exists
  if (!fs.existsSync(distPath)) {
    console.error(`❌ Build folder not found: ${distPath}`);
    console.log('Run "npm run build" first in the microfrontend directory');
    process.exit(1);
  }

  // Set AWS credentials
  process.env.AWS_ACCESS_KEY_ID = config.AWS_ACCESS_KEY_ID;
  process.env.AWS_SECRET_ACCESS_KEY = config.AWS_SECRET_ACCESS_KEY;
  process.env.AWS_DEFAULT_REGION = config.S3_REGION;

  // Upload to S3
  console.log(`📦 Uploading to ${s3Path}...`);
  execSync(`aws s3 sync ${distPath} ${s3Path} --acl public-read --cache-control "max-age=31536000"`, {
    stdio: 'inherit'
  });

  // Update import map (simplified version)
  console.log('🔄 Updating import map...');
  const importMapPath = 'importmap.json';
  
  // Download current import map or create new one
  let importMap = { imports: {} };
  try {
    execSync(`aws s3 cp s3://${config.S3_BUCKET}/@${config.ORG_NAME}/importmap.json ${importMapPath}`, {
      stdio: 'pipe'
    });
    importMap = JSON.parse(fs.readFileSync(importMapPath, 'utf8'));
  } catch {
    console.log('📝 Creating new import map...');
  }

  // Update import map with new URL
  const moduleKey = `@${config.ORG_NAME}/${mfConfig.name}`;
  const bundleName = microfrontendType === 'root-config' ? 'root-config.js' : `${config.ORG_NAME}-${mfConfig.name}.js`;
  importMap.imports[moduleKey] = `https://${config.S3_BUCKET}.s3-${config.S3_REGION}.amazonaws.com/@${config.ORG_NAME}/${mfConfig.name}/${commitHash}/${bundleName}`;

  // Upload updated import map
  fs.writeFileSync(importMapPath, JSON.stringify(importMap, null, 2));
  execSync(`aws s3 cp ${importMapPath} s3://${config.S3_BUCKET}/@${config.ORG_NAME}/importmap.json --acl public-read --cache-control "public, must-revalidate, max-age=0"`, {
    stdio: 'inherit'
  });

  // Cleanup
  fs.unlinkSync(importMapPath);

  console.log(`✅ ${mfConfig.name} deployed successfully!`);
  console.log(`🌐 URL: ${importMap.imports[moduleKey]}`);
  console.log(`📋 Import map updated`);

} catch (error) {
  console.error('❌ Deployment failed:', error.message);
  process.exit(1);
}