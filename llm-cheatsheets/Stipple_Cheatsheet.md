# Stipple.jl Cheatsheet

## Overview
**Stipple.jl** is a reactive UI library for Julia that integrates with Vue.js on the client side. It facilitates the development of dynamic, data-driven web applications with seamless two-way data binding between the Julia backend and the Vue.js frontend.

## Installation
Install Stipple from the GitHub repository via Julia's package manager:
```julia
pkg> add Stipple
```

## Key Concepts and Handlers

### Key Elements and Macros

#### `@app` Macro
The `@app` macro initializes the application, defines the data model, handlers, and UI components.

**Example:**
```julia
using Stipple

@app begin
    @in counter = 0
    @out doubled_value = 0
    
    @onchange counter begin
        doubled_value = counter * 2
    end
end

function ui()
    [
        row(
            column(
                cell([p("Enter a number:"), textfield("Counter", :counter)])
            ),
            column(
                cell([p("Doubled Value: ", bignumber(:doubled_value))])
            )
        )
    ]
end

@page("/", ui)
```

#### `@in`, `@out`, `@onchange`, `@onclick`

These macros are used to manage reactive variables and event handlers within your application.

**`@in`**
Define reactive input variables:
```julia
@in user_name::String
```

**`@out`**
Define reactive output variables:
```julia
@out greeting::String = "Enter your name."
```

**`@onchange`**
Define a handler that triggers when a reactive variable changes:
```julia
@onchange user_name begin
    greeting = "Hello, " * user_name
end
```

**`@onclick`**
Define a handler for click events:
```julia
@onclick greet_button begin
    println("Button clicked!")
end
```

#### `@page` Macro
Define the structure of a UI page.
```julia
@page "/" begin
    h1("Welcome to the App")
end
```

### Practical Examples

#### Example 1: Simple Greeting App
Define an app where a user enters their name and receives a greeting.

```julia
using Stipple

@app GreetingApp() begin
    @in user_name::String
    @out greeting::String = "Enter your name."

    @onchange user_name begin
        greeting = "Hello, " * user_name
    end

    layout() do
        cell([
            row([
                column([
                    cell([input(user_name, placeholder="Enter your name...")])
                ]),
                column([
                    cell([button("Greet Me", @onclick :greet_user)])
                ]),
                column([
                    cell([p("Greeting: ", greeting)])
                ])
            ])
        ])
    end
end

function greet_user()
    @app().greeting = "Hello, " * @app().user_name
end
```

#### Example 2: Counter Application
Create an app that counts how many times a button is clicked.

```julia
using Stipple

@app ClickCounterApp() begin
    @out click_count = 0

    @onclick click_button begin
        click_count += 1
    end

    layout() do
        cell([
            row([
                column([
                    cell([button("Click me!", @onclick :click_button)])
                ]),
                column([
                    cell([p("Click count: ", click_count)])
                ])
            ])
        ])
    end
end
```

#### Example 3: Temperature Converter
Bind user input to model variables and perform real-time calculations.

```julia
using Stipple

@app TempConverterApp() begin
    @in celsius::Float64 = 0.0
    @out fahrenheit::Float64 = 32.0

    @onchange celsius begin
        fahrenheit = celsius * (9/5) + 32
    end

    layout() do
        cell([
            row([
                column([
                    cell([
                        input(celsius, placeholder="Enter Celsius...", type="number")
                    ])
                ]),
                column([
                    cell([
                        p("Fahrenheit: ", fahrenheit)
                    ])
                ])
            ])
        ])
    end
end
```

## Advanced Component and Plugin Usage
Since upgrading to Vue3, additional components and plugins need to be handled differently:
```julia
# Registering a Vue2 component in a Vue3 app
Stipple.register_global_component("LegacyComponent", legacy = true)

# Adding a plugin to the application
Stipple.add_plugin(MyApp, "PluginName")
```

## Migration to Vue3/Quasar2
### Key Points
- Register components in the app instance.
- Update syntax for field synchronization from `<fieldname>.sync` to `v-model:<fieldname>`.
- Split components using `v-if` and `v-for` with a container element.

For more detailed migration support, refer to:
- [Quasar Upgrade Guide](https://quasar.dev/start/upgrade-guide/)
- [Vue3 Migration Guide](https://v3-migration.vuejs.org/)

## Additional Tips and Best Practices
- Initialize reactive variables with sensible default values.
- Use descriptive names for UI elements and reactive variables.
- Modularize significant UI components to keep the codebase maintainable.

## More Information
For more examples and detailed usage, access Stipple's documentation and function docstrings directly in Julia:
```julia
help?> btn
```

Happy coding with Stipple for your next interactive Julia application!