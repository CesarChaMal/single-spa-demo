#!/bin/bash

echo "Getting your AWS account information..."
echo

echo "========================================"
echo "AWS Account Information"
echo "========================================"

echo "Getting AWS Account ID..."
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text 2>/dev/null)
if [ -z "$AWS_ACCOUNT_ID" ]; then
    echo "❌ Could not get AWS Account ID. Make sure AWS CLI is configured."
    echo "Run: aws configure"
    exit 1
fi
echo "AWS Account ID: $AWS_ACCOUNT_ID"

echo
echo "Getting AWS User/Role..."
AWS_ARN=$(aws sts get-caller-identity --query "Arn" --output text 2>/dev/null)
echo "AWS ARN: $AWS_ARN"

echo
echo "Getting AWS Region..."
AWS_REGION=$(aws configure get region 2>/dev/null)
if [ -z "$AWS_REGION" ]; then
    AWS_REGION="eu-central-1"
fi
echo "AWS Region: $AWS_REGION"

echo
echo "========================================"
echo "Recommended Configuration"
echo "========================================"
echo
echo "Based on your AWS account, here are the recommended values:"
echo
echo "S3_BUCKET=single-spa-demo-$AWS_ACCOUNT_ID"
echo "AWS_REGION=$AWS_REGION"
echo "ORG_NAME=$USER"
echo
echo "========================================"
echo "What is ORG_NAME?"
echo "========================================"
echo
echo "ORG_NAME is just a namespace for your microfrontends."
echo "It can be:"
echo "- Your GitHub username"
echo "- Your company name"
echo "- Your project name"
echo "- Any unique identifier"
echo
echo "Examples:"
echo "- ORG_NAME=mycompany"
echo "- ORG_NAME=johnsmith"
echo "- ORG_NAME=myproject"
echo
echo "This creates URLs like:"
echo "@mycompany/nav → https://bucket.s3.amazonaws.com/@mycompany/nav/commit/bundle.js"
echo
echo "========================================"
echo "Next Steps"
echo "========================================"
echo
echo "1. Choose your ORG_NAME (suggestion: $USER)"
echo "2. Run: npm run deploy:setup"
echo "3. Use these values when prompted:"
echo "   - S3_BUCKET: single-spa-demo-$AWS_ACCOUNT_ID"
echo "   - AWS_REGION: $AWS_REGION"
echo "   - ORG_NAME: [your choice]"
echo