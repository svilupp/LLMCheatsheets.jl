# LLMCheatsheets.jl Cheatsheet

## Package Name
LLMCheatsheets.jl

## URL
[LLMCheatsheets.jl GitHub Repository](https://github.com/svilupp/LLMCheatsheets.jl)

## Purpose
LLMCheatsheets.jl is designed to generate AI-friendly documentation cheatsheets by summarizing the content of GitHub repositories. It facilitates seamless integration with language models and AI assistants for quick and comprehensive documentation.

## Installation
To install LLMCheatsheets.jl, use the Julia package manager with the repository URL:

```julia
using Pkg
Pkg.add(url = "https://github.com/svilupp/LLMCheatsheets.jl")
```

> **Tip**: Set up a personal access token with `ENV["GITHUB_API_KEY"]` to avoid GitHub API rate limits.

## Usage Overview
Import the package and initialize it for use:

```julia
using LLMCheatsheets
```

### Example: Create a Cheatsheet for a GitHub Repository
```julia
repo = GitHubRepo("https://github.com/svilupp/PromptingTools.jl")
create_cheatsheet(repo; save_path = true)
```

## Main Features and Functions

### `GitHubRepo`
Represents a GitHub repository and contains configuration for scanning files.

**Constructor:**
```julia
GitHubRepo(url::String; paths = ["src", "docs/src", "README.md"], file_types = [".jl", ".md"])
```

**Fields:**

- `owner::String`: Repository owner.
- `name::String`: Repository name.
- `url::String`: Repository URL.
- `paths::Vector{String}`: Folders and files to scan.
- `file_types::Vector{String}`: Accepted file types in the scan.

**Example:**
```julia
repo = GitHubRepo("https://github.com/username/repository")
```

### `summarize_file`
Summarizes the content of a file in a GitHub repository.

**Function Signature:**
```julia
summarize_file(file_info::AbstractDict; 
               model = "gpt4o", 
               special_instructions::AbstractString = "None.\n", 
               cost_tracker::Union{Nothing, Threads.Atomic{<:Real}} = nothing, 
               verbose::Bool = true, 
               http_kwargs::NamedTuple = NamedTuple())
```

**Arguments:**
- `file_info::AbstractDict`: Dictionary with `:name` and `:download_url`.
- `model::String`: AI model.
- `special_instructions::AbstractString`: Instructions for AI's output.
- `cost_tracker::Union{Nothing, Threads.Atomic{<:Real}}`: Optional cost tracker.
- `verbose::Bool`: Enables verbose output.
- `http_kwargs::NamedTuple`: Additional HTTP arguments.

**Returns:**
- `Dict`: Contains file name, summarized content, and type.

**Example:**
```julia
file_info = Dict(:name => "example.jl", :download_url => "https://github.com/user/repo/raw/main/example.jl")
result = summarize_file(file_info)
println(result[:content])
```

### `collate_files`
Collates multiple file contents into a single string.

**Function Signature:**
```julia
collate_files(file_contents::AbstractVector{<:AbstractDict})
```

**Arguments:**
- `file_contents::AbstractVector{<:AbstractDict}`: Vector of dictionaries containing file names and contents.

**Returns:**
- `String`: Concatenated names and contents of files.

**Example:**
```julia
file_contents = [
    Dict(:name => "file1.jl", :content => "Content of file 1"),
    Dict(:name => "file2.jl", :content => "Content of file 2")
]
collated_content = collate_files(file_contents)
println(collated_content)
```

### `create_cheatsheet`
Generates a cheatsheet for a GitHub repository and its file summaries.

**Function Signature:**
```julia
create_cheatsheet(repo::GitHubRepo, 
                  file_contents::AbstractVector{<:AbstractDict}; 
                  model = "gpt4o", 
                  special_instructions::AbstractString = "None.\n", 
                  template::Symbol = :CheatsheetCreator, 
                  cost_tracker::Union{Nothing, Threads.Atomic{<:Real}} = nothing, 
                  verbose::Bool = true, 
                  save_path::Union{Nothing, String, Bool} = nothing, 
                  http_kwargs::NamedTuple = NamedTuple()) -> String
```

**Arguments:**
- `repo::GitHubRepo`: GitHub repository.
- `file_contents::AbstractVector{<:AbstractDict}`: File summaries.
- `model::String`: LLM model.
- `special_instructions::AbstractString`: AI output instructions.
- `template::Symbol`: Template for cheatsheet.
- `cost_tracker::Union{Nothing, Threads.Atomic{<:Real}}`: Cost tracker.
- `verbose::Bool`: Verbose output.
- `save_path::Union{Nothing, String, Bool}`: Path to save the cheatsheet.
- `http_kwargs::NamedTuple`: Extra HTTP arguments.

**Returns:**
- `String`: Cheatsheet content.

**Example:**
```julia
repo = GitHubRepo("https://github.com/svilupp/PromptingTools.jl")
cheatsheet_content = create_cheatsheet(repo)
println(cheatsheet_content)
```

### `Base.collect`
Scans a GitHub repository, downloads all file contents, and collates them into a single document.

**Function Signature:**
```julia
Base.collect(repo::GitHubRepo; 
             verbose::Bool = true, 
             save_path::Union{Nothing, String, Bool} = nothing, 
             ntasks::Int = 0, 
             http_kwargs::NamedTuple = NamedTuple()) -> String
```

**Arguments:**
- `repo::GitHubRepo`: Repository to scan.
- `verbose::Bool`: Verbose output.
- `save_path::Union{Nothing, String, Bool}`: Path to save collated content.
- `ntasks::Int`: Number of tasks for asynchronous processing.
- `http_kwargs::NamedTuple`: Extra HTTP arguments.

**Returns:**
- `String`: Collated file contents.

**Example:**
```julia
repo = GitHubRepo("https://github.com/username/repository")
collated_content = Base.collect(repo)
println(collated_content)
```

## Tips and Best Practices
- **API Rate Limits**: Configure a GitHub personal access token as `ENV["GITHUB_API_KEY"]` to enhance API rate limits.
- **Verbose Mode**: Use `verbose = true` for detailed output during operations.
- **Special Instructions**: Tailor the AI output by providing specific `special_instructions`.
- **Cost Tracking**: Utilize `cost_tracker` to monitor the cost if making multiple AI calls.
- **Custom Paths and File Types**: Customize `paths` and `file_types` in `GitHubRepo` to focus scans on relevant files.

## Additional Resources

- **Documentation**: [LLMCheatsheets.jl Documentation](https://svilupp.github.io/LLMCheatsheets.jl/dev/)
- **GitHub Issues**: [LLMCheatsheets.jl Issues](https://github.com/svilupp/LLMCheatsheets.jl/issues) for support and bug reports.

By following this cheatsheet, you will be able to effectively use LLMCheatsheets.jl to generate comprehensive, AI-friendly documentation from GitHub repositories. Happy coding!