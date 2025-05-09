#!/bin/bash

# version.sh - Script to manage versioning for the groq package

# Function to show usage
show_usage() {
    echo "Usage: $0 <command> [version]"
    echo "Commands:"
    echo "  current    - Show current version"
    echo "  bump       - Bump version (major|minor|patch)"
    echo "  tag        - Create git tag for current version"
    echo "  release    - Bump version and create git tag"
}

# Function to get current version
get_current_version() {
    grep -o 'version = "[0-9]*\.[0-9]*\.[0-9]*"' groq.go | cut -d'"' -f2
}

# Function to update version in groq.go
update_version() {
    local new_version=$1
    sed -i '' "s/version = \"[0-9]*\.[0-9]*\.[0-9]*\"/version = \"$new_version\"/" groq.go
}

# Function to bump version
bump_version() {
    local current_version=$(get_current_version)
    local major=$(echo $current_version | cut -d. -f1)
    local minor=$(echo $current_version | cut -d. -f2)
    local patch=$(echo $current_version | cut -d. -f3)
    
    case $1 in
        major)
            major=$((major + 1))
            minor=0
            patch=0
            ;;
        minor)
            minor=$((minor + 1))
            patch=0
            ;;
        patch)
            patch=$((patch + 1))
            ;;
        *)
            echo "Invalid bump type. Use major, minor, or patch"
            exit 1
            ;;
    esac
    
    echo "$major.$minor.$patch"
}

# Main script logic
case $1 in
    current)
        echo "Current version: $(get_current_version)"
        ;;
    bump)
        if [ -z "$2" ]; then
            echo "Please specify bump type (major|minor|patch)"
            exit 1
        fi
        new_version=$(bump_version $2)
        update_version $new_version
        echo "Version bumped to: $new_version"
        ;;
    tag)
        current_version=$(get_current_version)
        git tag -a "v$current_version" -m "Release v$current_version"
        echo "Created tag v$current_version"
        ;;
    release)
        if [ -z "$2" ]; then
            echo "Please specify bump type (major|minor|patch)"
            exit 1
        fi
        new_version=$(bump_version $2)
        update_version $new_version
        git add groq.go
        git commit -m "Bump version to $new_version"
        git tag -a "v$new_version" -m "Release v$new_version"
        echo "Released version $new_version"
        ;;
    *)
        show_usage
        exit 1
        ;;
esac 