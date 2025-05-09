package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strings"

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

	// Initialize conversation history
	messages := []groq.Message{
		{
			Role:    "system",
			Content: "You are a helpful assistant. Keep your responses concise and to the point.",
		},
	}

	scanner := bufio.NewScanner(os.Stdin)
	fmt.Println("Chat started! Type 'exit' to end the conversation.")

	for {
		fmt.Print("\nYou: ")
		if !scanner.Scan() {
			break
		}

		userInput := scanner.Text()
		if strings.ToLower(userInput) == "exit" {
			break
		}

		// Add user message to history
		messages = append(messages, groq.Message{
			Role:    "user",
			Content: userInput,
		})

		// Create chat completion request
		req := groq.ChatCompletionRequest{
			Model:       "llama-3.3-70b-versatile",
			Messages:    messages,
			Temperature: 0.7,
			MaxTokens:   150,
		}

		// Get response
		resp, err := client.CreateChatCompletion(req)
		if err != nil {
			log.Printf("Error creating chat completion: %v", err)
			continue
		}

		// Get assistant's response
		assistantResponse := resp.Choices[0].Message.Content
		fmt.Printf("\nAssistant: %s\n", assistantResponse)

		// Add assistant's response to history
		messages = append(messages, groq.Message{
			Role:    "assistant",
			Content: assistantResponse,
		})

		// Print token usage
		fmt.Printf("\nTokens used: %d (Prompt: %d, Completion: %d)\n",
			resp.Usage.TotalTokens,
			resp.Usage.PromptTokens,
			resp.Usage.CompletionTokens)
	}

	if err := scanner.Err(); err != nil {
		log.Printf("Error reading input: %v", err)
	}
} 