# **AIHelpMe.jl Cheatsheet**

## **Package Name**: AIHelpMe.jl

## **URL**: [AIHelpMe.jl GitHub Repository](https://github.com/svilupp/AIHelpMe.jl)

---

## **Purpose**
**AIHelpMe.jl** integrates advanced AI models with Julia's extensive documentation to provide tailored coding guidance. It enhances productivity by offering context-aware answers directly within the Julia environment.

---

## **Installation**

To install AIHelpMe.jl, open your Julia REPL and run:
```julia
using Pkg
Pkg.add("AIHelpMe")
```

**Prerequisites:**
- Julia 1.10 or later.
- OpenAI API Key (set as an environment variable `OPENAI_API_KEY`).
- Cohere API Key and Tavily API Key for additional functionalities.

---

## **Usage Overview**

### **Basic Usage**

To start using AIHelpMe, import the package:
```julia
using AIHelpMe
```

Ask a question:
```julia
aihelp("How do I implement quicksort in Julia?")
```

Pretty-print the response:
```julia
using AIHelpMe: pprint

result = aihelp("How do I implement quicksort in Julia?", return_all=true)
pprint(result)
```

### **Using the Macro**
```julia
aihelp"how to implement quicksort in Julia?"
```

### **Follow-up Questions**
```julia
aihelp!"Can you elaborate on the `sort` function?"
```
Use the `!` for follow-up questions.

---

## **Main Features and Functions**

### **1. aihelp**
Generates a response for a given question using RAG approach.
#### **Usage with Explicit RAG Config and Chunk Index:**
```julia
using AIHelpMe: aihelp, pprint, build_index

# Create an index that contains Makie.jl documentation
index = build_index(...)

# Define the question
question = "How to make a barplot in Makie.jl?"

# Get the response
msg = aihelp(index, question)
println(msg)

# Optionally, get detailed response and pretty-print
result = aihelp(index, question; return_all = true)
pprint(result)
```

#### **Usage with Pre-loaded Knowledge Pack:**
```julia
using AIHelpMe: aihelp, pprint

# Load Makie knowledge pack
AIHelpMe.load_index!(:makie)

# Define the question
question = "How to make a barplot in Makie.jl?"

# Get the response without providing the index explicitly
msg = aihelp(question)
println(msg)

# Optionally, get detailed response and pretty-print
result = aihelp(question; return_all = true)
pprint(result) 
```

#### **Advanced Usage with Web Search and Reranking:**
```julia
using AIHelpMe: aihelp, pprint

# Define the question
question = "How to make a barplot in Makie.jl?"

# Use search and rerank functionalities and pretty-print the result
result = aihelp(question; search = true, rerank = true, return_all = true)
pprint(result)
```

---

### **2. Macros:**

#### **@aihelp_str**
```julia
using AIHelpMe

# Example usage
@aihelp_str "Give me an example of using the aihelp function"
```

#### **@aihelp!_str**
```julia
using AIHelpMe

# Example usage
@aihelp!_str "Show the AIHelpMe usage instructions"
```

---

### **3. Functions from Included Files:**

#### **From `utils.jl`:**

- `remove_pkgdir(filepath::AbstractString, mod::Module)`: Cleans up the package directory from the file path.

#### **From `user_preferences.jl`:**

- `set_preferences!(pairs::Pair{String, <:Any}...)`: Sets user preferences.

- `get_preferences(key::String)`: Fetches the current setting for a given preference key.

---

### **4. Managing Preferences:**

#### **Setting Preferences:**
```julia
AIHelpMe.set_preferences!("MODEL_CHAT" => "llama3", "MODEL_EMBEDDING" => "nomic-embed-text", "EMBEDDING_DIMENSION" => 0)
```

#### **Getting Preferences:**
```julia
println(AIHelpMe.get_preferences("MODEL_CHAT"))
```

---

### **5. Handling Indices:**

#### **Load Index:**
```julia
AIHelpMe.load_index!(file_path::AbstractString)    # From file path
AIHelpMe.load_index!(index::RT.AbstractChunkIndex) # From an index object
AIHelpMe.load_index!([:julia, :makie])             # From predefined artifacts
```

#### **Update Index:**
```julia
AIHelpMe.update_index() |> AIH.load_index!

# Or for an explicit index
index = AIHelpMe.update_index(index)
```

#### **Build Index:**
```julia
index = AIHelpMe.build_index([Module1, Module2], verbose=2)
```

---

## **Detailed Examples:**

### **Generating a Response:**
1. **Basic Example:**
   ```julia
   using AIHelpMe: aihelp
   
   response = aihelp("What is a DataFrame?")
   println(response)
   ```

2. **Using a Macro:**
   ```julia
   using AIHelpMe
   
   aihelp"How to implement a quicksort in Julia?"
   ```

3. **Advanced Use with Web Search:**
    ```julia
    using AIHelpMe: aihelp, pprint

    # Use advanced features
    question = "How to create a heatmap in Makie.jl?"
    result = aihelp(question; search = true, rerank = true, return_all = true)
    pprint(result)
    ```

---

## **Tips and Best Practices:**

1. **Environment Setup:**
   - Set `OPENAI_API_KEY` environment variable.

2. **Function Arguments:**
   - Prefer keyword arguments for clarity.

3. **Customize RAG Pipelines:**
   - To include specific knowledge from loaded packages or additional context.
   - `update_pipeline!(:bronze)` initializes a basic pipeline.

4. **Debugging and Context Inspection:**
   - Use `pprint(last_result())` to debug the AI responses and context provided.

5. **Local Model Support:**
   - For local models, such as Ollama models, refer to the specific usage guides.

---

## **Additional Resources:**

For further reading, refer to the following resources:
- [AIHelpMe.jl Documentation](https://github.com/svilupp/AIHelpMe.jl)
- [PromptingTools.jl RAG Tools](https://svilupp.github.io/PromptingTools.jl/dev/extra_tools/rag_tools_intro)
- [Julia Documentation](https://docs.julialang.org/)

---

This cheatsheet provides a comprehensive guide for newcomers to start using AIHelpMe.jl effectively. Happy coding!