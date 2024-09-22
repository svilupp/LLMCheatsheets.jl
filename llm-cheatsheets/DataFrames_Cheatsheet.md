# DataFrames.jl Cheatsheet

## Package Name
**DataFrames.jl**

## URL
[DataFrames.jl on GitHub](https://github.com/JuliaData/DataFrames.jl)

## Purpose
DataFrames.jl provides flexible and high-performance data manipulation capabilities akin to R's data.frames or Python's pandas, ideal for handling tabular data in Julia.

## Installation

```julia
using Pkg
Pkg.add("DataFrames")
```

### Check Installation

```julia
using DataFrames
Pkg.status("DataFrames")
```

### Testing Installation (Optional)
```julia
Pkg.test("DataFrames") # Warning: This can take more than 30 minutes.
```

## Usages Overview
To use DataFrames.jl, load the package after installation:

```julia
using DataFrames
```

## Creating DataFrames

### Constructors
#### Empty DataFrame:
```julia
df = DataFrame()
```

#### DataFrame with Columns:
```julia
df = DataFrame(a=1:3, b=["A", "B", "C"], c=1.0)
```

#### DataFrame from Named Tuple:
```julia
df = DataFrame((x=[1, 2, 3], y=[4, 5, 6]))
```

#### DataFrame from Dictionary:
```julia
datadict = Dict("Name" => ["John", "Jane"], "Age" => [23, 35])
df = DataFrame(datadict)
```

#### DataFrame from Matrix:
```julia
mat = [1 2 3; 4 5 6; 7 8 9]
df = DataFrame(mat, :auto)
```

### Basic Operations on DataFrames

#### Extract Columns
```julia
df[:Name]   # Extract a column by name
df[:, :Name]  # Extract column (return Vector)
df[!, :Name]  # Extract column without copying
```

#### Get Column Names
```julia
names(df)               # Returns column names as symbols
propertynames(df)       # Alternative
```

#### Size and Description
```julia
size(df)                # (nrow, ncol)
describe(df)            # Descriptive statistics
first(df, 6)            # First 6 rows
last(df, 6)             # Last 6 rows
show(df, allrows=true)  # Show all rows
```

### Modifying DataFrames

#### Add/Modify Columns
```julia
df.NewCol = [1, 2, 3]            # Add a new column
df[:, :Name] = ["Jane", "John"]  # Modify existing column by name
df[!, :Age] .= [30, 40, 50]      # Modify in-place
```

#### Insert Columns
```julia
insertcols!(df, 2, :Middle => ["M", "N", "O"])  # Insert at position with scalar value
```

#### Remove Columns
```julia
select!(df, Not(:Middle))  # Remove column :Middle
```

### Filtering Rows

#### Basic Filtering
```julia
df[df.Age .> 30, :]  # Rows where Age > 30
subset(df, :Age => x -> x .> 30)  # Using subset function
```

#### Handling Missing Values
```julia
dropmissing(df)          # Drop rows with any missing value
allowmissing!(df)        # Allow missing in all columns
disallowmissing!(df)     # Disallow missing in all columns
```

### Grouping and Combining

#### Grouping
```julia
grouped_df = groupby(df, :Gender)
```

#### Combining
```julia
combine(grouped_df, :Salary => mean => :AvgSalary)  # Aggregation
transform(grouped_df, :Salary => mean => :AvgSalary)  # Adding new columns
select(grouped_df, :Salary => mean => :AvgSalary)  # Selecting columns
```

### Joins

#### Common Joins
```julia
df1 = DataFrame(ID=[1, 2], Name=["A", "B"])
df2 = DataFrame(ID=[2, 3], Age=[20, 30])

innerjoin(df1, df2, on=:ID)     # Inner Join
leftjoin(df1, df2, on=:ID)      # Left Join
rightjoin(df1, df2, on=:ID)     # Right Join
outerjoin(df1, df2, on=:ID)     # Outer Join
```

#### Adding Columns from a Join
```julia
leftjoin!(df1, DataFrame(ID=[1, 3], Info=["X", "Y"]), on=:ID)  # In-place left join
```

### Reshaping Data

#### Wide to Long
```julia
stack(df, [:SepalLength, :SepalWidth])
```

#### Long to Wide
```julia
unstack(stacked_df, :id, :variable, :value)
```

## I/O Operations
### CSV Files

#### Reading CSV
```julia
using CSV
path = "path/to/file.csv"
df = CSV.read(path, DataFrame)
```

#### Writing CSV
```julia
CSV.write("output.csv", df)
```

### Handling Other Formats
Refer to packages like Arrow.jl, Feather.jl, Avro.jl, JSONTables.jl for other formats.

## Using Categorical Data
### CategoricalVector
```julia
using CategoricalArrays
v = ["A", "B", "A"]
cv = categorical(v)
```

### Levels and Reordering
```julia
levels(cv)
levels!(cv, ["B", "A"])
```

### Memory Optimization
```julia
compress(cv)
```

## Metadata Handling
### Table-Level Metadata
```julia
metadata!(df, "caption", "Table of Salaries")
metadata(df, "caption")
metadatakeys(df)
deletemetadata!(df, "caption")
emptymetadata!(df)
```

### Column-Level Metadata
```julia
colmetadata!(df, :Name, "description", "First Name")
colmetadata(df, :Name, "description")
colmetadatakeys(df, :Name)
deletecolmetadata!(df, :Name, "description")
emptycolmetadata!(df, :Name)
```

## Parallel Operations
### Multithreading
```julia
Pkg.test("DataFrames") # to ensure everything is set up
# Enable threading with "threads=true" in relevant functions
combine(groupby(df, :Gender), :Salary => mean => :AvgSalary, threads=true)
```

## Integration with Other Julia Packages
### Plotting
- **Plots.jl**
```julia
using Plots
plot(df.Salary)
```
- **Gadfly.jl**
```julia
using Gadfly
plot(df, x=:Age, y=:Salary, Geom.point)
```

### Machine Learning
- **MLJ.jl** for machine learning models integration.
```julia
using MLJ
# Example
model = @load DecisionTreeClassifier
```

## Additional Resources
### Tutorials
- [Julia Academy DataFrames.jl Course](https://juliaacademy.com/p/introduction-to-dataframes-jl)
- [DataFrames.jl Tutorial](https://github.com/bkamins/Julia-DataFrames-Tutorial)
- [DataFrames.jl Documentation](http://dataframes.juliadata.org/stable/)

### Community
- **Discourse**: [JuliaLang Discourse](https://discourse.julialang.org/)
- **GitHub Issues**: [Submit Issues](https://github.com/JuliaData/DataFrames.jl/issues)

This detailed cheatsheet outlines how to use DataFrames.jl effectively for data manipulation in Julia, helping new users start working with data frames quickly and efficiently.