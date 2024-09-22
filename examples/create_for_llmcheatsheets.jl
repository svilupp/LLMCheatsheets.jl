# # Example 2: Create a cheatsheet for the LLMCheatsheets.jl package

using LLMCheatsheets

# Note: if you're hitting Github's rate limits, make sure to set the `GITHUB_API_KEY` environment variable.

# # High-level example: Create a cheatsheet in two lines
repo = GitHubRepo("https://github.com/svilupp/LLMCheatsheets.jl")
cheatsheet = create_cheatsheet(repo; save_path = true)
# will auto-save the cheatsheet in a file called `llm-cheatsheets/LLMCheatsheets_Cheatsheet.md`
# Specify your own path, by setting `save_path` to a string representing the file path.

# # Grab all the files in the repo
files_str = collect(repo)