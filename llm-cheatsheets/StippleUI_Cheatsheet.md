# StippleUI.jl Cheatsheet

## Package Name
**StippleUI.jl**

## URL
[StippleUI.jl on GitHub](https://github.com/GenieFramework/StippleUI.jl)

## Purpose
StippleUI.jl provides a comprehensive set of reactive UI elements that seamlessly integrate with the Stipple ecosystem, including Stipple.jl and Genie.jl. It utilizes the Quasar Framework to deliver high-quality and interactive data dashboards entirely within Julia.

## Installation
To install StippleUI.jl, use the Julia package manager:
```julia
pkg> add StippleUI
```

## Usage Overview
To use StippleUI components in your Stipple-based application:
1. **Import StippleUI**:
   ```julia
   using Stipple
   using StippleUI
   ```
2. **Create Components**:
   - Use StippleUI component functions (e.g., `btn`, `textfield`) to build interactive UI elements.
3. **Render Components**:
   - Render the components within your pages using the `page` function from Stipple.

## Main Features and Functions

### Key Components

#### Buttons
Create customizable buttons using the `btn` function.
```julia
btn("Submit", @click(:submitAction), color="primary")
```
- **Parameters**:
  - `label`: Button text.
  - `@click`: Event handler for click events.
  - `color`: Button color (e.g., "primary", "secondary").
- **Example**:
  ```julia
  btn("Click Me", @click(:buttonClick), color="primary")
  ```

#### TextField
Create a text input field using the `textfield` function.
```julia
textfield("Name", :nameField, placeholder="Enter your name")
```
- **Parameters**:
  - `label`: Field label.
  - `v-model`: Bind to reactive variable.
  - `placeholder`: Placeholder text.

#### Layouts
Organize application layout using `layout`, `page_container`, and `page`.
```julia
layout() # Basic layout
page_container() # Container for multiple pages
page("Page title") # Individual page within a container
```

#### Cards
Create card components using the `card`, `card_section`, and `card_actions`.
```julia
card(
  class="card-class",
  [
    card_section("Card Header"),
    card_section("Card Body Content"),
    card_actions([btn("Accept"), btn("Decline")])
  ]
)
```
- **Parameters**:
  - `class`: CSS class for styling.
  - Nested components like sections and actions for structured content.

#### Dialogs
Create dialog windows using the `dialog` function.
```julia
dialog("Dialog Title", "This is the content of the dialog", [
  btn("Close", @click(:closeDialog))
])
```

#### Avatars
Display avatars using the `avatar` function.
```julia
avatar(size=50, src="path/to/avatar.png")
```
- **Parameters**:
  - `size`: Size of the avatar.
  - `src`: Image source URL.

## Detailed Examples

### Creating a Button
```julia
using Stipple
using StippleUI

function ui()
  @widget ([btn("Click Me", @click(:buttonClicked), color="primary"),])
end

function page()
  page(
    ui()
  )
end

# Define click event
mixed @widget begin
  function buttonClicked()
    println("Button was clicked!")
  end
end

Genie.isrunning(:webserver) || up()
```

### Form Example with TextField
```julia
using Stipple
using StippleUI

@vars UIForm begin
  name::R{String} = ""
end

function ui()
  [
    textfield("Name", :name),
    btn("Submit", @click(:submitAction))
  ]
end

function page()
  page(
    UIForm |> init |> ui
  )
end

# Define the submit action
@widget begin
  function submitAction()
    println("Submitted Name: ", name[])
  end
end

Genie.isrunning(:webserver) || up()
```

### Creating a Dialog
```julia
using Stipple
using StippleUI

@vars UIDialog begin
  showDialog::R{Bool} = false
end

function ui()
  [
    btn("Open Dialog", @click("showDialog = true")),
    dialog(:showDialog, "Dialog Title", "This is the dialog content", [
      btn("Close", @click("showDialog = false"))
    ])
  ]
end

function page()
  page(
    UIDialog |> init |> ui
  )
end

Genie.isrunning(:webserver) || up()
```

## Tips and Best Practices
- **Use Keyword Arguments**: Prefer keyword arguments for better clarity and code readability.
- **Consistent Naming**: Maintain consistent naming conventions for UI components and variables.
- **Error Handling**: Implement error checks and handle potential exceptions, especially in event handlers.
- **Documentation**: Keep components well-documented to help others understand your code quickly.

## Additional Resources
- **[Quasar Framework Documentation](https://quasar.dev)**
- **[Stipple.jl Documentation](https://github.com/GenieFramework/Stipple.jl)**
- **[Genie.jl Documentation](https://genieframework.github.io/Genie.jl/stable/)**

Start leveraging StippleUI.jl to create interactive and dynamic user interfaces in your Julia applications!