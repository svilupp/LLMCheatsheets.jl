# Comprehensive Cheatsheet for Using PromptingTools.jl

## Overview
PromptingTools.jl is a Julia package designed to simplify interactions with AI models by providing a variety of tools for generating, extracting, embedding, and classifying text. This cheatsheet covers everything from basic usage to advanced features such as RAG (Retrieve-Augmented Generation) tools and multi-turn conversations.

## Getting Started

### Installation
To install PromptingTools.jl, use the Julia package manager:
```julia
using Pkg
Pkg.add("PromptingTools")
```

### Setting Up API Keys
**OpenAI API Key:**
1. Sign up at [OpenAI](https://platform.openai.com/signup).
2. Navigate to [API Key Page](https://platform.openai.com/account/api-keys).
3. Set your API key in the environment:
    ```julia
    ENV["OPENAI_API_KEY"] = "your-api-key"
    ```
4. Optionally, for terminal:
    ```bash
    export OPENAI_API_KEY=<your-key>
    ```

## Basic Usage

### Quick Start with `@ai_str`
Generate responses quickly using the `@ai_str` string macro:
```julia
using PromptingTools

response = ai"What is the capital of France?"
println(response.content) # "The capital of France is Paris."
```

### Multi-Turn Conversations with `@ai!_str`
Keep context between queries:
```julia
response1 = ai"What is the weather today?"
response2 = ai!"Do I need an umbrella?"
```

### String Interpolation
Inject variables into your prompts:
```julia
country = "Spain"
response = ai"What is the capital of \$country?"
println(response.content) # "The capital of Spain is Madrid."
```

### Selecting Models
Choose specific models using flags:
```julia
response = ai"What is the meaning of life?"gpt4
```

## Advanced Functions

### `aigenerate` with Placeholders
Use handlebars-style templating for complex queries:
```julia
msg = aigenerate("What is the capital of {{country}}? Is the population larger than {{population}}?", country="Spain", population="1M")
println(msg.content)
```

**Asynchronous Version:**
```julia
response = aai"Say hi but slowly!"gpt4
```

### Creating Reusable Prompt Templates with `create_template`

#### Example Template Creation
Reusable templates streamline repeated tasks by defining a structure for prompts:
```julia
using PromptingTools

template = create_template(
    system = "You are a helpful assistant designed to answer programming questions.",
    user = "I need help with {{input_question}}"
)

question1 = "How do I reverse a list in Python?"
response1 = aigenerate(template; user_input=question1)
println(response1.content)
```

### Tips for a Good Prompt
1. **Clear Task Description:** Clearly define what the AI should do.
2. **Guidelines/Instructions:** Provide detailed conditions or steps.
3. **Desired Output Format:** Specify the expected format for the AI's response.
4. **System Prompt:** Should include clear task description, guidelines, and desired output format.
5. **User Prompt:** Should contain placeholders for inputs, like `{{input}}`.

## Multi-Turn Conversations with `AIGenerate`

### Using `AIGenerate` as a Functor
You can use `AIGenerate` for effortless multi-turn conversations with the LLM by treating it as a function:
```julia
conversation = AIGenerate("What is 1+1?")
response1 = conversation("Now multiply the result by 2.")
response2 = conversation("Subtract 3 from the result.")
println(response2)
```


## RAGTools Deep Dive

RAGTools enriches LLM capabilities with external data. The core functions include `airag`, `retrieve`, and `generate!`.

### `airag`
Combines retrieval and generation for advanced tasks.
```julia
response = airag(query="Describe the climate policies of different countries.")
```

### `retrieve`
Fetch relevant documents or data.
```julia
docs = retrieve("Explain neural networks in simple terms.")
```

### `generate!`
Use retrieved data to generate contextually rich responses.
```julia
context = retrieve("Explain neural networks in simple terms.")
response = generate!(context, "What are neural networks?")
println(response)
```

### Example Workflow
1. **Retrieve Data:**
    ```julia
    data = retrieve("Explain photosynthesis.")
    ```

2. **Generate Response:**
    ```julia
    response = generate!(data, "Using the following information, explain photosynthesis.")
    println(response.content)
    ```

### Additional Features

#### Asynchronous Execution
For heavy models, avoid blocking the REPL:
```julia
response = aai"Provide a summary of this text."gpt4
```

#### Custom Model Aliases
Define and use your own model aliases:
```julia
const PT = PromptingTools
PT.MODEL_ALIASES["gpt4t"] = "gpt-4-turbo"
response = ai"Describe the impact of climate change."gpt4t
```

#### Integration with Ollama Models
```julia
schema = PT.OllamaSchema()
msg = aigenerate(schema, "Say hi!"; model="openhermes2.5-mistral")
println(msg.content) # "Hello! How can I assist you today?"
```

#### Custom API Schemas
For custom API integrations:
```julia
PT.register_model!(name="custom-model", schema=PT.CustomOpenAISchema(), description="Custom API model.")
msg = aigenerate(PT.CustomOpenAISchema(), "Ask me anything."; model="custom-model", api_key="your_api_key")
```

## Best Practices and Cost Management

### Tokens and Costs
Monitor token usage and costs to manage expenses:
```julia
response = ai"How many tokens were used?"gpt4
println("Tokens used: ", response.tokens)
println("Cost: $", response.cost)
```

### Save and Load Templates
Persist your templates for reuse:
```julia
PT.save_template("templates/GreatingPirate.json", tpl; version="1.0")
PT.load_templates!("templates")
```

## Conclusion

PromptingTools.jl provides a versatile platform for integrating advanced AI functionalities into your projects. From simple queries to sophisticated RAG workflows, it offers powerful tools for effective and efficient AI interactions. Follow best practices, leverage reusable templates, and utilize advanced features to harness the full potential of PromptingTools.jl.