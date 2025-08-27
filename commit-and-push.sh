#!/bin/bash

echo "Committing and pushing changes..."

git add .
git commit -m "Add complete single-spa microfrontend setup with free CI/CD alternatives"
git push origin main

echo
echo "Changes committed and pushed successfully!"
echo
echo "Next steps:"
echo "1. Set up GitHub Actions by moving github-actions-deploy.yml to .github/workflows/deploy.yml"
echo "2. Add AWS secrets to GitHub repository settings"
echo "3. Or use Netlify/Vercel for easier deployment"