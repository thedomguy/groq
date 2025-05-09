package main

import (
	"fmt"
	"log"
	"os"

	"github.com/joho/godotenv"
	"github.com/thedomguy/groq.git"
)

func main() {
	// Load .env file
	if err := godotenv.Load(); err != nil {
		log.Printf("Warning: .env file not found: %v", err)
	}

	apiKey := os.Getenv("GROQ_API_KEY")
	if apiKey == "" {
		log.Fatal("GROQ_API_KEY environment variable is required. Please set it in your .env file or environment variables.")
	}

	client := groq.NewClient(apiKey)

	req := groq.ChatCompletionRequest{
		Model: "llama-3.3-70b-versatile",
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
		log.Fatalf("Error creating chat completion: %v", err)
	}

	fmt.Printf("Response: %s\n", resp.Choices[0].Message.Content)
	fmt.Printf("Total tokens: %d\n", resp.Usage.TotalTokens)
} 