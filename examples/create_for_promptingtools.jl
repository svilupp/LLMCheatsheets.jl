# # Example 1: Create a cheatsheet for the PromptingTools.jl package

using LLMCheatsheets

# Note: if you're hitting Github's rate limits, make sure to set the `GITHUB_API_KEY` environment variable.

# # High-level example: Create a cheatsheet in two lines
repo = GitHubRepo("https://github.com/svilupp/PromptingTools.jl")
cheatsheet = create_cheatsheet(repo; save_path = true)
# will auto-save the cheatsheet in a file called `llm-cheatsheets/PromptingTools_Cheatsheet.md`
# Specify your own path, by setting `save_path` to a string representing the file path.

# # Detailed step-by-step example
# Step 1: Define the GitHub repository, paths to scan, and file types to summarize
repo = GitHubRepo("https://github.com/svilupp/PromptingTools.jl";
    paths = ["src", "docs/src", "README.md"], file_types = [".jl", ".md"])

# Step 2: Initialize the model and a cost tracker (optional, but useful for monitoring API usage)
model = "gpt4o" # or "gpt4om"
cost_tracker = Threads.Atomic{Float64}(0.0)
save_path = joinpath(@__DIR__, "My_PromptingTools_Cheatsheet.md")

# Step 3: Scan the repository and summarize files
all_file_summaries = Dict{Symbol, AbstractString}[]

## You can add a lot of custom detail to the summary by adding special instructions.
special_instructions = """When relevant, add a lot of detail for `create_template` to show how easy it is to create re-usable prompt templates.
Add some basic points on what a good prompt should have: Clear task description, guidelines/instructions, desired output format. 
All that should be in the `system` prompt, the `user` prompt should have just the placeholders for the inputs in double curly braces, eg, `{{input}}`.
""" # Use to customize the output

for path in repo.paths
    # Scan each path in the repository
    files = scan_github_path(repo, path)

    # Process each file asynchronously
    asyncmap(files) do file
        try
            # Summarize the file content
            summary = summarize_file(
                file;
                cost_tracker,
                model,
                special_instructions,
                verbose = false
            )
            push!(all_file_summaries, summary)
        catch e
            @warn "Error processing $(file[:name]): $e"
        end
    end
end

# Step 4: Create the cheatsheet
cheatsheet = create_cheatsheet(
    repo,
    all_file_summaries;
    model,
    special_instructions,
    cost_tracker,
    verbose = true,
    save_path   # This will save the cheatsheet to the file path specified in `save_path`
)

# Print some statistics
@info "Cheatsheet created! Total cost: \$$(round(cost_tracker[], digits=2))"
@info "Cheatsheet saved to: $(save_path)"

# You can now use the `cheatsheet` variable or read the saved markdown file
