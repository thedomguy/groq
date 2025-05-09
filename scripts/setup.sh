#!/bin/bash

# Check if Go is installed
if ! command -v go &> /dev/null; then
    echo "Go is not installed. Please install Go first."
    exit 1
fi

# Load .env file if it exists
if [ -f .env ]; then
    echo "Loading environment variables from .env file..."
    set -a
    source .env
    set +a
else
    echo "Warning: .env file not found"
fi

# Check if GROQ_API_KEY is set
if [ -z "$GROQ_API_KEY" ]; then
    echo "GROQ_API_KEY is not set. Please either:"
    echo "1. Set it as an environment variable:"
    echo "   export GROQ_API_KEY=your-api-key"
    echo "2. Or create a .env file with:"
    echo "   GROQ_API_KEY=your-api-key"
    exit 1
fi

# Install dependencies
echo "Installing dependencies..."
go mod tidy

# Create bin directory if it doesn't exist
mkdir -p bin

# Build the examples
echo "Building examples..."
go build -o bin/chat_completion examples/chat_completion.go
go build -o bin/chat_with_history examples/chat_with_history.go

echo "Setup complete! You can now run the examples:"
echo "1. Simple chat completion:"
echo "   ./bin/chat_completion"
echo "2. Interactive chat with history:"
echo "   ./bin/chat_with_history" 