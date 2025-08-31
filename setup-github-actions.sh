#!/bin/bash

echo "Setting up GitHub Actions workflows..."

# Create .github/workflows directory (single repo setup)
mkdir -p ".github/workflows"

echo "✅ GitHub Actions workflows directory created!"
echo
echo "Current setup (single repository):"
echo "  .github/workflows/deploy-root.yml    - Root config deployment"
echo "  .github/workflows/deploy-nav.yml     - Navigation deployment"
echo "  .github/workflows/deploy-page1.yml   - Page 1 deployment"
echo "  .github/workflows/deploy-page2.yml   - Page 2 deployment"
echo "  .github/workflows/debug-secrets.yml - Debug secrets"
echo
echo "✅ All workflows are already configured!"
echo
echo "Next steps:"
echo "1. Ensure GitHub secrets are set up:"
echo "   - AWS_ACCESS_KEY_ID"
echo "   - AWS_SECRET_ACCESS_KEY"
echo "   - S3_BUCKET"
echo "   - AWS_REGION"
echo "   - ORG_NAME"
echo "2. Make changes in microfrontend directories to trigger deployments"
echo "3. Check deployment status: bash check-github-actions.sh"