.PHONY: all build test clean examples setup

# Default target
all: test build

# Build the library
build:
	@echo "Building library..."
	go build -v ./...

# Run tests
test:
	@echo "Running tests..."
	go test -v ./...

# Build examples
examples:
	@echo "Building examples..."
	@mkdir -p bin
	go build -o bin/chat_completion examples/chat_completion.go
	go build -o bin/chat_with_history examples/chat_with_history.go

# Clean build artifacts
clean:
	@echo "Cleaning..."
	rm -rf bin/
	go clean

# Setup development environment
setup:
	@echo "Setting up development environment..."
	./scripts/setup.sh

# Install dependencies
deps:
	@echo "Installing dependencies..."
	go mod download
	go mod tidy

# Run linter
lint:
	@echo "Running linter..."
	golangci-lint run

# Generate documentation
docs:
	@echo "Generating documentation..."
	godoc -http=:6060

# Help target
help:
	@echo "Available targets:"
	@echo "  all        - Run tests and build"
	@echo "  build      - Build the library"
	@echo "  test       - Run tests"
	@echo "  examples   - Build example binaries"
	@echo "  clean      - Remove build artifacts"
	@echo "  setup      - Setup development environment"
	@echo "  deps       - Install dependencies"
	@echo "  lint       - Run linter"
	@echo "  docs       - Generate documentation"
	@echo "  help       - Show this help message" 