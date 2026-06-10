#!/bin/bash
# Run this script from the project root to push to GitHub
# Usage: bash setup_github.sh <your-github-username> <repo-name>

GITHUB_USER=$1
REPO_NAME=$2

if [ -z "$GITHUB_USER" ] || [ -z "$REPO_NAME" ]; then
  echo "Usage: bash setup_github.sh <github-username> <repo-name>"
  exit 1
fi

echo "Setting up GitHub remote..."
git remote add origin "https://github.com/$GITHUB_USER/$REPO_NAME.git"
git branch -M main
git push -u origin main

echo ""
echo "✅ Done! Visit: https://github.com/$GITHUB_USER/$REPO_NAME"
