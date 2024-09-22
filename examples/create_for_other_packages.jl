# This script creates cheatsheets for a list of popular Julia packages.

using LLMCheatsheets

repos = [
    GitHubRepo("https://github.com/svilupp/LLMCheatsheets.jl"),
    GitHubRepo("https://github.com/svilupp/AIHelpMe.jl"),
    GitHubRepo("https://github.com/JuliaData/DataFrames.jl"),
    GitHubRepo("https://github.com/JuliaData/DataFramesMeta.jl"),
    GitHubRepo("https://github.com/JuliaData/CSV.jl"),
    GitHubRepo("https://github.com/JuliaWeb/HTTP.jl"),
    GitHubRepo("https://github.com/JuliaAI/MLFlowClient.jl"),
    GitHubRepo("https://github.com/GenieFramework/Genie.jl"),
    # GitHubRepo("https://github.com/GenieFramework/Stipple.jl"),
    GitHubRepo("https://github.com/GenieFramework/StippleUI.jl"),
    GitHubRepo("https://github.com/JuliaAI/MLJ.jl"),
    GitHubRepo("https://github.com/JuliaPlots/StatsPlots.jl"; paths = ["src", "README.md"]),
    GitHubRepo(
        "https://github.com/MakieOrg/Makie.jl"; paths = ["docs/src", "README.md"]),
    GitHubRepo("https://github.com/MakieOrg/AlgebraOfGraphics.jl")
]

for url in repos
    repo = GitHubRepo(url)
    @info "Repo: $(repo.owner)/$(repo.name)"
    create_cheatsheet(repo; save_path = true, model = "gpt4o")
end;

repo = GitHubRepo("https://github.com/GenieFramework/Stipple.jl")
create_cheatsheet(repo; save_path = true, model = "gpt4o",
    special_instructions = """
Focus on a lot of practical examples with `@app` macro. Include examples of handlers with `@in`,`@out`,`@onchange`, `@onclick`, `@page` and more.
Include as much actual examples as possible, but they must be faithful to the user inputs.

Add a few practical examples of creating a ui.

You are not allowed to use any content not directly provided in the source materials.
""")