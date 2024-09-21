using LLMCheatsheets

# @testset "summarize_file" begin
#     # Test summarize_file function
#     mock_file_info = Dict(
#         :name => "test_file.jl",
#         :download_url => "https://example.com/test_file.jl"
#     )

#     # Mock the github_api and aigenerate functions
#     function mock_github_api(url; kwargs...)
#         "Mock file content"
#     end
#     function mock_aigenerate(template; kwargs...)
#         (content = "Summarized content", cost = 0.1)
#     end

#     # Apply the mocks
#     original_api = LLMCheatsheets.github_api
#     original_aigenerate = LLMCheatsheets.aigenerate
#     LLMCheatsheets.github_api = mock_github_api
#     LLMCheatsheets.aigenerate = mock_aigenerate

#     # Test summarization
#     summary = summarize_file(mock_file_info)
#     @test summary[:file] == "test_file.jl"
#     @test summary[:content] == "Summarized content"
#     @test summary[:type] == "SUMMARY"

#     # Test cost tracking
#     cost_tracker = Threads.Atomic{Float64}(0.0)
#     summarize_file(mock_file_info; cost_tracker = cost_tracker)
#     @test cost_tracker[] ≈ 0.1

#     # Restore original functions
#     LLMCheatsheets.github_api = original_api
#     LLMCheatsheets.aigenerate = original_aigenerate
# end

@testset "collate_files" begin
    # Test collate_files function
    mock_file_contents = [
        Dict(:name => "file1.jl", :content => "Content of file 1"),
        Dict(:name => "file2.md", :content => "Content of file 2")
    ]

    collated = collate_files(mock_file_contents)
    @test contains(collated, "<file name=\"file1.jl\">")
    @test contains(collated, "<file name=\"file2.md\">")
    @test contains(collated, "Content of file 1")
    @test contains(collated, "Content of file 2")

    # Test with empty input
    @test_throws AssertionError collate_files(Dict[])

    # Test with invalid input
    @test_throws AssertionError collate_files([Dict(:invalid => "data")])
end
