# LLMCheatsheets.jl

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://svilupp.github.io/LLMCheatsheets.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://svilupp.github.io/LLMCheatsheets.jl/dev/)
[![Build Status](https://github.com/svilupp/LLMCheatsheets.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/svilupp/LLMCheatsheets.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/svilupp/LLMCheatsheets.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/svilupp/LLMCheatsheets.jl)
[![Aqua](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)

## Overview

LLMCheatsheets.jl is a Julia package designed to make it easy and instant to teach AI about new packages and repositories by creating instant cheatsheets from GitHub repositories. This tool aims to bridge the gap between human-readable documentation and AI-friendly knowledge representation.

## Features

- Instant cheatsheet generation from GitHub repositories
- AI-friendly knowledge representation
- Easy integration with language models and AI assistants
- Support for various Julia packages and repositories

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

`files_str` will be a string with all scanned files concatenated together, eg, to use in ChatGPT or `claude.ai`.

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

## Documentation

For more information about using LLMCheatsheets.jl, please refer to the [documentation](https://svilupp.github.io/LLMCheatsheets.jl/dev/).

## Issues and Support

If you encounter any issues or have questions, please [open an issue](https://github.com/svilupp/LLMCheatsheets.jl/issues) on the GitHub repository.