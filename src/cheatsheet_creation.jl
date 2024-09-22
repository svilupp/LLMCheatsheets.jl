"""
    create_cheatsheet(
        repo::GitHubRepo, file_contents::AbstractVector{<:AbstractDict};
        model = "gpt4o", special_instructions::AbstractString = "None.\n",
        template::Symbol = :CheatsheetCreator,
        cost_tracker::Union{Nothing, Threads.Atomic{<:Real}} = nothing,
        verbose::Bool = true, save_path::Union{Nothing, String, Bool} = nothing,
        http_kwargs::NamedTuple = NamedTuple())

    create_cheatsheet(repo::GitHubRepo;
        model = "gpt4o", cost_tracker::Union{Nothing, Threads.Atomic{<:Real}} = Threads.Atomic{Float64}(0.0),
        special_instructions::AbstractString = "None.\n",
        template::Symbol = :CheatsheetCreator,
        verbose::Bool = true, save_path::Union{Nothing, String} = nothing,
        http_kwargs::NamedTuple = NamedTuple())

Creates a cheatsheet for the given GitHub repository and file summaries.

Note: If you're getting rate limited by GitHub API, request a personal access token and set it as `ENV["GITHUB_API_KEY"]` (raised your limit to 5000 requests per hour).

# Arguments
- `repo::GitHubRepo`: The repository to create a cheatsheet for.
- `file_contents::AbstractVector{<:AbstractDict}`: The file contents or the summaries of the files in the repository. If not provided, the repository is scanned and the file summaries are created.
- `model::String`: The model to use for the LLM call.
- `special_instructions::AbstractString`: Special instructions for the AI to tweak the output.
- `template::Symbol`: The template to use for the cheatsheet creation.
- `cost_tracker::Union{Nothing, Threads.Atomic{<:Real}}`: A tracker to record the cost of the LLM calls.
- `verbose::Bool`: Whether to print verbose output.
- `save_path::Union{Nothing, String, Bool}`: The path to save the cheatsheet to. If `true`, the cheatsheet is auto-saved to a subdirectory called `llm-cheatsheets` in the current working directory.
- `http_kwargs::NamedTuple`: Additional keyword arguments to pass to the `github_api` function influencing the HTTP requests.

# Returns
- `String`: The content of the cheatsheet.
"""
function create_cheatsheet(
        repo::GitHubRepo, file_contents::AbstractVector{<:AbstractDict};
        model = "gpt4o", special_instructions::AbstractString = "None.\n",
        template::Symbol = :CheatsheetCreator,
        cost_tracker::Union{Nothing, Threads.Atomic{<:Real}} = nothing,
        verbose::Bool = true, save_path::Union{Nothing, String, Bool} = nothing,
        http_kwargs::NamedTuple = NamedTuple())
    ##
    verbose && @info "Creating cheatsheet for $(repo.owner)/$(repo.name)"
    collated_summaries = collate_files(file_contents)
    response = aigenerate(template; url = repo.url, name = repo.name,
        files = collated_summaries, special_instructions, model = model, verbose)
    !isnothing(cost_tracker) && Threads.atomic_add!(cost_tracker, response.cost)
    if !isnothing(save_path)
        if save_path === true
            ## Save to pwd subdirectory
            save_path = joinpath(
                pwd(), "llm-cheatsheets", "$(replace(repo.name, ".jl"=>""))_Cheatsheet.md")
        end
        ## Create the directory if it doesn't exist
        mkpath(dirname(save_path))
        ## Write the cheatsheet to the file
        open(save_path, "w") do io
            write(io, response.content)
        end
    end
    return response.content
end

function create_cheatsheet(
        repo::GitHubRepo;
        model = "gpt4o", special_instructions::AbstractString = "None.\n",
        template::Symbol = :CheatsheetCreator,
        cost_tracker::Union{Nothing, Threads.Atomic{<:Real}} = Threads.Atomic{Float64}(0.0),
        verbose::Bool = true, save_path::Union{Nothing, String, Bool} = nothing,
        http_kwargs::NamedTuple = NamedTuple())
    start_time = time()
    all_file_summaries = Dict{Symbol, AbstractString}[]
    verbose &&
        @info "Will scan the following paths: $(join(repo.paths, ", ")) and file types: $(join(repo.file_types, ", "))"
    for path in repo.paths
        files = scan_github_path(repo, path; verbose, http_kwargs)
        if isempty(files)
            @warn "No files found in path: $path"
            continue
        end
        asyncmap(files) do file
            try
                summary = summarize_file(
                    file; cost_tracker, model, verbose = false, http_kwargs,
                    special_instructions)
                push!(all_file_summaries, summary)
            catch e
                @warn "Error processing $(file[:name]): $e"
            end
        end
    end
    if isempty(all_file_summaries)
        error("No files were successfully processed in any folder. Validate the paths and file types (Paths: $(join(repo.paths, ", ")), File types: $(join(repo.file_types, ", ")))")
    end
    ## Cheatsheet creation
    verbose && @info "Creating cheatsheet for $(repo.owner)/$(repo.name)"
    cheatsheet = create_cheatsheet(
        repo, all_file_summaries; model, special_instructions,
        cost_tracker, verbose = false, save_path, http_kwargs, template)
    verbose &&
        @info "Cheatsheet created and saved to $save_path. Duration: $(round(time() - start_time, digits = 1)) seconds. Total cost: \$$(round(cost_tracker[], digits = 3)) dollars."
    return cheatsheet
end

"""
    Base.collect(
        repo::GitHubRepo;
        verbose::Bool = true,
        save_path::Union{Nothing, String, Bool} = nothing,
        http_kwargs::NamedTuple = NamedTuple())


Scans a GitHub repository, downloads all the file contents, and combines them into a single large text document.

This function differs from `create_cheatsheet` in that it doesn't summarize or process the content into a cheatsheet,
but instead concatenates the raw content of all files that match the specified criteria.

Note: If you're getting rate limited by GitHub API, request a personal access token and set it as `ENV["GITHUB_API_KEY"]` (raised your limit to 5000 requests per hour).

# Arguments
- `repo::GitHubRepo`: The repository to scan.
- `verbose::Bool`: Whether to print verbose output.
- `save_path`: If provided, saves the collated content to this file path. If `true`, the content is saved to a subdirectory called `llm-cheatsheets` in the current working directory.
- `http_kwargs::NamedTuple`: Additional keyword arguments to pass to the `github_api` function influencing the HTTP requests.

# Returns
- `String`: The collated content of all scanned files and their contents in the repository.
"""
function Base.collect(
        repo::GitHubRepo;
        verbose::Bool = true,
        save_path::Union{Nothing, String, Bool} = nothing,
        http_kwargs::NamedTuple = NamedTuple()
)
    start_time = time()
    all_file_contents = Dict{Symbol, AbstractString}[]

    verbose &&
        @info "Scanning the following paths: $(join(repo.paths, ", ")) and file types: $(join(repo.file_types, ", "))"

    for path in repo.paths
        files = scan_github_path(repo, path; verbose, http_kwargs)
        if isempty(files)
            @warn "No files found in path: $path"
            continue
        end

        asyncmap(files) do file
            try
                response = github_api(file[:download_url]; http_kwargs...)
                content = String(response.body)
                push!(all_file_contents,
                    Dict(:name => file[:name], :content => content, :type => "FILE"))
            catch e
                @warn "Error processing $(file[:name]): $e"
            end
        end
    end

    if isempty(all_file_contents)
        error("No files were successfully processed in any folder. Validate the paths and file types (Paths: $(join(repo.paths, ", ")), File types: $(join(repo.file_types, ", ")))")
    end

    collated_content = collate_files(all_file_contents)

    if save_path !== nothing
        if save_path === true
            save_path = "collection_$(replace(repo.name, ".jl"=>"")).txt"
        end
        mkpath(dirname(save_path))
        open(save_path, "w") do io
            write(io, collated_content)
        end
        verbose && @info "Collated content saved to $save_path"
    end

    verbose &&
        @info "Repository content collated. Duration: $(round(time() - start_time, digits = 1)) seconds."

    return collated_content
end
