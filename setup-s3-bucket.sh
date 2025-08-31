#!/bin/bash

# Load environment variables
if [ -f .env ]; then
    export $(cat .env | xargs)
fi

S3_BUCKET=${S3_BUCKET:-"single-spa-demo-774145483743"}
AWS_REGION=${AWS_REGION:-"eu-central-1"}

echo "Setting up S3 bucket: $S3_BUCKET in region: $AWS_REGION"

# Check if bucket exists
if aws s3 ls "s3://$S3_BUCKET" 2>&1 | grep -q 'NoSuchBucket'; then
    echo "Creating S3 bucket..."
    
    # Create bucket
    if [ "$AWS_REGION" = "eu-central-1" ]; then
        aws s3 mb "s3://$S3_BUCKET"
    else
        aws s3 mb "s3://$S3_BUCKET" --region "$AWS_REGION"
    fi
    
    # Enable static website hosting
    aws s3 website "s3://$S3_BUCKET" --index-document index.html --error-document error.html
    
    # Set bucket policy for public read access
    cat > bucket-policy.json << EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::$S3_BUCKET/*"
        }
    ]
}
EOF
    
    aws s3api put-bucket-policy --bucket "$S3_BUCKET" --policy file://bucket-policy.json
    rm bucket-policy.json
    
    # Enable CORS
    cat > cors-config.json << EOF
{
    "CORSRules": [
        {
            "AllowedHeaders": ["*"],
            "AllowedMethods": ["GET", "HEAD"],
            "AllowedOrigins": ["*"],
            "ExposeHeaders": []
        }
    ]
}
EOF
    
    aws s3api put-bucket-cors --bucket "$S3_BUCKET" --cors-configuration file://cors-config.json
    rm cors-config.json
    
    echo "✅ S3 bucket $S3_BUCKET created and configured successfully!"
    echo "🌐 Website URL: http://$S3_BUCKET.s3-website-$AWS_REGION.amazonaws.com"
else
    echo "✅ S3 bucket $S3_BUCKET already exists"
fi