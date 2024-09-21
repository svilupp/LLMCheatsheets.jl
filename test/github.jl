using LLMCheatsheets: GitHubRepo, github_api, scan_github_path

@testset "GitHubRepo" begin
    # Test GitHubRepo constructor
    @test_throws ArgumentError GitHubRepo("https://invalid-url.com")

    repo = GitHubRepo("https://github.com/username/repository")
    @test repo.owner == "username"
    @test repo.name == "repository"
    @test repo.url == "https://github.com/username/repository"
    @test repo.paths == ["src", "docs/src", "README.md"]
    @test repo.file_types == [".jl", ".md"]

    # Test with custom paths and file types
    repo_custom = GitHubRepo("https://github.com/username/repository";
        paths = ["custom_path"],
        file_types = [".txt"])
    @test repo_custom.paths == ["custom_path"]
    @test repo_custom.file_types == [".txt"]
end

@testset "github_api" begin
    # Test successful API call
    response, body = github_api("https://api.github.com/repos/octocat/Hello-World/contents/README")
    @test response.status == 200
    @test haskey(body, :name)

    # Test API call with invalid URL
    @test_throws Exception github_api("https://api.github.com/invalid")
end

@testset "scan_github_path" begin
    # Test scanning a valid path
    repo = GitHubRepo("https://github.com/octocat/Hello-World"; file_types = [])
    files = scan_github_path(repo, "README")
    @test length(files) > 0
    @test all(file -> haskey(file, :name), files)
    @test all(file -> haskey(file, :download_url), files)

    # Test scanning with invalid file types filter
    repo = GitHubRepo("https://github.com/octocat/Hello-World"; file_types = [".md"])
    @test isempty(scan_github_path(repo, ""))

    # Scan all paths in the repo
    repo = GitHubRepo(
        "https://github.com/octocat/Hello-World"; file_types = [], paths = ["README"])
    files = scan_github_path(repo)
    @test length(files) > 0
    @test all(file -> haskey(file, :name), files)
    @test all(file -> haskey(file, :download_url), files)
end
