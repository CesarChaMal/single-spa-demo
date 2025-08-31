#!/bin/bash

# Load environment variables
if [ -f .env ]; then
    export $(cat .env | xargs)
fi

S3_BUCKET=${S3_BUCKET:-"single-spa-demo-774145483743"}
ORG_NAME=${ORG_NAME:-"cesarchamal"}

echo "⚠️  WARNING: This will delete all microfrontend deployments from S3 bucket: $S3_BUCKET"
echo "This will remove all versions of all microfrontends!"
echo
read -p "Are you sure? (type 'yes' to confirm): " confirm

if [ "$confirm" != "yes" ]; then
    echo "❌ Operation cancelled"
    exit 0
fi

echo "🗑️  Deleting all microfrontend deployments..."
aws s3 rm "s3://$S3_BUCKET/@$ORG_NAME/" --recursive
aws s3 rm "s3://$S3_BUCKET/@$ORG_NAME/importmap.json"

echo "✅ All microfrontend deployments deleted from $S3_BUCKET!"