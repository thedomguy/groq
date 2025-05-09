# Groq Go Client

A Go client library for the Groq API, providing a simple interface to interact with Groq's chat completion API.

## Prerequisites

- Go 1.24 or later
- A Groq API key

## Quick Start

1. Clone the repository:

```bash
git clone https://github.com/thedomguy/groq.git
cd groq
```

2. Set your Groq API key (choose one method):
   - Using environment variable:

     ```bash
     export GROQ_API_KEY=your-api-key
     ```

   - Or using a .env file:

     ```bash
     echo "GROQ_API_KEY=your-api-key" > .env
     ```

3. Run the setup script:

```bash
./scripts/setup.sh
```

4. Run the example:

```bash
./bin/chat_completion
```

## Installation

```bash
go get github.com/thedomguy/groq.git
```

## Usage

```go
package main

import (
    "fmt"
    "log"
    "os"

    "github.com/thedomguy/groq.git"
)

func main() {
    client := groq.NewClient(os.Getenv("GROQ_API_KEY"))

    req := groq.ChatCompletionRequest{
        Model: "llama2-70b-4096",
        Messages: []groq.Message{
            {
                Role:    "system",
                Content: "You are a helpful assistant.",
            },
            {
                Role:    "user",
                Content: "What is the capital of France?",
            },
        },
        Temperature: 0.7,
        MaxTokens:   100,
    }

    resp, err := client.CreateChatCompletion(req)
    if err != nil {
        log.Fatal(err)
    }

    fmt.Println(resp.Choices[0].Message.Content)
}
```

## Features

- Simple and intuitive API
- Full support for chat completion endpoints
- Configurable request parameters
- Error handling and response parsing

## Configuration

The client requires a Groq API key, which can be obtained from the [Groq Console](https://console.groq.com). Set it as an environment variable:

```bash
export GROQ_API_KEY=your-api-key
```

## License

MIT License
