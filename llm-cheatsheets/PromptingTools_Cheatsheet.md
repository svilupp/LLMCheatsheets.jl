# PromptingTools.jl Cheatsheet

## 1. Name of the Package
**PromptingTools.jl**

## 2. URL
[PromptingTools.jl on GitHub](https://github.com/svilupp/PromptingTools.jl)

## 3. Purpose
PromptingTools.jl aims to simplify interactions with large language models (LLMs) by providing various utilities for text generation, embedding, classification, extraction, and more. It allows users to efficiently handle APIs, build templates, and augment AI-generated responses with meaningful and structured prompts.

## 4. List of Main Functions

### Basic Functionality
- `ai`
- `@ai!_str`
- `aigenerate`
- `aiembed`
- `aiclassify`
- `aiextract`
- `aiscan`
- `aiimage`
- `airetry!`
- `aitemplates`

### Advanced and Utility Functions
- `load_templates!`
- `aigenerate` (with templates)
- `aitemplates` (searching templates)
- `truncate_conversation`
- `gamma_sample`
- `replace_words`
- `score_to_unit_scale`
- `AsyncMap`
- `build_index`
- `retrieve`
- `generate!`
- `run_qa_evals`

## 5. Detailed Examples for All Relevant Functionality with Comments

### Basic Functionality

#### `ai` - Generating a response
```julia
# Generate a response for a simple question
ai"What is the capital of France?"
# AIMessage("The capital of France is Paris.")
```

#### `@ai!_str` - Continuing a conversation
```julia
# Continue the conversation based on the previous response
ai!"And what is the population of it?"
```

#### `aigenerate` - Generating text responses
```julia
# Generate a textual response with a templated question
msg = aigenerate("What is the capital of {{country}}?"; country="Spain")
# AIMessage("The capital of Spain is Madrid.")

# Using a Predefined Template
msg = aigenerate(:JuliaExpertAsk; ask = "How do I add packages?")
```

#### `aiembed` - Extracting embeddings
```julia
# Extract embeddings for a piece of text
embedding = aiembed("The concept of artificial intelligence.").content
```

#### `aiclassify` - Classifying input text
```julia
# Classify the given input into predefined categories
result = aiclassify("Is two plus two four?")
# Possible output: AIMessage("Yes, it is four.")
```

#### `aiextract` - Extracting structured data
```julia
struct CurrentWeather
    location::String
    unit::Union{Nothing,TemperatureUnits}
end

# Extract structured data about the current weather
msg = aiextract("What's the weather in Salt Lake City in C?"; return_type=CurrentWeather)
```

#### `aiscan` - Interacting with images
```julia
# Analyze an image and provide a textual description
msg = aiscan("Describe the image"; image_path="julia.png")
```

#### `aiimage` - Generating images using models like DALL-E
```julia
# Generate an image based on a textual prompt
msg = aiimage("Generate an image of a sunset.")
```

#### `airetry!` - Retrying AI calls based on conditions
```julia
# Retry operation if an AI model fails to meet conditions
airetry!(condition_function, aicall::AICall, feedback_function)
```

### Advanced and Utility Functions

#### `load_templates!` - Loading templates
```julia
# Load templates from the templates directory
using PromptingTools
const PT = PromptingTools
PT.load_templates!();
```

#### `aitemplates` - Searching available templates
```julia
# Search and display available templates matching "Julia"
templates = aitemplates("Julia")
```

#### `truncate_conversation` - Truncating conversations
```julia
# Truncate a conversation to a specified maximum length
conversation = [
    PT.UserMessage("Hello"), 
    PT.AIMessage("Hi there!"),
    PT.UserMessage("Can you help me with something?"),
    PT.AIMessage("Sure, what do you need?")
]
truncated_conv = truncate_conversation(conversation, max_conversation_length=50)
```

#### `gamma_sample` - Sampling from the Gamma distribution
```julia
# Sample a Gamma distribution with specific shape and scale
sample = gamma_sample(2.0, 3.0)
println("Gamma Sample: $sample")
```

#### `replace_words` - Masking sensitive words
```julia
# Mask sensitive words in the text for privacy
safe_text = replace_words("This is a secret message.", ["secret" => "[REDACTED]"])
```

#### `score_to_unit_scale` - Normalizing scores
```julia
# Normalize a vector of scores to the unit scale [0, 1]
x = [1.0, 2.0, 3.0, 4.0, 5.0]
scaled_x = score_to_unit_scale(x)
println(scaled_x)  # Output: Scaled values between 0 and 1
```

#### `AsyncMap` - Asynchronously processing multiple prompts
```julia
# Run multiple AI tasks concurrently using AsyncMap
responses = asyncmap(aigenerate, ["Translate 'Hello' to Spanish", "Translate 'Hello' to French"])
```

#### `build_index` - Building index for RAG applications
```julia
# Build an index of document chunks for RAG applications
files = [
    joinpath("examples", "data", "database_style_joins.txt"),
    joinpath("examples", "data", "what_is_dataframes.txt"),
]
index = build_index(files; extract_metadata = false)
```

#### `retrieve` - Retrieving relevant chunks
```julia
# Retrieve relevant chunks from the index for a given question
result = retrieve(index, "What are the best practices for parallel computing in Julia?")
```

#### `generate!` - Generating answers based on retrieval
```julia
# Generate an answer based on the retrieved chunks
result = generate!(index, retrieved_result)
```

#### `run_qa_evals` - Running QA evaluations
```julia
# Run quality evaluations on question-answer pairs
results = run_qa_evals(evals[10], ctx; parameters_dict = Dict(:top_k => 3), verbose = true, model_judge = "gpt4t")
```

## Closing Note
By understanding these functions, best practices, and potential caveats, junior developers can effectively utilize the PromptingTools.jl package to enhance their projects with AI capabilities. This cheatsheet should serve as a quick reference guide to get started with using and implementing the functionalities offered by the package.