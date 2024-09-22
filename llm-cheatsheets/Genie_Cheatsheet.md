# Genie.jl Cheat Sheet

## Package Name
**Genie.jl**

## URL
[Genie.jl GitHub Repository](https://github.com/GenieFramework/Genie.jl)

## Purpose
Genie.jl is a full-stack web framework for building modern web applications in Julia. It streamlines development by leveraging Julia's high performance, simplicity, and productivity features. Users can create, configure, and manage web applications efficiently using the provided modules, tools, and APIs.

## Installation
### Step-by-Step Instructions
1. **Enter Julia's package mode** by pressing `]` in the Julia REPL.
2. **Install Genie** by running:
   ```julia
   pkg> add Genie
   ```

## Usage Overview

### Starting a New Application
1. **Create a new Genie application**:
   ```julia
   using Genie
   Genie.Generator.newapp("MyGenieApp")
   ```
2. **Navigate to the project directory** and start the server:
   ```sh
   $ cd MyGenieApp
   $ julia -e 'using Genie; up()'
   ```
3. **Visit** `http://127.0.0.1:8000` to see the Genie welcome page.

### Imports and Dependencies
Make sure to include necessary modules in your projects, such as:
```julia
using Genie, SearchLight, SearchLightSQLite
```

## Main Features and Functions

### HTTP Routing
Define routes and their handlers.

#### Example:
```julia
using Genie

route("/") do
  "Hello, Genie!"
end

route("/json") do
  Genie.Renderer.Json.json(Dict("message" => "Welcome to Genie!"))
end

up(8000)
```

### Templating
Render HTML, JSON, Markdown, and JavaScript templates.

#### HTML Example:
```julia
using Genie.Renderer.Html

route("/html") do
  html("""
  <html>
    <head><title>Genie</title></head>
    <body><h1>Hello, Genie!</h1></body>
  </html>
  """)
end
```

### Web Sockets
Enabling real-time communication with clients.

#### Example:
```julia
using Genie, Genie.Router

Genie.config.websockets_server = true

channel("/ws") do
  @info "WebSocket message received"
end

up()  # Start the server
```

## Database Integration
### SearchLight ORM
### Example:
Connect to SQLite and perform queries.

#### Configuring Connection
```yaml
# db/connection.yml
env: ENV["GENIE_ENV"]

dev:
  adapter: SQLite
  database: db/dev.sqlite
```

#### Defining Models
```julia
module MyModel
using SearchLight

@kwdef mutable struct User <: AbstractModel
  id::DbId = DbId()
  name::String
  email::String
end

SearchLight.Model.metadata!(User)

end
```

#### Performing ORM Operations
```julia
using MyModel
user = User(name = "John Doe", email = "john@example.com")
save(user)

found_user = find(User, id = user.id)
println(found_user.name)  # Output: John Doe
```

## Handling JSON Payloads
Parse JSON payloads in routes.

#### Example:
```julia
using Genie, Genie.Requests, Genie.Renderer.Json

route("/post", method = POST) do
  data = jsonpayload()
  json(:message => "Received", :data => data)
end

up(8000)
```

## File Uploads
Support for handling file uploads.

#### HTML Form for File Upload
```html
<form action="/upload" method="POST" enctype="multipart/form-data">
  <input type="file" name="file"/>
  <input type="submit" value="Upload"/>
</form>
```

#### Handling File Upload in Route
```julia
route("/upload", method = POST) do
  if haspayloadfile(:file)
    file = payloadfile(:file)
    write("uploads/" * file.filename, file.data)
    "File uploaded successfully!"
  else
    "No file uploaded."
  end
end
```

## Authentication
Using `GenieAuthentication` for managing user authentication.

#### Example:
```julia
using GenieAuthentication

GenieAuthentication.install(@__DIR__)

route("/login") do
  GenieAuthentication.login_page()
end

route("/logout") do
  GenieAuthentication.logout()
end

up(8000)
```

## Tips and Best Practices
- **Use Secure Tokens:** Always set up secure tokens using `Genie.Secrets` for encryption, session management, and other security functionalities.
- **Modularity:** Keep your routes, controllers, and models modular to ensure maintainability and readability.
- **Environment Configuration:** Use different configuration files for development (`config/env/dev.jl`), testing (`config/env/test.jl`), and production (`config/env/prod.jl`) environments.
- **Automatic Reloading:** Utilize `Revise.jl` for automatic reloading during development to speed up the iteration process.

## Troubleshooting and Debugging
- **Use Logging:** Enable Genie logging to aid in debugging:
  ```julia
  import Genie.Logger
  Logger.initialize_logging("logfile.log", "info")
  ```
- **Check Configurations:** Ensure all database and server configurations are correct, especially when deploying to different environments.
- **Community Support:** Join the [Genie Discord Community](https://discord.com/invite/9zyZbD6J7H) for help and support.

## Additional Resources
- **Official Documentation:** [Genie Documentation](https://genieframework.github.io/Genie.jl/dev/)
- **Example Applications:** [Genie Example Apps](https://learn.genieframework.com/app-gallery)

This comprehensive cheatsheet provides the essential information for starting and developing applications using the Genie.jl web framework. For detailed guidance, refer to the official documentation and community resources. Happy coding!