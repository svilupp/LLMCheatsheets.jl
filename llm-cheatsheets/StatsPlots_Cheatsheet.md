# StatsPlots.jl Comprehensive Cheatsheet

## Package Name: StatsPlots.jl

## URL: [StatsPlots GitHub Repository](https://github.com/JuliaPlots/StatsPlots.jl)

## Purpose
StatsPlots.jl enhances the capabilities of Plots.jl by providing a range of statistical plotting recipes. It integrates well with DataFrames, Distributions, and other statistical packages, enabling users to create comprehensive and informative plots for statistical data analysis.

## Installation

### Step-by-Step Instructions
1. **Install the package**:
    ```julia
    julia> using Pkg
    julia> Pkg.add("StatsPlots")
    ```

2. **Import the package**:
    ```julia
    julia> using StatsPlots
    ```

3. **Optional Initialization for Plot Size**:
    ```julia
    julia> gr(size=(400, 300))
    ```

## Usage Overview

### Basic Import and Data Plotting
- Utilize the `@df` macro to simplify plotting DataFrame columns.
- Example:
    ```julia
    julia> using DataFrames, StatsPlots
    julia> df = DataFrame(a = 1:10, b = 10 .* rand(10), c = 10 .* rand(10))
    julia> @df df plot(:a, [:b :c], colour = [:red :blue])
    julia> @df df scatter(:a, :b, markersize = 4 .* log.(:c .+ 0.1))
    ```

### Advanced Column Selection
- Use `cols()` for selecting column ranges or variables.
    ```julia
    julia> cols(2:3)
    julia> s = :b
    julia> cols(s)
    julia> cols()
    ```

### Handling Ambiguous Symbols
- Escape non-column symbols with `^()`.
    ```julia
    julia> df[:red] = rand(10)
    julia> @df df plot(:a, [:b :c], colour = ^([:red :blue]))
    ```

## Main Features and Functions

### 1. Plotting Recipes
- **Density Plot**:
    ```julia
    julia> using KernelDensity
    julia> x = randn(1000)
    julia> density(x)
    ```

- **Boxplot**:
    ```julia
    julia> @df df boxplot(:a, :b)
    ```

- **Violin Plot**:
    ```julia
    julia> using RDatasets
    julia> iris = dataset("datasets", "iris")
    julia> @df iris violin(:Species, :SepalLength)
    ```

- **Corner Plot**:
    ```julia
    julia> data = rand(100, 5)
    julia> CornerPlot(data; compact=true)
    ```

- **Grouped Histogram**:
    ```julia
    julia> @df iris groupedhist(:SepalLength, group = :Species, bar_position = :dodge)
    ```

### 2. Specialized Plots
- **Marginal Histograms**:
    ```julia
    julia> @df iris marginalhist(:PetalLength, :PetalWidth)
    ```

- **Interactive DataViewer**:
    ```julia
    julia> use DataFrames, Observable, Widget
    julia> df = DataFrame(x = 1:100, y = rand(100))
    julia> dataviewer(df)
    ```

### 3. Quantile-Quantile Plots (QQPlots)
- **QQPlot**:
    ```julia
    julia> using Distributions, StatsPlots
    julia> x = rand(Normal(), 100)
    julia> y = rand(Cauchy(), 100)
    julia> qqplot(x, y, qqline=:identity)
    ```

## Detailed Examples

### Kernel Density Estimation
1. **Plotting Univariate KDE**:
    ```julia
    julia> data = randn(100)
    julia> kde_result = kde(data)
    julia> plot(kde_result)
    ```

2. **Plotting Bivariate KDE**:
    ```julia
    julia> data = rand(2, 100)
    julia> kde_result = kde(data)
    julia> plot(kde_result)
    ```

### Boxplot and Violin Plot
1. **Basic Boxplot**:
    ```julia
    julia> using Plots, StatsPlots
    julia> x = rand(100)
    julia> y = rand(100)
    julia> boxplot(x, y; notch = true)
    ```

2. **Violin Plot with Grouping**:
    ```julia
    julia> @df dataset("lattice", "singer") violin(:VoicePart, :Height)
    ```

### Interactive Plotting with Interact.jl
```julia
julia> using RDatasets, StatsPlots, Interact, Blink
julia> iris = RDatasets.dataset("datasets", "iris")
julia> w = Window()
julia> body!(w, dataviewer(iris))
```

## Tips and Best Practices

- **Utilize `@df` Macro**: Simplifies handling DataFrames for plotting.
- **Explore Package Functions**: Leverage functionalities from `KernelDensity`, `Distributions`, `Clustering`, and more.
- **Customize Plots**: Use attributes like `color`, `legend`, `linecolor`, and `fillalpha` to tweak plot appearances.
- **Interactive Exploration**: Use `dataviewer` for dynamic data visualization and exploration.
- **Grouped Plots**: Ideal for categorical data visualization; support for multiple grouping columns enhances clarity.
- **Kernel Density Plots**: Adjust `bandwidth` for finer control over the estimation.

## Additional Resources

**Documentation**:
- [StatsPlots Documentation](https://docs.juliaplots.org/latest/generated/statsplots/)

**Community and Support**:
- Join the [JuliaLang Zulip Chat](https://julialang.zulipchat.com/#narrow/stream/236493-plots) for discussions and support.

StatsPlots.jl offers a comprehensive suite of tools to create detailed and informative statistical plots, enhancing the visualization capabilities of Plots.jl significantly. With the provided examples and tips, newcomers can quickly start exploring and visualizing their statistical data in Julia.