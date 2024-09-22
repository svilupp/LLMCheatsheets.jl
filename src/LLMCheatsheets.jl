module LLMCheatsheets

using HTTP
using JSON3
using Mocking
using PromptingTools
using PromptingTools: aigenerate, pprint, last_output, last_message
const PT = PromptingTools

global GITHUB_API_KEY::String = ""

export GitHubRepo, scan_github_path
include("github.jl")

export summarize_file, collate_files
include("file_processing.jl")

export create_cheatsheet
include("cheatsheet_creation.jl")

function __init__()
    global GITHUB_API_KEY
    GITHUB_API_KEY = get(ENV, "GITHUB_API_KEY", "")
    ## Load extra templates
    PT.load_templates!(joinpath(@__DIR__, "..", "templates"); remember_path = true) # add our custom ones
end

end # module
