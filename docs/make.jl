using LLMCheatsheets
using Documenter

DocMeta.setdocmeta!(
    LLMCheatsheets, :DocTestSetup, :(using LLMCheatsheets); recursive = true)

makedocs(;
    modules = [LLMCheatsheets],
    authors = "J S <49557684+svilupp@users.noreply.github.com> and contributors",
    sitename = "LLMCheatsheets.jl",
    format = Documenter.HTML(;
        canonical = "https://svilupp.github.io/LLMCheatsheets.jl",
        edit_link = "main",
        assets = String[]
    ),
    pages = [
        "Home" => "index.md",
        "API" => "api.md"
    ]
)

deploydocs(;
    repo = "github.com/svilupp/LLMCheatsheets.jl",
    devbranch = "main"
)
