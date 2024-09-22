# LLMCheatsheets.jl Documentation

## Overview

LLMCheatsheets.jl makes it easy and instant to teach AI models about new packages and repositories by creating cheatsheets from GitHub repositories. This tool aims to bridge the gap between human-accessible documentation and AI-friendly knowledge representation.

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

## Quick Start

Here's a basic example of how to use LLMCheatsheets.jl to create a cheatsheet for a GitHub repository.

```julia
using LLMCheatsheets

repo = GitHubRepo("https://github.com/svilupp/PromptingTools.jl")
create_cheatsheet(repo; save_path = true);
```

With `save_path = true`, the cheatsheet will be saved to folder `llm-cheatsheets` in the current working directory.

What happens behinds the scenes:

1. The repository is scanned to find all the relevant files (that match `repo.paths` and `repo.file_types`).
2. Each file is summarized using an LLM.
3. The summaries are used to generate a cheatsheet.

For a low-level interface to generate the files individually and process them yourself, see `examples/create_for_promptingtools.jl`.

Sometimes you might want to just download the files without summarizing them. You can do that with `collect` function.

```julia
files_str = collect(repo)
```

`files_str` will be a string with all scanned files concatenated together. 
To use it in ChatGPT or Claude.ai, use `clipboard` functionality to copy it to clipboard - `files_str|>clipboard`.

By default, the files scanned and downloaded are `repo.paths` and `repo.file_types`, respectively.

## Advanced Usage

### Using a different LLM

You can use a different LLM by passing the `model` argument to the functions.

```julia
create_cheatsheet(repo; save_path = true, model = "gpt4om")
```

### Using PromptingTools.jl to Ask Questions

You can simply export also ai* functions from PromptingTools.jl to use them with LLMCheatsheets.jl.

```julia
using LLMCheatsheets
# Re-export aigenerate, pprint from PromptingTools
using LLMCheatsheets: aigenerate, pprint
# Or import PromptingTools directly
# using PromptingTools

repo = GitHubRepo("https://github.com/svilupp/PromptingTools.jl")
files_str = collect(repo)

msg = aigenerate("What is the function for create prompts?\n Check these files:\n$files_str")
pprint(msg)
```

## Frequently Asked Questions

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