#!/bin/bash

echo "Setting up deployment for cesarchamal..."
echo

echo "Your AWS Configuration:"
echo "S3_BUCKET=single-spa-demo-774145483743"
echo "AWS_REGION=eu-central-1"
echo "ORG_NAME=cesarchamal"
echo

echo "Creating .env file..."
cat > .env << EOF
S3_BUCKET=single-spa-demo-774145483743
AWS_REGION=eu-central-1
ORG_NAME=cesarchamal
AWS_ACCESS_KEY_ID=your_access_key_here
AWS_SECRET_ACCESS_KEY=your_secret_key_here
EOF

echo
echo "✅ Configuration created!"
echo
echo "Next steps:"
echo "1. Edit .env file and add your real AWS credentials"
echo "2. Run: npm run deploy:setup (to configure interactively)"
echo "3. Or run: ./setup-s3-bucket.sh (to create S3 bucket)"
echo "4. Run: ./setup-github-actions.sh (to setup workflows)"
echo