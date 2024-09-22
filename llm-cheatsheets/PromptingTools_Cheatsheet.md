# PromptingTools.jl Comprehensive Cheatsheet

Welcome to the comprehensive cheatsheet for the PromptingTools.jl repository! Let's get you started quickly and effectively in leveraging this powerful Julia package for various AI interactions.

---

## 1. Package Name

**PromptingTools.jl**

## 2. URL

**[GitHub Repository](https://github.com/svilupp/PromptingTools.jl)**

## 3. Purpose

PromptingTools.jl simplifies interactions with large language models (LLMs) such as OpenAI's GPT models. It focuses on effective prompt engineering, seamless integration with various API providers, and advanced AI interaction capabilities, including Retrieval-Augmented Generation (RAG).

## 4. Installation

### Prerequisites
1. **OpenAI API Key**: [Generate API Key](https://platform.openai.com/account/api-keys)
2. **Set Environment Variable**:
    ```julia
    ENV["OPENAI_API_KEY"] = "your-api-key"
    ```

### Install Package
```julia
using Pkg
Pkg.add("PromptingTools")
```

### Load the Package
```julia
using PromptingTools
const PT = PromptingTools
```

## 5. Usage Overview

### Basic Usage with `@ai_str`

#### Query the AI Model
```julia
ai"What is the capital of France?"
```

#### Variable Injection with Interpolation
```julia
country = "Spain"
ai"What is the capital of \$(country)?"
```

#### Model Selection
```julia
ai"What is the capital of France?"gpt4
```

### Using `aigenerate` for Templated Prompts

#### Simple Templated Prompt
```julia
msg = aigenerate("What is the capital of {{country}}?", country="Spain")
```
- **Output Access**: `msg.content`

## 6. Main Features and Functions

### List of Key Functions

#### 1. `aigenerate`
- **Purpose**: Generates text responses.
- **Usage**:
    ```julia
    msg = aigenerate("What is the capital of {{country}}?", country="Spain")
    println(msg.content)  # Output: "The capital of Spain is Madrid."
    ```

#### 2. `aiembed`
- **Purpose**: Extracts embeddings.
- **Usage**:
    ```julia
    embedding_msg = aiembed("Text to embed")
    embedding = embedding_msg.content  # Vector of Float64 representing the embedding
    ```

#### 3. `aiextract`
- **Purpose**: Extracts structured data into a defined type.
- **Usage**:
    ```julia
    struct Weather
        location::String
        temperature::Float64
    end
    msg = aiextract("Weather in NYC is 70°F.", return_type=Weather)
    println(msg.content)
    ```

#### 4. `aiclassify`
- **Purpose**: Classifies input into specified categories.
- **Usage**:
    ```julia
    msg = aiclassify("Is the sky blue?", choices=["Yes", "No"]).content
    ```

#### 5. `aiscan`
- **Purpose**: Works with images, generating text descriptions or performing OCR.
- **Usage**:
    ```julia
    msg = aiscan("Describe this image", image_path="path/to/image.png").content
    ```

#### 6. `aiimage`
- **Purpose**: Generates images.
- **Usage**:
    ```julia
    msg = aiimage("Generate an image of a sunset").content
    ```

#### 7. `aitemplates`
- **Purpose**: Discover and use prompt templates.
- **Usage**:
    ```julia
    templates = aitemplates("keyword")
    ```

## 7. Detailed Examples

### Multi-Turn Conversations with `@ai!_str`
```julia
ai!"And what is the population of it?"
```

### Asynchronous Execution
```julia
aai"Say hi but slowly!"gpt4
```

### Advanced Templating with Placeholders
```julia
msg = aigenerate(:JuliaExpertAsk, ask="How do I add packages?")
println(msg.content)
```

### Example of `aigenerate` with Model Aliases
```julia
PT.MODEL_ALIASES["gpt4t"] = "gpt-4-1106-preview"
ai"What is the capital of France?"gpt4t
```

## 8. Tips and Best Practices

### Ensure API Key is Set Correctly
1. **In Julia**: `ENV["OPENAI_API_KEY"] = "your-api-key"`
2. **In Terminal**: 
    - Windows: `set OPENAI_API_KEY=your-api-key`
    - macOS/Linux: `export OPENAI_API_KEY=your-api-key`

### Use Templated Prompts for Reusability
- Leverage pre-defined prompts using `aigenerate` for repetitive tasks.

### Optimize Performance with Asynchronous Calls
- Use `@aai_str` for non-blocking operations in the REPL.

### Explore and Use Available Templates
- Discover templates with `aitemplates("keyword")`

## 9. Additional Resources

### Documentation
- **[Stable Documentation](https://svilupp.github.io/PromptingTools.jl/stable/)**
- **[Developer Documentation](https://svilupp.github.io/PromptingTools.jl/dev/)**

### GitHub Repository
- **[PromptingTools.jl on GitHub](https://github.com/svilupp/PromptingTools.jl)**

---

This cheatsheet aims to help you harness the full potential of PromptingTools.jl efficiently. Happy coding!