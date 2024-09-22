# LLMCheatsheets.jl

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://svilupp.github.io/LLMCheatsheets.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://svilupp.github.io/LLMCheatsheets.jl/dev/)
[![Build Status](https://github.com/svilupp/LLMCheatsheets.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/svilupp/LLMCheatsheets.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/svilupp/LLMCheatsheets.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/svilupp/LLMCheatsheets.jl)
[![Aqua](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)

**LLMCheatsheets.jl** is a Julia package that makes it easy and instant to teach AI models about new packages and repositories by creating cheatsheets from GitHub repositories. This tool bridges the gap between human-readable documentation and AI-friendly knowledge representation, allowing for seamless integration with language models and AI assistants.

By default, we take a subset of the folders and files in the provided repository and summarize them using an LLM into a single cheatsheet.

## Features

- **Instant cheatsheet generation** from GitHub repositories.
- **AI-friendly knowledge representation** by summarizing code and documentation (or just collate all the raw files into a single string).
- **Easy integration** with language models and AI assistants (just copy the cheatsheet into your prompt).
- **Support for any package** and easier to start than Retrieval Augmented Generation (RAG).

## Installation

To install LLMCheatsheets.jl, use the Julia package manager and the repo URL (it's not registered yet):

```julia
using Pkg
Pkg.add(url = "https://github.com/svilupp/LLMCheatsheets.jl")
```

> [!TIP]
> If you encounter rate limits when accessing the GitHub API, you can set up a personal access token and set it as an environment variable `GITHUB_API_KEY` to increase your request limit to 5000 per hour.

## Quick Start

Here's a basic example of how to use LLMCheatsheets.jl to create a cheatsheet for a GitHub repository.

```julia
using LLMCheatsheets

repo = GitHubRepo("https://github.com/svilupp/PromptingTools.jl")
create_cheatsheet(repo; save_path = true);
```

With `save_path = true`, the cheatsheet will be saved to folder `llm-cheatsheets` in the current working directory.

**What happens behind the scenes:**

1. **Scanning the Repository:** The repository is scanned to find all relevant files that match `repo.paths` and `repo.file_types`.
2. **Summarizing Files:** Each file is summarized using an LLM.
3. **Generating Cheatsheet:** The summaries are combined to generate a comprehensive cheatsheet.

For a low-level interface to generate the files individually and process them yourself, see `examples/create_for_promptingtools.jl`.

Sometimes you might want to just download the files without summarizing them. You can do that with `collect` function.

```julia
files_str = collect(repo)
```

`files_str` will be a string with all scanned files concatenated together. 
To use it in ChatGPT or Claude.ai, use `clipboard` functionality to copy it to clipboard - `files_str|>clipboard`.

By default, the files scanned and downloaded are `repo.paths` and `repo.file_types`, respectively.

## Advanced Usage

### Customizing scanned paths and file types

By default, `repo.paths` includes `["src", "docs/src", "README.md"]`, and `repo.file_types` includes `[".jl", ".md"]`. You can customize these when creating the `GitHubRepo` object:

Eg, adding a folder `examples` and `.txt` files to customize what we will summarize:

```julia
repo = GitHubRepo("https://github.com/username/repository"; paths = ["examples", "README.md"], file_types = [".jl", ".md", ".txt"])
```

### Using a different LLM

You can use a different LLM by passing the `model` argument to the functions.

```julia
create_cheatsheet(repo; save_path = true, model = "gpt4om")
```

### Adding Special Instructions

You can provide special instructions to guide the AI in generating the cheatsheet:

```julia
create_cheatsheet(repo; special_instructions = "Focus on the data structures and their interactions.")
```

### Using PromptingTools.jl to Ask Questions

You can simply export also ai* functions from PromptingTools.jl to use them with LLMCheatsheets.jl.

```julia
using LLMCheatsheets
# Re-export aigenerate, pprint from PromptingTools
using LLMCheatsheets: aigenerate, pprint
# Or import PromptingTools directly
# using PromptingTools

repo = GitHubRepo("https://github.com/svilupp/PromptingTools.jl"; paths = ["docs/src", "README.md"])
files_str = collect(repo)

msg = aigenerate("Read through these files: $(files_str)\n\nAnswer the question: What is the function for creating prompt templates?")
pprint(msg)
```

````plaintext
The function for creating prompt templates in the `PromptingTools.jl` package is `create_template`. This function allows you to define a prompt with placeholders and save it for later use. The syntax is:

```julia
create_template(; user=<user prompt>,
system=<system prompt>, load_as=<template name>)
```

This function generates a vector of messages, which you can use directly in the `ai*` functions. If you provide the `load_as` argument, it will also register the template in the template store,
allowing you to access it later using its name.
````

## Frequently Asked Questions

### I am getting rate-limited by LLM providers

If you are getting rate-limited by LLM providers, you can decrease the number of concurrent summarization tasks in `create_cheatsheet` by setting a lower number like `ntasks=5` or `ntasks=2` (depends on your API tier).

### I am getting rate-limited by GitHub API

Set up a personal access token and set it as `ENV["GITHUB_API_KEY"]`.
It will be automatically loaded into a variable `LLMCheatsheets.GITHUB_API_KEY`.

### How do I set up a personal access token for GitHub API?

You can set up a personal access token for GitHub API by following these steps:

1. Go to your [GitHub settings](https://github.com/settings/tokens).
2. Click on "Personal access tokens".
3. Click on "Generate new token".

Then you can set it as `ENV["GITHUB_API_KEY"]` or `LLMCheatsheets.GITHUB_API_KEY`.

## Documentation

For more information about using LLMCheatsheets.jl, please refer to the [documentation](https://svilupp.github.io/LLMCheatsheets.jl/dev/).

## Issues and Support

If you encounter any issues or have questions, please [open an issue](https://github.com/svilupp/LLMCheatsheets.jl/issues) on the GitHub repository.