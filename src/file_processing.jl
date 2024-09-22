
"""
    summarize_file(file_info::AbstractDict; model = "gpt4o",
        special_instructions::AbstractString = "None.\n",
        cost_tracker::Union{Nothing, Threads.Atomic{<:Real}} = nothing,
        verbose::Bool = true, http_kwargs::NamedTuple = NamedTuple())

Summarizes the content of a file in a GitHub repository.

# Arguments
- `file_info::AbstractDict`: The file information from the GitHub API. Requires `:name` and `:download_url` fields.
- `model::String`: The model to use for the LLM call.
- `special_instructions::AbstractString`: Special instructions for the AI to tweak the output.
- `cost_tracker::Union{Nothing, Threads.Atomic{<:Real}}`: A tracker to record the cost of the LLM calls.
- `verbose::Bool`: Whether to print verbose output.
- `http_kwargs::NamedTuple`: Additional keyword arguments to pass to the `github_api` function.

# Returns
- `Dict`: A dictionary with the file name (`:name` field), the content (`:content` field), and the type (`:type` field).
"""
function summarize_file(file_info::AbstractDict; model = "gpt4o",
        special_instructions::AbstractString = "None.\n",
        cost_tracker::Union{Nothing, Threads.Atomic{<:Real}} = nothing,
        verbose::Bool = true, http_kwargs::NamedTuple = NamedTuple())
    @assert !isempty(get(file_info, :name, "")) "File name is empty for item: $(file_info)"
    @assert !isempty(get(file_info, :download_url, "")) "Download URL is empty for $(file_info[:name])"
    ##
    resp = github_api(file_info[:download_url]; http_kwargs...)
    body = String(resp.body)

    template = if endswith(file_info[:name], ".jl")
        :FileSumarizerJuliaScript
    elseif endswith(file_info[:name], ".md")
        :FileSumarizerMarkdown
    else
        :FileSumarizerGeneral
    end
    ## Run the LLM call to summarize the file
    response = aigenerate(
        template; content = body, model = model, verbose, special_instructions)
    !isnothing(cost_tracker) && Threads.atomic_add!(cost_tracker, response.cost)
    return Dict(:name => file_info[:name], :content => response.content, :type => "SUMMARY")
end

"""
    collate_files(file_contents::AbstractVector{<:AbstractDict})

Collates the file contents into a single string.

# Arguments
- `file_contents::AbstractVector{<:AbstractDict}`: The contents of the files in the repository. Requires `:name` and `:content` fields.

# Returns
- `String`: A string with the concatenated file names and contents.
"""
function collate_files(file_contents::AbstractVector{<:AbstractDict})
    @assert !isempty(file_contents) "No files provided"
    @assert all(haskey(file, :name) && haskey(file, :content) for file in file_contents) "File contents must have :name and :content fields"

    return join(["""<file name="$(file[:name])">
    $(file[:content])
    </file>""" for file in file_contents], "\n\n")
end
