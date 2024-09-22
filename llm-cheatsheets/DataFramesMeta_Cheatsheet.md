# DataFramesMeta.jl Cheatsheet

## Package Name:
**DataFramesMeta.jl**

## URL: 
[DataFramesMeta.jl GitHub Repository](https://github.com/JuliaData/DataFramesMeta.jl)

---

## Purpose
**DataFramesMeta.jl** provides a suite of macros to streamline common data manipulation tasks on DataFrames in Julia. It simplifies operations like filtering, transforming, and summarizing data into more readable and convenient macro-based syntax, similar to R's `dplyr` and C#'s `LINQ`.

---

## Installation

You can install `DataFramesMeta.jl` using Julia's package manager:

1. Using Julia REPL:

   ```julia
   import Pkg; Pkg.add("DataFramesMeta")
   ```

2. Using `Pkg` REPL mode (type `]` to enter):

   ```julia
   add DataFramesMeta
   ```

---

## Usage Overview

To start using `DataFramesMeta.jl`, first ensure you have the necessary libraries:

```julia
using DataFrames
using DataFramesMeta
```

### Basic Example

```julia
df = DataFrame(a = [1, 2, 3], b = [4, 5, 6])
@select df c = :a + :b  # This creates a new column `c` which is the sum of `a` and `b`.
```

---

## Main Features and Functions

### Macros Overview

1. **@with**
   - **Purpose**: Simplifies DataFrame column manipulations within a block scope.
   - **Usage**: 
     ```julia
     @with(df, :y .+ 1)
     ```

2. **@select**
   - **Purpose**: Selects and possibly transforms columns.
   - **Usage**:
     ```julia
     @select df :x :y
     @select df new_col = 2 * :x
     ```

3. **@transform**
   - **Purpose**: Adds or modifies columns in a DataFrame.
   - **Usage**:
     ```julia
     @transform df :new_col = :x * 2
     @transform! df :new_col = :x * 2  # In-place version.
     ```

4. **@subset**
   - **Purpose**: Filters rows based on conditions.
   - **Usage**:
     ```julia
     @subset df :x .> 1
     @rsubset df :x .> 1  # Keeps rows that do not satisfy the condition.
     @subset! df :x .> 1  # In-place version.
     ```

5. **@orderby**
   - **Purpose**: Sorts rows by specified columns.
   - **Usage**:
     ```julia
     @orderby df :x
     ```

6. **@combine**
   - **Purpose**: Aggregates data by groups and summarizes.
   - **Usage**:
     ```julia
     @combine df avg_x = mean(:x)
     ```

7. **@groupby**
   - **Purpose**: Groups DataFrame by specified columns.
   - **Usage**:
     ```julia
     @groupby df :a
     ```

8. **@eachrow**
   - **Purpose**: Applies operations to each row.
   - **Usage**:
     ```julia
     df2 = @eachrow df begin
         :new_col = :A + :B
     end
     @eachrow! df begin
         :A = :A * 2
     end  # In-place version.
     ```

9. **@rename**
   - **Purpose**: Renames columns.
   - **Usage**:
     ```julia
     @rename df :new_name = :old_name
     @rename! df :new_name = :old_name  # In-place version.
     ```

10. **@label! and @note!**
    - **Purpose**: Attaches labels and notes to columns.
    - **Usage**:
      ```julia
      @label! df :wage = "Hourly wage (2015 USD)"
      printlabels(df)
      @note! df :wage = "Data source description"
      printnotes(df)
      ```

### Handling Missing Values

- **@passmissing**
  - **Purpose**: Ensures missing values are propagated through functions.
  - **Usage**:
    ```julia
    @transform df @passmissing @byrow :new_col = parse(Int, :x_str)
    ```

---

## Detailed Examples

### Chain Operations with `@chain`

Using `@chain` to pipeline multiple operations:

```julia
@chain df begin
    @transform(:y = 10 * :x)
    @subset(:a .> 2)
    @groupby(:b)
    @combine(:mean_x = mean(:x), :mean_y = mean(:y))
    @orderby(:mean_x)
    @select(:mean_x, :mean_y)
end
```

### Adding Metadata

Attach labels and notes to DataFrame columns:

```julia
@label! df :wage = "Hourly wage (2015 USD)"
@note! df :wage = """
    Wage per hour in 2014 USD taken from ACS data.
    """
printlabels(df)  # Pretty prints the labels.
printnotes(df)   # Pretty prints the notes.
```

### Complex Operations

Combining multiple macros for advanced operations:

```julia
@groupby df :category begin
    @transform :new_col = :original_col * 2
    @combine :mean_val = mean(:new_col)
end
```

---

## Tips and Best Practices

1. **Use Macros for Readability**: Macros like `@select`, `@transform`, and `@subset` make the code more concise and easier to read.
2. **Chain Multiple Operations**: Use `@chain` to combine multiple DataFrame operations in a clean and readable format.
3. **Handle Missing Data**: Use `@passmissing` to ensure missing values do not cause errors in transformations.
4. **Label and Annotate**: Attach labels and notes to DataFrame columns to maintain data documentation and clarity.

---

## Additional Resources

- **Full Documentation**:
  - [Stable Version](https://JuliaData.github.io/DataFramesMeta.jl/stable)
  - [Development Version](https://JuliaData.github.io/DataFramesMeta.jl/dev)
- **DataFrames.jl**: The foundational package for DataFrames in Julia.
- **DataFramesMeta.jl GitHub Repository**: [DataFramesMeta.jl](https://github.com/JuliaData/DataFramesMeta.jl)

---

By following this cheatsheet, you should be well-equipped to start using DataFramesMeta.jl effectively for manipulating DataFrames in Julia. This tool will help you write cleaner and more efficient data transformation code. Enjoy your data manipulation with Julia!