# AlgebraOfGraphics.jl Cheatsheet

## Package Name

**AlgebraOfGraphics.jl**

## URL

[AlgebraOfGraphics.jl GitHub Repository](https://github.com/MakieOrg/AlgebraOfGraphics.jl)

## Purpose

AlgebraOfGraphics is a Julia package designed to create visualizations using an algebraic approach to the grammar of graphics. Inspired by R's `ggplot2`, it lets you build complex plots using simple algebraic combinations of data, mappings, and visual elements. The package integrates seamlessly with Makie for high-customization capabilities.

## Installation

### Prerequisites

Ensure you have Julia installed. Then, in your Julia REPL, run:

```julia
using Pkg
Pkg.add(["AlgebraOfGraphics", "CairoMakie", "PalmerPenguins", "DataFrames"])
```

## Getting Started

### Basic Usage Overview

#### Loading and Preparing Data

Load and clean your dataset:

```julia
using AlgebraOfGraphics, CairoMakie, PalmerPenguins, DataFrames

penguins = dropmissing(DataFrame(PalmerPenguins.load()))
```

#### Setting Themes

Customize the theme for your plots:

```julia
set_aog_theme!()
update_theme!(Axis = (; width = 150, height = 150))
```

#### Creating Basic Plots

##### Scatter Plot

```julia
spec = data(penguins) * mapping(:bill_length_mm, :bill_depth_mm)
draw(spec)
```

##### Adding Color by Species

```julia
by_color = spec * mapping(color = :species)
draw(by_color)
```

##### Adding Regression Lines

```julia
with_regression = by_color * (linear() + visual(alpha = 0.3))
draw(with_regression)
```

##### Facetted Plots

Facet the plot by the `sex` of penguins:

```julia
facetted = with_regression * mapping(col = :sex)
draw(facetted)
```

##### Customizing Color Palette

```julia
draw(facetted, scales(Color = (; palette = :Set1_3)))
```

## Main Features and Functions

### Data Preparation

#### `data`

Wraps a dataset for visualization.

**Usage:**
```julia
df = (x = 1:10, y = rand(10))
data(df)
```

### Mapping Variables to Plot Attributes

#### `mapping`

Associates data columns to plot aesthetics.

**Usage:**
```julia
mapping(:x, :y, color = :group)
```

### Visual Adjustments

#### `visual`

Defines visual characteristics for the plot.

**Usage:**
```julia
visual(Scatter, alpha = 0.5)
```

### Statistical Analyses

#### Histograms

**Function:** `histogram`
```julia
df = (x = randn(5000))
specs = data(df) * mapping(:x) * histogram(bins = 15)
draw(specs)
```

#### Density Plots

**Function:** `density`
```julia
df = (x = randn(5000), y = randn(5000))
specs = data(df) * mapping(:x, :y) * density(npoints = 50)
draw(specs)
```

#### Linear Regression

**Function:** `linear`
```julia
df = (x = 1:100, y = 2 * (1:100) .+ randn(100))
specs = data(df) * mapping(:x, :y) * (linear() + visual(Scatter))
draw(specs)
```

### Combining Layers

Use `*` to combine different data, mappings, and visuals into cohesive layers.

#### Example

```julia
df = (x = 1:10, y = rand(10))
layer1 = data(df) * mapping(:x, :y)
layer2 = visual(Scatter, color = :red)

combined_layer = layer1 * layer2
draw(combined_layer)
```

## Tips and Best Practices

1. **Modular Design**: Break down complex plots into simpler components using `data`, `mapping`, and `visual`.
2. **Debugging**: Verify each component individually before combining them.
3. **Consistent Themes**: Use `set_aog_theme!` and `update_theme!` to maintain visual consistency across plots.

## Additional Resources

- **Makie Documentation**: [Makie Documentation](https://docs.makie.org/stable/)
- **PalmerPenguins Documentation**: [PalmerPenguins.jl](https://github.com/mfalt/palmerpenguins.jl)
- **DataFrames.jl Documentation**: [DataFrames.jl](https://dataframes.juliadata.org/stable/)

By following this comprehensive cheatsheet, you should be well-equipped to start your journey with AlgebraOfGraphics and create effective and informative visualizations using Julia.