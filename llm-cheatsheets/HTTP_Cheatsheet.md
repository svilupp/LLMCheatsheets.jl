# HTTP.jl Cheatsheet

Welcome to the comprehensive guide on using the HTTP.jl package! This cheatsheet covers everything you need to know to get up and running with HTTP.jl, from basic client requests to advanced server configurations. Designed to be beginner-friendly, this guide ensures you can start coding without additional instructions.

## 1. Package Name

**HTTP.jl**

## 2. URL

[GitHub Repository](https://github.com/JuliaWeb/HTTP.jl)

## 3. Purpose

HTTP.jl provides extensive HTTP client and server functionality for Julia, including support for requests, responses, headers, cookies, WebSockets, and more. It's suitable for building robust web applications and services.

## 4. Installation

To install HTTP.jl, use Julia's package manager:
- REPL mode:
  ```julia
  pkg> add HTTP
  ```
- Programmatically:
  ```julia
  julia> using Pkg; Pkg.add("HTTP")
  ```

## 5. Usage Overview

### Client Requests

#### Basic Request
```julia
using HTTP

resp = HTTP.request("GET", "http://httpbin.org/ip")
println(resp.status)      # Print status code
println(String(resp.body)) # Print response body
```

#### Convenience Functions
```julia
resp = HTTP.get("http://httpbin.org/ip")
resp = HTTP.post("http://httpbin.org/post", [], "sample body")
```

### Server Implementation

#### Simple Server
```julia
using HTTP

function my_handler(req::HTTP.Request)
    return HTTP.Response(200, "Hello, World!")
end
HTTP.serve(my_handler, "127.0.0.1", 8080)
```

### WebSocket Client

#### Simple Client
```julia
using HTTP.WebSockets

WebSockets.open("ws://websocket.org") do ws
    for msg in ws
        println("Received: ", msg)
        send(ws, "Echo: $msg")
    end
end
```

## 6. Main Features and Functions

### Status Codes and Messages

**`statustext(statuscode::Int) -> String`**
- Converts HTTP status codes to their respective string messages.
```julia
statustext(200)  # Returns "OK"
statustext(404)  # Returns "Not Found"
```

### HTTP Requests and Responses

#### Basic Client Functions
- **`HTTP.get(url, headers=[], body=nothing)`**: Performs a GET request.
- **`HTTP.post(url, headers=[], body=nothing)`**: Performs a POST request.
- **`HTTP.request(method, url, headers=[], body=nothing; kwargs...)`**: General request function.

#### Server Functions
- **`HTTP.serve(handler, host="0.0.0.0", port=8080; kwargs...)`**: Starts a blocking server.
- **`HTTP.serve!(handler, host="0.0.0.0", port=8080; kwargs...)`**: Starts a non-blocking server.

### WebSockets
- **`WebSockets.open(url) do ws`**: Opens a WebSocket client connection.
- **`WebSockets.listen(host, port) do ws`**: Opens a WebSocket server.

## 7. Detailed Examples

### Client - GET Request
```julia
using HTTP

resp = HTTP.get("http://httpbin.org/ip")
println("Status: ", resp.status)
println("Response Body: ", String(resp.body))
```

### Client - POST Request with JSON
```julia
using HTTP
using JSON

headers = ["Content-Type" => "application/json"]
body = JSON.json(Dict("key" => "value"))

resp = HTTP.post("http://httpbin.org/post", headers, body)
println("Status: ", resp.status)
println("Response Body: ", String(resp.body))
```

### Server - Basic HTTP Server
```julia
using HTTP

function handler(req::HTTP.Request)
    return HTTP.Response(200, "Hello, HTTP.jl!")
end

HTTP.serve(handler, "127.0.0.1", 8080)
```

### Server - Echo WebSocket Server
```julia
using HTTP.WebSockets

HTTP.WebSockets.listen("0.0.0.0", 8080) do ws
    for msg in ws
        send(ws, "Echo: $msg")
    end
end
```

### WebSocket Client
```julia
using HTTP.WebSockets

WebSockets.open("ws://localhost:8080") do ws
    send(ws, "Hello from client")
    msg = receive(ws)
    println("Received: $msg")
end
```

## 8. Tips and Best Practices

- **Verbose Logging**: Use `verbose` keyword argument in requests for detailed logging.
- **Error Handling**: Handle exceptions like `HTTP.TimeoutError` and `HTTP.StatusError` for robust applications.
- **SSL Verification**: Use `sslconfig` to customize SSL settings and ensure secure connections.
- **Session Management**: Utilize `Cookies` and `CookieJar` to manage sessions.
- **Custom Middleware**: Create middleware layers to extend functionality.

## 9. Additional Resources

- [Documentation](https://github.com/JuliaWeb/HTTP.jl)
- [Examples](https://github.com/JuliaWeb/HTTP.jl/tree/master/examples)
- [FAQs and Issues](https://github.com/JuliaWeb/HTTP.jl/issues)

By following this comprehensive cheatsheet, a junior developer can effectively use HTTP.jl to perform HTTP operations, manage server-client interactions, and handle WebSocket communications without needing additional guidance. Happy coding!