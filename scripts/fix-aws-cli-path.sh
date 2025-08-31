#!/bin/bash

echo "Checking AWS CLI installation and PATH..."
echo

echo "========================================"
echo "AWS CLI Location Check"
echo "========================================"

# Check if AWS CLI is in PATH
if command -v aws &> /dev/null; then
    AWS_CLI_PATH=$(which aws)
    echo "✅ Found AWS CLI at: $AWS_CLI_PATH"
    AWS_CLI_DIR=$(dirname "$AWS_CLI_PATH")
else
    echo "❌ AWS CLI not found in PATH"
    echo
    echo "Checking common installation locations..."
    
    # Common AWS CLI locations on Windows (Git Bash paths)
    COMMON_PATHS=(
        "/c/Program Files/Amazon/AWSCLIV2/aws.exe"
        "/c/Program Files (x86)/Amazon/AWSCLIV2/aws.exe"
        "/c/Users/$USER/AppData/Local/Programs/Python/Python*/Scripts/aws.exe"
        "/c/Python*/Scripts/aws.exe"
        "/usr/local/bin/aws"
        "/usr/bin/aws"
    )
    
    for path in "${COMMON_PATHS[@]}"; do
        if [ -f "$path" ] || ls $path 2>/dev/null; then
            echo "✅ Found AWS CLI at: $path"
            AWS_CLI_PATH="$path"
            AWS_CLI_DIR=$(dirname "$path")
            break
        fi
    done
    
    if [ -z "$AWS_CLI_PATH" ]; then
        echo "❌ AWS CLI not found. Please install it from:"
        echo "https://aws.amazon.com/cli/"
        exit 1
    fi
fi

echo
echo "========================================"
echo "Adding AWS CLI to PATH"
echo "========================================"
echo

if ! command -v aws &> /dev/null; then
    echo "Adding AWS CLI to PATH for this session..."
    export PATH="$PATH:$AWS_CLI_DIR"
    echo "✅ AWS CLI added to PATH"
fi

echo
echo "========================================"
echo "Testing AWS CLI"
echo "========================================"
aws --version
if [ $? -ne 0 ]; then
    echo "❌ AWS CLI test failed"
    exit 1
fi

echo
echo "========================================"
echo "IntelliJ Terminal Fix"
echo "========================================"
echo
echo "To fix IntelliJ terminal permanently:"
echo
echo "1. Open IntelliJ IDEA"
echo "2. Go to File → Settings → Tools → Terminal"
echo "3. In 'Environment variables' add:"
echo "   PATH=\$PATH:$AWS_CLI_DIR"
echo
echo "OR"
echo
echo "4. In IntelliJ terminal, run this command:"
echo "   export PATH=\$PATH:$AWS_CLI_DIR"
echo
echo "For Git Bash in IntelliJ, use:"
echo "   export PATH=\$PATH:$(echo $AWS_CLI_DIR | sed 's|/c/|/c/|')"
echo

echo "========================================"
echo "Getting AWS Information"
echo "========================================"
echo

AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text 2>/dev/null)
if [ $? -eq 0 ] && [ -n "$AWS_ACCOUNT_ID" ]; then
    echo "AWS Account ID: $AWS_ACCOUNT_ID"
    
    AWS_REGION=$(aws configure get region 2>/dev/null)
    if [ -z "$AWS_REGION" ]; then
        AWS_REGION="eu-central-1"
    fi
    echo "AWS Region: $AWS_REGION"
    
    echo
    echo "Recommended configuration:"
    echo "S3_BUCKET=single-spa-demo-$AWS_ACCOUNT_ID"
    echo "AWS_REGION=$AWS_REGION"
    echo "ORG_NAME=$USER"
else
    echo "❌ AWS CLI not configured. Run: aws configure"
    echo "Or check get-aws-info-manual.md for manual setup"
fi

echo