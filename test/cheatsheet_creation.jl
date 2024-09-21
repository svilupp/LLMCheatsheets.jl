# Requires mocking
# @testset "create_cheatsheet" begin
#     # Test create_cheatsheet with mock data
#     repo = GitHubRepo("https://github.com/username/repository")
#     mock_file_contents = [
#         Dict(:name => "file1.jl", :content => "# File 1 content"),
#         Dict(:name => "file2.md", :content => "# File 2 content")
#     ]

#     # Test without saving
#     cheatsheet = create_cheatsheet(repo, mock_file_contents)
#     @test typeof(cheatsheet) == String
#     @test !isempty(cheatsheet)

#     # Test with saving (using a temporary directory)
#     temp_dir = mktempdir()
#     save_path = joinpath(temp_dir, "test_cheatsheet.md")
#     cheatsheet_saved = create_cheatsheet(repo, mock_file_contents; save_path = save_path)
#     @test isfile(save_path)
#     @test read(save_path, String) == cheatsheet_saved
# end

# Requires mocking
# @testset "collect" begin
#     # Test collect function
#     repo = GitHubRepo("https://github.com/username/repository")

#     # Mock the scan_github_path and github_api functions
#     function mock_scan_github_path(repo, path; kwargs...)
#         [Dict(:name => "file1.jl", :download_url => "https://example.com/file1.jl")]
#     end
#     function mock_github_api(url; kwargs...)
#         (body = "File content")
#     end

#     # Apply the mocks
#     original_scan = LLMCheatsheets.scan_github_path
#     original_api = LLMCheatsheets.github_api
#     LLMCheatsheets.scan_github_path = mock_scan_github_path
#     LLMCheatsheets.github_api = mock_github_api

#     # Test collection
#     collected_content = collect(repo)
#     @test contains(collected_content, "file1.jl")
#     @test contains(collected_content, "File content")

#     # Test saving collected content
#     temp_dir = mktempdir()
#     save_path = joinpath(temp_dir, "test_collection.txt")
#     collect(repo; save_path = save_path)
#     @test isfile(save_path)
#     @test read(save_path, String) == collected_content

#     # Restore original functions
#     LLMCheatsheets.scan_github_path = original_scan
#     LLMCheatsheets.github_api = original_api
# end
