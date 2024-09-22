# CSV.jl Cheatsheet

## Package Name
**CSV.jl**

## URL
[GitHub Repository](https://github.com/JuliaData/CSV.jl)

## Purpose
CSV.jl is a Julia package for handling delimited text data, such as CSV or TSV files. It provides high-performance functionalities for reading, writing, and manipulating CSV files with both ease and efficiency. 

## Installation
To install CSV.jl, use the following command in the Julia REPL:
```julia
] add CSV
```

## Documentation
- **Stable Documentation**: [Stable](https://JuliaData.github.io/CSV.jl/stable)
- **Latest Documentation**: [Latest](https://JuliaData.github.io/CSV.jl/latest)

## Basic Usage

### Reading CSV Files
#### 1. Using `CSV.File`
Reads an entire delimited data input and returns a `CSV.File` object.
```julia
using CSV

# Reading from a file
file = CSV.File("path/to/file.csv")
for row in file
    println(row)
end

# Access column data
first_row = file[1]
value = first_row[:col1]  # Access column :col1 in first row
```
**Keyword Arguments:**
- `header`: Specifies how to determine column names.
- `delim`: Specifies the delimiter used to separate columns.
- `types`: Defines column types.
- `pool`: Controls whether columns are stored as `PooledArray`s.

#### 2. Using `CSV.read`
Reads and directly passes parsed data to sinks like DataFrames.
```julia
using CSV, DataFrames

# Reading into a DataFrame
df = CSV.read("path/to/file.csv", DataFrame)
```

#### 3. Using `CSV.Rows`
Consumes delimited data row by row with minimal memory footprint.
```julia
using CSV

rows = CSV.Rows("path/to/file.csv")
for row in rows
    println(row[:col1])
end
```

#### 4. Using `CSV.Chunks`
Processes extremely large files in manageable chunks.
```julia
using CSV

chunks = CSV.Chunks("largefile.csv", ntasks=4)
for chunk in chunks
    println(chunk.names)
end
```

#### 5. Handling Non-UTF-8 Character Encodings
```julia
using CSV, StringEncodings

# Read ISO-8859-1 encoded file
file = CSV.File(open("iso8859_encoded_file.csv", enc"ISO-8859-1"))
```

### Writing CSV Files
#### Using `CSV.write`
Writes data to a CSV file.
```julia
using CSV, DataFrames

df = DataFrame(Name=["Alice", "Bob"], Age=[25, 30])
CSV.write("output.csv", df)
```
**Keyword Arguments:**
- `delim`: Specifies the delimiter.
- `quote`: Determines quoting behavior.
- `dateformat`: Custom date format.
- `header`: Column names or boolean indicating whether to write column names.

#### Using `CSV.RowWriter`
Iteratively writes rows to an output.
```julia
using CSV, Tables

# Define schema
schema = Tables.Schema([:Name, :Age], [String, Int])

# Create an IO stream
io = open("output.csv", "w")

# Create RowWriter object
row_writer = CSV.RowWriter(io, schema)

# Write rows
write(row_writer, ("Alice", 25))
write(row_writer, ("Bob", 30))

# Close the stream
close(io)
```

## Advanced Usage

### Concatenating Multiple Inputs
```julia
using CSV

data = [
    "a,b,c\n1,2,3\n4,5,6\n",
    "a,b,c\n7,8,9\n10,11,12\n",
    "a,b,c\n13,14,15\n16,17,18"
]
file = CSV.File(map(IOBuffer, data))
```

### Customizing Headers
```julia
# Custom header row
file = CSV.File("data.csv", header=2)

# Manually providing column names
file = CSV.File("data.csv", header=["a", "b", "c"])

# Multi-row headers
file = CSV.File("data.csv", header=[1, 2])
```

### Handling Specific Row and Column Requirements
```julia
# Skip to specific row
file = CSV.File("data.csv", skipto=4)

# Include/Exclude columns
file = CSV.File("data.csv", select=["name", "age"])
file = CSV.File("data.csv", drop=[2, 3])

# Limit number of rows
file = CSV.File("data.csv", limit=100)
```

### Parsing Delimited Data in a String
```julia
data = """
a,b,c
1,2,3
4,5,6
"""

file = CSV.File(IOBuffer(data))
```

### Handling Specific Data Types
```julia
# Custom missing strings
file = CSV.File("data.csv", missingstring=["NA", "NULL"])

# Specify column types
file = CSV.File("data.csv", types=Dict(1 => Float64, 2 => String))
```

## Tips and Best Practices
1. **Memory Efficiency:** Use `CSV.Rows` for iteration over large files to minimize memory usage.
2. **Multithreading:** Enable multithreading for large data files to improve parsing speed.
3. **Custom Delimiters:** Define custom delimiters, quote characters, and date formats using appropriate keyword arguments.
4. **Debugging:** Enable debugging during parsing for detailed information about the process (`debug=true`).

## Contributing and Questions
- **Contributions:** Contributions, feature requests, and suggestions are welcome.
- **Issue Reporting:** Open an issue on the [GitHub repository](https://github.com/JuliaData/CSV.jl/issues).

By following this cheatsheet, you can effectively use CSV.jl for various CSV file operations in Julia. For comprehensive examples and further details, refer to the official documentation linked above.