#!/bin/bash

# release.sh - Script to publish new versions of the groq package

set -e

# Function to show usage
show_usage() {
    echo "Usage: $0 <version_type>"
    echo "version_type: major|minor|patch"
    echo ""
    echo "This script will:"
    echo "1. Bump the version"
    echo "2. Create a git tag"
    echo "3. Push changes and tags"
    echo "4. Create a GitHub release"
}

# Check if gh CLI is installed
if ! command -v gh &> /dev/null; then
    echo "Error: GitHub CLI (gh) is not installed"
    echo "Please install it from: https://cli.github.com/"
    exit 1
fi

# Check if we're authenticated with GitHub
if ! gh auth status &> /dev/null; then
    echo "Error: Not authenticated with GitHub"
    echo "Please run: gh auth login"
    exit 1
fi

# Check if we're on main branch
current_branch=$(git branch --show-current)
if [ "$current_branch" != "main" ]; then
    echo "Error: You must be on the main branch to create a release"
    echo "Current branch: $current_branch"
    echo "Please checkout main branch: git checkout main"
    exit 1
fi

# Check if working directory is clean
if ! git diff-index --quiet HEAD --; then
    echo "Error: Working directory is not clean"
    echo "Please commit or stash your changes before creating a release"
    exit 1
fi

# Check arguments
if [ -z "$1" ]; then
    show_usage
    exit 1
fi

# Run version bump
echo "Bumping version..."
./scripts/version.sh release "$1"

# Get the new version
NEW_VERSION=$(./scripts/version.sh current | cut -d' ' -f3)

# Push changes and tags
echo "Pushing changes to GitHub..."
git push origin main
git push origin "v$NEW_VERSION"

# Create GitHub release
echo "Creating GitHub release..."
gh release create "v$NEW_VERSION" \
    --title "Release v$NEW_VERSION" \
    --notes "Release v$NEW_VERSION" \
    --draft

echo "Release v$NEW_VERSION has been created as a draft"
echo "Please review and publish the release on GitHub" 