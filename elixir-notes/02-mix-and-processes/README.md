# Elixir: Session 2 - Mix & Processes

## Mix

Mix is a build tool that provides tasks for creating, managing dependencies, compiling, and testing Elixir projects. Mix is like Bundler, RubyGems and Rake combined.

### Creating

To generate a new project's folder structure, enter the command `mix new [project_name]`

The following boilerplate files are generated:

* README.md
* .gitignore
* mix.exs
* config
* config/config.exs
* lib
* lib/example.ex
* test
* test/test_helper.exs
* test/example_test.exs

The name of our application, versions, and dependencies are defined within `mix.exs`

#### Manage dependencies

Add new dependencies to the `deps` method in `mix.exs`

The dependency list is comprised of tuples with two required values and one optional:
- the package name as an atom (required),
- the version string (required),
- optional options (e.g. only: [:dev, :test])

Fetch dependencies `mix deps.get`

#### Environment variables

Out of the box mix works with 3 environments

- :dev — The default environment.
- :test — Used by mix test.
- :prod — Used when we ship our application to production

### Compiling

There are two different file extensions in Elixir:
- `file.ex` for compiled code
- `file.exs` for interpreted code (used for scripts and tests)

#### Compiling Elixir without mix

Option 1: Launch iex with the module as an argument `iex lib/example.ex`

Option 2: Compile a module with the `elixirc` command e.g. `elixirc lib/example.ex`. This generates a file called `Elixir.Example.beam` When you launch iex the module will be available.

#### Compiling Elixir with mix

To compile a mix project run `mix compile`

To use `iex` in context of your mix application, run `iex -S mix`

### Documentation

Elixir supports module and function documentation. Documentation is defined with the help of the module attributes `@moduledoc` and `@doc`

Access module's documentation using the `h` helper in `iex`

```
iex(1)> h(ModulesExample)

```

Generate documentation as html by using ExDoc through mix
- Add ExDoc as a dependency in mix.exs
```
defp deps do
  [
    {:ex_doc, "~> 0.12", only: :dev}
  ]
end
```
- Install dependency `mix deps.get`
- Generate documentation `mix docs`

### Testing

Elixir comes with a built in tool for writing unit tests called `ExUnit`. `ExUnit` is a module that uses `ExUnit.Case`

Start ExUnit with `ExUnit.start()` (conveniently done in `test/test_helper.exs` by mix)

`ExUnit.Case` will run all functions whose names start with `test` that takes one argument.

```
test "one is one" do
  assert 1 == 1
end
```

Run tests `mix test`

#### Test setup

The macros `setup` and `setup_all` run before each test or once before the suite, respectively

It is expected that `setup` and `setup_all` return a tuple of `{:ok, state}`. State will then be available to tests

```
defmodule ExampleTest do
  use ExUnit.Case
  doctest Example

  setup_all do
    {:ok, number: 2}
  end

  test "the truth", state do
    assert 1 + 1 == state[:number]
  end
end
```

#### More Macros

- `assert` tests that the expression is true
- `refute` tests that the expression is false
- `assert_raise` tests that an error has been raised
- `assert_received` tests the message has been sent (ExUnit runs its own process and can receive messages just like any other process)
- `assert_receive` same as `assert_received` but you can specify a timeout
- `capture_io` captures an application's output
- `capture_log` equivalent to `Logger`

## Processes

All Elixir code runs inside lightweight processes that are isolated and exchange information via messages.

- Receives messages asynchronously
- Stores messages sequentially in a mailbox
- Computes messages synchronously
- A process can either: (1) send/receive messages to other processes, (2) modify private state, or (3) create new processes
- A process dies when the function ends (or it crashes)
- Processes can not share memory

### Spawn

Spawn is the easiest way to create a new process. Spawn takes either an anonymous or named function and returns a PID (process identifier).

We can retrieve the PID of the current process by calling `self/0`

We can link our processes using `spawn_link`. Linked processes will receive exit notifications from each other.

```
spawn_link fn -> raise "hell" end
```

If we want to get a message if the process crashes but not crash our current process, we can use `spawn_monitor`.

```
spawn_monitor fn -> raise "hell" end
```

### Send and Receive

As mentioned, processes can only communicate via messages.

We can send messages to a process with `send/2` and receive them with `receive/1`.

```
send pid, "world"
```

```
pid = spawn fn ->
  receive do
    msg -> IO.puts "hello #{msg}"
  end
end
```

### State

Processes that infinitely loop can send/receive messages and maintain state.

```
defmodule LoopedProcess do
  def init do
    spawn_link fn -> loop([]) end
  end

  def loop(state) do
    receive do
      msg ->
        state = [msg | state]
        IO.inspect state
      loop(state)
    end
  end
end
```

Using processes to maintain state is a very common pattern in Elixir. However, we usually don't have to implement these patterns manually because Elixir uses abstractions like Agents.
