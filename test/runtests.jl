using Test, JSON3
using LLMCheatsheets
using Mocking
using PromptingTools
const PT = PromptingTools
using Aqua

Mocking.activate()

@testset "LLMCheatsheets.jl" begin
    @testset "Code quality (Aqua.jl)" begin
        Aqua.test_all(LLMCheatsheets)
    end

    include("github.jl")
    include("cheatsheet_creation.jl")
    include("file_processing.jl")
end
