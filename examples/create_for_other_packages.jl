# This script creates cheatsheets for a list of popular Julia packages.

using LLMCheatsheets

repos = [
    "https://github.com/svilupp/LLMCheatsheets.jl",
    "https://github.com/svilupp/AIHelpMe.jl",
    "https://github.com/JuliaData/DataFrames.jl",
    "https://github.com/JuliaData/DataFramesMeta.jl",
    "https://github.com/JuliaData/CSV.jl",
    "https://github.com/JuliaWeb/HTTP.jl",
    "https://github.com/JuliaAI/MLFlowClient.jl",
    "https://github.com/GenieFramework/Genie.jl",
    "https://github.com/GenieFramework/Stipple.jl",
    "https://github.com/GenieFramework/StippleUI.jl",
    "https://github.com/JuliaAI/MLJ.jl",
    "https://github.com/JuliaPlots/StatsPlots.jl",
    "https://github.com/MakieOrg/Makie.jl",
    "https://github.com/MakieOrg/AlgebraOfGraphics.jl"
]

for repo in repos
    create_cheatsheet(repo; save_path = true, model = "gpt4o")
end;