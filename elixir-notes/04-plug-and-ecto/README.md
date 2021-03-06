## Elixir Week 4: Elixir Libraries - Plug & Ecto

## Plug

#### What is it?
Plug is a specification that enables different frameworks to talk to different web servers. Plug achieves similar objectives to Rack in Ruby.

#### How does it work?

A plug . . .
  1. Receives a data structure that represents the HTTP request (usually referred to as a connection)

      ```
      %Plug.Conn{host: "www.example.com",
           path_info: ["bar", "baz"],
           ...}
      ```
  2. Does some sort of transformation
  3. Returns the modified connection

Plugs are executed sequentially forming a <em>plug pipeline</em>

There are two kind of plugs
   1. Function plugs

   ```
   def hello_world_plug(conn, _opts) do
     conn
     |> put_resp_content_type("text/plain")
     |> send_resp(200, "Hello world")
   end
   ```
   2. Module plugs

   ```
   defmodule MyPlug do
     def init(options), do: options
     def call(conn, _opts), do: conn
   end
   ```

 Init is executed at compiled time whereas call happens at run time.

#### Manipulating the connection

Manipulating the connection often happens with the use of the functions defined in the `Plug.Conn` module.

Example, `put_resp_content_type` and `send_resp`

<em>Note:</em> Plug is a direct interface to the underlying web server. When you call `send_resp`, it will immediately send the given status and body back to the client.

[Plug.Conn Function Cheatsheet](http://ricostacruz.com/cheatsheets/phoenix-conn.html)

### Installation

  1. Add plug and cowboy (or the webserver of your choice) to your `mix.exs` dependencies:

  ```
  defp deps do
    [{:cowboy, "~> 1.0.0"},
     {:plug, "~> 1.0"}]
  end
  ```

  2. Install the dependencies, `mix deps.get`

  3. Add both `:cowboy` and `:plug` to your OTP application `mix.exs`

  ```
  def application do
    [applications: [:cowboy, :plug]]
  end
  ```

### Example - Plug Router

Matches an incoming request add and perform some application.

Update application to start and supervise web server

```
children = [
   Plug.Adapters.Cowboy.child_spec(:http, Example.Plug.Router, [], port: port)
 ]
```
Create file `lib/plug/router.ex`

```
defmodule Example.Plug.Router do

end
```

Add `use Plug.Router` to mix in Plug's routing functions

Add `plug :match` to match requests to routes. Routes are matched from top to bottom

Add `plug :dispatch` to execute matched code

<em>Plug router compiles routes into a single function that the Erlang VM optimizes into a tree lookup.</em>

Always have a catch all match

### Testing plugs

Plug ships with a Plug.Test module that makes testing your plugs easy. Here is how we can test the router from above (or any other plug):

```
defmodule MyPlugTest do
  use ExUnit.Case, async: true
  use Plug.Test

  @opts AppRouter.init([])

  test "returns hello world" do
    # Create a test connection
    conn = conn(:get, "/hello")

    # Invoke the plug
    conn = AppRouter.call(conn, @opts)

    # Assert the response and status
    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "world"
  end
end
```

## Ecto

There are 4 main components to Ecto:
  1. Ecto.Repo - wrapper around data. Requires a data adapter and credentials
  2. Ecto.Schema - maps data source into Elixir struct
  3. Ecto.Changeset - a way to filter/cast external parameters and provide validation/constraints when manipulating data
  4. Ecto.Query - used to retrieve/manipulate data from database

### Installation

  1. Include ecto and a database adapter (in this tutorial we will be using PostgreSQL) as a dependency in `mix.exs`

  ```
  defp deps do
    [{:ecto, "~> 1.0"},
     {:postgrex, ">= 0.0.0"}]
  end
```

  2. Add ecto and adapter to the application list in `mix.exs`

  ```
  def application do
    [applications: [:ecto, :postgrex]]
  end
```

  3. Run `mix ecto.gen.repo`

  This command creates the project repository `lib\[project_name]\repo.ex`

  ```
  defmodule ExampleApp.Repo do
    use Ecto.Repo,
      otp_app: :example_app
  end
  ```

  And adds repository, adapter, database and account information to `config/config.exs`

  4. Add the created repo to the supervisor tree in `lib/[project_name].ex`

  ```
  children = [
      supervisor(ExampleApp.Repo, [])
    ]
  ```

### Migrations

 Similar in syntax to ActiveRecord

 ```
  mix ecto.create         # Create the storage for the repo
  mix ecto.drop           # Drop the storage for the repo
  mix ecto.gen.migration  # Generate a new migration for the repo
  mix ecto.gen.repo       # Generate a new repository
  mix ecto.migrate        # Run migrations up on a repo
  mix ecto.rollback       # Rollback migrations from a repo
 ```  

Migrations are saved in `priv/repo/migrations/`

To apply our new migration run `mix ecto.migrate`

#### Schema

Defines struct with fields as listed in schema

`%My_App.User{username: "user_name", email: "user@name.com"}`

```
schema "users" do
  field :username, :string
  field :email, :string

  timestamps
end
```

Has similar macros to ActiveRecord e.g. `belongs_to`, `has_many`, `many_to_many`

#### Changesets

Changesets are operations done on top of the schema. They provide both validations and constraints which are ultimately turned into errors in case something goes wrong.

#### Virtual fields

Virtual fields are not saved to the database but are useful for validations

e.g. `field :password_confirmation, :string, virtual: true`

### Queries

- Similar to ActiveRecord
- Can insert SQL fragments
- External values and Elixir expressions can be injected into a query expression with ^

### Challenge

[2048 Game](http://elixirquiz.github.io/)


### Resources
[Getting Started with Elixir Plug: Routes](https://jarredtrost.com/getting-started-with-elixir-plug-routes-3bbd1dba00e#.fx4ogdlzu)
[Plug](https://github.com/elixir-lang/plug)
[Ecto](https://elixirschool.com/lessons/specifics/ecto/)
