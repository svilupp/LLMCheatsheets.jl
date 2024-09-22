# Makie.jl Cheatsheet

## Package Name: Makie.jl

## URL: [https://github.com/MakieOrg/Makie.jl](https://github.com/MakieOrg/Makie.jl)

## Purpose
**Makie.jl** is a high-performance, extensible, and flexible data visualization ecosystem in Julia. It supports a variety of visualizations, including interactive plots, GUIs, and high-quality vector graphics.

## Installation
### Step-by-Step Instructions
Choose and install one or more backend packages depending on your needs:

**GLMakie** (interactive OpenGL):
```julia
using Pkg
Pkg.add("GLMakie")
```

**WGLMakie** (interactive WebGL in browsers):
```julia
using Pkg
Pkg.add("WGLMakie")
```

**CairoMakie** (static 2D vector graphics):
```julia
using Pkg
Pkg.add("CairoMakie")
```

**RPRMakie** (experimental ray tracing):
```julia
using Pkg
Pkg.add("RPRMakie")
```

### Activating a Backend
Activate the backend you installed with:
```julia
using GLMakie  # Example for GLMakie
GLMakie.activate!()
```

## Usage Overview

### Importing Makie
After activating your desired backend, import the Makie package:
```julia
using Makie
```

## Main Features and Functions

### Basic Plotting Functions

#### Scatter Plot
```julia
using GLMakie

x = 1:10
y = rand(10)

scatter(x, y, color = :blue, markersize = 10)
```
- **`x`, `y`**: Coordinates for the scatter points.
- **`color`**: Color of the points.
- **`markersize`**: Size of the points.

#### Line Plot
```julia
using GLMakie

x = 1:10
y = cumsum(randn(10))

lines(x, y, color = :red, linewidth = 2)
```
- **`color`**: Color of the line.
- **`linewidth`**: Thickness of the line.

#### Surface Plot
```julia
using GLMakie

x = y = -5:0.5:5
z = [sin(sqrt(x^2 + y^2)) for x in x, y in y]

surface(x, y, z, colormap = :viridis)
```
- **`colormap`**: Colormap to use for the surface.

### Adding Titles and Labels
```julia
x = 1:10
y = rand(10)

scatter(x, y, title="My Title", xlabel="X-Axis", ylabel="Y-Axis")
```
- **`title`**: Title of the plot.
- **`xlabel`**: Label for x-axis.
- **`ylabel`**: Label for y-axis.

### Advanced Customization
#### Subplots
```julia
f = Figure()
ax1 = Axis(f[1, 1])
scatter!(ax1, 1:10, rand(10))

ax2 = Axis(f[1, 2])
lines!(ax2, 1:10, cumsum(randn(10)))

f
```

#### Legends
```julia
f = Figure()
ax = Axis(f[1, 1])

lines!(ax, 1:10, rand(10), label="Line 1")
lines!(ax, 1:10, rand(10)+2, label="Line 2")

Legend(f[1, 2], ax)

f
```
- **`label`**: Label for each plot element.
- **`Legend`**: Adds a legend to the figure.

## Detailed Examples

### Customizing Plots with Themes
```julia
using GLMakie

set_theme!(palette = (color = [:red, :blue], marker = [:circle, :rect]))

f = Figure()
ax = Axis(f[1, 1])
scatter!(ax, 1:10, rand(10))

f
```
- **`set_theme!`**: Sets a theme for consistent styling.

### Interactive Sliders and Buttons
```julia
using GLMakie, Observables

# Create a figure and axis
fig = Figure()
ax = Axis(fig[1, 1])

# Create a slider
slider = Slider(fig[2, 1], 1:10, startvalue=5)

# Reactively update the plot based on slider value
squared = lift(slider.value) do x
    x^2
end

scatter!(ax, 1:10, squared)

fig
```
- **`Slider`**: Adds a slider to control plot data interactively.
- **`Observable`**: Reactively update plot data.

## Tips and Best Practices

1. **Modular Layouts**
   - Use `GridPosition` and `GridSubpositions` within a `Figure` for complex subplot layouts.
2. **Theme Management**
   - Customize and reuse themes with `set_theme!`, `update_theme!`, and `with_theme`.
3. **Interaction**
   - Utilize `Observable` and `lift` for interactive and dynamic plots.
4. **Efficient Updates**
   - Use indexed updates and observables to efficiently update plots without redrawing.

## Conclusion
Makie.jl offers a comprehensive and flexible framework for data visualization in Julia, suitable for both static and interactive plots. By leveraging various backends and customization options, you can create high-quality, publication-ready visualizations and interactive data exploration tools.