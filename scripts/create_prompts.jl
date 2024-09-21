using PromptingTools
const PT = PromptingTools

# Create templates for prompts
script_summary = PT.create_template(;
    system = """You will be provided a file containing Julia code.

Your task is to analyze the file and extract key user-facing elements and any practical information about them.

Your answer will be used to create a comprehensive cheatsheet for a newcomer on how to use the code, ensuring they have all the information they might need without visiting the repository.

### Guidelines

- Thoroughly review the provided file, considering all modules, sub-modules, and their contents.
- Identify and include key user-facing elements such as functions, types (structs), constants, and macros that are relevant to end-users.
- Consider elements that have docstrings, are exported from the module, or are marked with the prefix "public" as user-facing.
- Include elements exported using the `export` keyword, even if they lack docstrings or the "public" prefix.
- Start the summary with the full name of the module/sub-module, if relevant, to make it easier to specify the correct import strategy.
- Be very descriptive in how to use the functions, types, and concepts to enable junior developers to get started effectively.
- Pay special attention to variable and argument types, and prefer keyword arguments over positional arguments for clarity in examples.
- Include code examples where appropriate, demonstrating typical usage patterns.
- Highlight key tips and best practices if they are mentioned in the docstrings or comments and are not obvious.
- If there are no user-facing elements in this file (functions, types, constants, or macros), state that there are no user-facing elements.
- Summarize general information or conceptual explanations if the file contains them, especially if practical information is lacking.
- Handle files with multiple or nested modules by summarizing each relevant module separately, starting with the module's name.
- If the file contains syntax errors, incomplete code, or is not valid Julia code, mention that the file may be incomplete or contains errors.
- Exclude internal or private functions, types, or variables unless they are essential for understanding the user-facing elements.
- First and foremost, attend to any user-provided SPECIAL INSTRUCTIONS. If they are empty, use the default guidelines above.
""",
    user = """FILE TO SUMMARIZE:
    ```julia
    {{content}}
    ```

    SPECIAL INSTRUCTIONS:
    {{special_instructions}}

    Start the summary with the name of the module/sub-module, if relevant, to make it easier to specify the correct import strategy.
    """, load_as = :FileSumarizerJuliaScript)
filename = joinpath(@__DIR__,
    "..",
    "templates",
    "FileSumarizerJuliaScript.json")
PT.save_template(filename,
    script_summary;
    version = "1.0",
    description = "Creates a Julia script-focused summary of a file provided. Provide special instructions if necessary, otherwise set to `none`. Placeholders: `content`, `special_instructions`")

markdown_summary = PT.create_template(;
    system = """You will be provided a file containing Markdown documentation.

    Your task is to analyze the file and extract the most important information that the developer highlighted.

    Your answer will be used to create a comprehensive cheatsheet for a newcomer on how to use the code, ensuring they have all the information they might need without visiting the repository.

    ### Guidelines

    - Thoroughly review the provided file, considering all sections, subsections, and any embedded code examples.
    - Identify and include key concepts, their explanations, practical tips, best practices, important caveats, and warnings.
    - Be very descriptive in how to use the functions and concepts to enable junior developers to get started effectively.
    - Pay special attention to variable types, function arguments, and usage patterns; prefer keyword arguments over positional arguments for clarity.
    - Include code examples where appropriate, ensuring they are clear, well-commented, and demonstrate typical usage scenarios.
    - Add comments to code examples to highlight non-obvious concepts and best practices.
    - Highlight tips, tricks, hacks, and nuanced explanations that can aid understanding or prevent common pitfalls.
    - Organize the summary hierarchically, starting with the most important information and breaking down topics into logical sections.
    - Start the summary with the name of the key information or main topic to provide immediate context.
    - If the documentation includes diagrams or visual aids, describe them briefly if they contribute to understanding key concepts.
    - Exclude irrelevant or redundant information that does not contribute to a newcomer's understanding of how to use the code.
    - Handle any special Markdown features (like tables, lists, or links) appropriately to preserve the information's clarity.
    - First and foremost, attend to any user-provided SPECIAL INSTRUCTIONS. If they are empty, use the default guidelines above.

    """,
    user = """FILE TO SUMMARIZE:
    <markdown>
    {{content}}
    </markdown>

    SPECIAL INSTRUCTIONS:
    {{special_instructions}}

    Start the summary with the name of key information. Be very hierarchical and organized.
    """, load_as = :FileSumarizerMarkdown)
filename = joinpath(@__DIR__,
    "..",
    "templates",
    "FileSumarizerMarkdown.json")
PT.save_template(filename,
    markdown_summary;
    version = "1.0",
    description = "Creates a markdown-focused summary of a file provided. Provide special instructions if necessary, otherwise set to `none`. Placeholders: `content`, `special_instructions`")

general_summary = PT.create_template(;
    system = """You will be provided a file from a GitHub repository.

Your task is to analyze the file and extract key information that would be useful for a newcomer to understand the repository, its purpose, and functionality.

Your answer will be used to create a comprehensive cheatsheet for a newcomer on how to use the repository, ensuring they have all the information they might need without visiting the repository.

### Guidelines

- Thoroughly review the provided file, regardless of its format (e.g., JSON, HTML, text, configuration files, scripts).
- Identify and include key concepts, functionalities, configurations, or any critical information highlighted by the developer that would aid a newcomer.
- Focus on the most important information that would be useful for a newcomer to know.
- Extract key concepts, their explanations, practical tips, best practices, important caveats, and warnings.
- If there are code examples, snippets, or configurations, include the most illustrative ones, ensuring they are clear and well-commented.
- Be very descriptive in how to use the functions, features, or configurations to enable junior developers to get started effectively.
- Include key tips and best practices, highlighting non-obvious concepts and practices.
- Organize the summary hierarchically, starting with the name of the module/sub-module or main topic to provide immediate context.
- If the file contains configuration settings (e.g., JSON, YAML), explain the purpose of key settings and how they affect the repository's behavior.
- If the file is a script or executable code (e.g., shell scripts, batch files), describe what it does and how to use it.
- For HTML or other documentation files, extract key information that provides insights into the repository's usage or functionality.
- Exclude irrelevant or redundant information that does not contribute to a newcomer's understanding of how to use the repository.
- Handle any special formats appropriately to preserve the clarity and usefulness of the information.
- First and foremost, attend to any user-provided SPECIAL INSTRUCTIONS. If they are empty, use the default guidelines above.

""",
    user = """FILE TO SUMMARIZE:
    <file>
    {{content}}
    </file>

    SPECIAL INSTRUCTIONS:
    {{special_instructions}}
    """, load_as = :FileSumarizerGeneral)
filename = joinpath(@__DIR__,
    "..",
    "templates",
    "FileSumarizerGeneral.json")
PT.save_template(filename,
    general_summary;
    version = "1.0",
    description = "Creates a code-focused summary of a file provided. Provide special instructions if necessary, otherwise set to `none`. Placeholders: `content`, `special_instructions`")

cheatsheet_prompt = PT.create_template(;
    system = """You will be provided the contents of a GitHub repository.

Your task is to create a comprehensive cheatsheet for a newcomer on how to use the repository, ensuring they have all the information they might need without visiting the repository.

It must be so comprehensive that a junior developer could start coding without any additional training or instructions.

### Guidelines

- Thoroughly review the provided files, considering all modules, sub-modules, and their contents.
- **Lead with practical information**, such as:
  - How to install the package, including any dependencies or prerequisites.
  - How to import or include the package in a project.
  - Any initial setup or configuration required.
- **Explain the purpose of the package**, providing context and the problems it solves.
- **List the main functions, types, constants, and macros**, including brief descriptions of what they do.
- **Provide detailed examples for all relevant functionality**, ensuring:
  - Examples are clear, well-commented, and demonstrate typical usage scenarios.
  - Comments highlight key concepts, important details, and any non-obvious aspects.
  - Clarity, simplicity, and diversity are prioritized in code examples.
- Use an informal and approachable tone, as if explaining to a junior developer who is eager to learn and start coding.
- Highlight key concepts and any sharp edges or potential pitfalls the developer should be aware of.
- Include key tips, best practices, and important caveats or warnings.
- Organize the cheatsheet logically and hierarchically, making it easy to understand and follow.
- Avoid leaving out any important information, but also avoid repetition.
- Format the cheatsheet in Markdown for easy readability, using appropriate headings, lists, code blocks, and emphasis where necessary.
- **Pay special attention to `README.md` and any `index.md` files**, as they often contain the most important information.
- If there are multiple modules or components, organize the cheatsheet to reflect this structure, providing clear sections for each.
- Include installation instructions and any necessary setup steps, ensuring no steps are assumed or skipped.
- First and foremost, attend to any user-provided SPECIAL INSTRUCTIONS. If they are empty, use the default guidelines above.

Please structure the cheatsheet to cover:

1. **Package Name**: Include the full name of the package.

2. **URL**: Provide the repository or documentation URL.

3. **Purpose**: A brief description of what the package does and the problems it solves.

4. **Installation**: Step-by-step instructions on how to install and set up the package.

5. **Usage Overview**: General information on how to use the package, including import statements and basic examples.

6. **Main Features and Functions**:

   - List of main functions, types, constants, and macros.

   - For each, provide:

     - A brief description.

     - Detailed examples with comments.

7. **Detailed Examples**:

   - For all relevant functionality, provide code examples that are clear and well-commented.

   - Highlight key concepts, best practices, and any non-obvious details.

8. **Tips and Best Practices**:

   - Include practical advice, common pitfalls to avoid, and optimal usage patterns.

9. **Additional Resources**:

   - Link to any relevant documentation, tutorials, or guides if necessary.


""",
    user = """ Please create a comprehensive cheatsheet for the provided repository based on the following information:

    Package Name: {{name}}

    URL: {{url}}

    Files or File Summaries:
    {{files}}

    Special Instructions: {{special_instructions}}""", load_as = :CheatsheetCreator)
filename = joinpath(@__DIR__,
    "..",
    "templates",
    "CheatsheetCreator.json")
PT.save_template(filename,
    cheatsheet_prompt;
    version = "1.0",
    description = "Creates a cheatsheet for a repository provided. Provide special instructions if necessary, otherwise set to `none`. Placeholders: `name`, `url`, `files`, `special_instructions`")
