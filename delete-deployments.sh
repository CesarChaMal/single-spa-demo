#!/bin/bash

# Load environment variables
if [ -f .env ]; then
    export $(cat .env | xargs)
fi

S3_BUCKET=${S3_BUCKET:-"single-spa-demo-774145483743"}
ORG_NAME=${ORG_NAME:-"cesarchamal"}

echo "🗑️  Deleting all microfrontend deployments from S3..."
echo "Bucket: $S3_BUCKET"
echo "Organization: $ORG_NAME"
echo

aws s3 rm "s3://$S3_BUCKET/@$ORG_NAME/" --recursive
aws s3 rm "s3://$S3_BUCKET/@$ORG_NAME/importmap.json"

echo "✅ All deployments deleted!"