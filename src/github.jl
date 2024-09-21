
"""
    GitHubRepo(url::String; paths = ["src", "docs/src", "README.md"],
        file_types = [".jl", ".md"])

Creates a `GitHubRepo` object to represent a target GitHub repository.

# Arguments
- `url::String`: The URL of the GitHub repository.
- `paths::Vector{String}`: The folders and files to scan.
- `file_types::Vector{String}`: The file types to accept in the scan.

# Fields
- `owner::String`: The owner of the repository.
- `name::String`: The name of the repository.
- `url::String`: The URL of the repository.
- `paths::Vector{String}`: The folders and files to scan.
- `file_types::Vector{String}`: The file types to accept in the scan.

Note: Files and folders are scanned recursively.

Key methods: `scan_github_path`, `create_cheatsheet`, `collect`.
- `scan_github_path` is used to scan the repository and get the list of all relevant files.
- `create_cheatsheet` is used to create a cheatsheet from the repository.
- `collect` is used to collect the repository content into a single string (no summarization).

# Example
```julia
repo = GitHubRepo("https://github.com/username/repository")
files = scan_github_path(repo)
```

Let's create a cheatsheet and auto-save it to a file:
```julia
repo = GitHubRepo("https://github.com/username/repository")
cheatsheet = create_cheatsheet(repo; save_path = true)
```

Let's collect all the files in the repository (eg, for LLM calls):
```julia
repo = GitHubRepo("https://github.com/username/repository")
collated = collect(repo)
```
"""
struct GitHubRepo
    owner::String
    name::String
    url::String
    paths::Vector{String}
    file_types::Vector{String}

    function GitHubRepo(url::String; paths = ["src", "docs/src", "README.md"],
            file_types = [".jl", ".md"])
        parts = split(rstrip(url, '/'), '/')
        if length(parts) < 5 || parts[3] != "github.com"
            throw(ArgumentError("Invalid GitHub URL"))
        end
        new(parts[4], parts[5], url, paths, file_types)
    end
end

"""
    github_api(url::String; api_key::String=GITHUB_API_KEY, retries::Int=10)

Makes a GET request to the GitHub API with the specified URL.

# Arguments
- `url::String`: The GitHub API endpoint URL.
- `api_key::String`: The GitHub API key. Defaults to the global GITHUB_API_KEY.
- `retries::Int`: The number of retry attempts for the request. Defaults to 10.
- `kwargs`: Additional keyword arguments to pass to `HTTP.get`.

# Returns
- `HTTP.Response`: The response from the GitHub API.
- `JSON3.Object`: The parsed JSON response body.

# Throws
- `HTTP.ExceptionRequest.StatusError`: If the request fails after all retries.
"""
function github_api(
        url::String; api_key::String = GITHUB_API_KEY, retries::Int = 10, kwargs...)
    headers = [
        "X-GitHub-Api-Version" => "2022-11-28"
    ]
    if !isempty(api_key)
        push!(headers, "Authorization" => "Bearer $api_key")
    end
    response = HTTP.get(url; headers = headers, retries = retries, kwargs...)
    if response.status != 200
        error("Failed to fetch data in $url: HTTP $(response.status)")
    end

    return response, JSON3.read(response.body)
end

"""
    scan_github_path(repo::GitHubRepo, path::String; verbose = true,
        http_kwargs::NamedTuple = NamedTuple())

    scan_github_path(repo::GitHubRepo; verbose = true,
        http_kwargs::NamedTuple = NamedTuple())

Scans a specific path in a GitHub repository and returns a list of files it contains that meet the criteria in `repo`.
Scans any nested folders recursively.

Note: If you're getting rate limited by GitHub, set the API key in `ENV["GITHUB_API_KEY"]`.

# Arguments
- `repo::GitHubRepo`: The repository to scan.
- `path::String`: The path to scan in the repository. If path is not provided, it will scan all paths in the repo object.
- `verbose::Bool`: Whether to print verbose output.
- `http_kwargs::NamedTuple`: Additional keyword arguments to pass to `github_api`.

# Returns
- `Vector{JSON3.Object}`: A list of files and folders in the specified path.
"""
function scan_github_path(repo::GitHubRepo, path::String; verbose = true,
        http_kwargs::NamedTuple = NamedTuple())
    ## Make API call
    url = "https://api.github.com/repos/$(repo.owner)/$(repo.name)/contents/$path"
    resp, body = github_api(url; http_kwargs...)

    ## Parse the response
    files = JSON3.Object[]
    folders = String[]

    if body isa AbstractDict
        body[:type] == "file" && push!(files, body)
    else
        for item in body
            if item[:type] == "file"
                push!(files, item)
            elseif item[:type] == "dir"
                push!(folders, path * "/" * item[:name])
            end
        end
    end
    ## Filter out files that are not in the file_types
    if !isempty(repo.file_types)
        filter!(
            file -> any(haskey(file, :name) && endswith(file[:name], ext)
            for ext in repo.file_types), files)
    end

    verbose && @info "Found $(length(files)) files and $(length(folders)) folders in $path"
    ## Recursively scan sub-folders
    while !isempty(folders)
        folder = pop!(folders)
        files_ = scan_github_path(repo, folder; verbose, http_kwargs)
        append!(files, files_)
    end
    return files
end

function scan_github_path(repo::GitHubRepo; verbose = true,
        http_kwargs::NamedTuple = NamedTuple())
    start_time = time()
    verbose && @info "Scanning all files in $(repo.owner)/$(repo.name)"
    all_files = JSON3.Object[]
    verbose &&
        @info "Will scan the following paths: $(join(repo.paths, ", ")) and file types: $(join(repo.file_types, ", "))"
    for path in repo.paths
        files = scan_github_path(repo, path; verbose, http_kwargs)
        if isempty(files)
            @warn "No files found in path: $path"
            continue
        end
        append!(all_files, files)
    end
    verbose &&
        @info "Scanned $(length(all_files)) files in $(round(time() - start_time, digits = 1)) seconds."
    return all_files
end
