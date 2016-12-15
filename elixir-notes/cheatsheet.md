# Elixir Cheatsheet

#### Environment

* Install with `brew install elixir`
* Use `elixir -v` to confirm a successful installation
* `iex` is the Elixir shell

#### Type system

###### Basic types
* Integers: `3`, `0x1F`, `0b0110`
* Floats: `3.0`, `1.0e-10`
* Boolean logic: everything is truthy except `false` and `nil`
* Atoms: `:some_atom`
  * Module names are also atoms: `SomeModule`, `Some.Other.Module`
* Binaries: `<<0,1,2>>`
  * A sequence of bytes
  * Concatenation: `<<0,1>> <> <<2,3>> == <<0,1,2,3>>`
  * A string is just a valid UTF-8 encoded binary
  * `<<97,98,99>> == "abc"`
  * Strings are always double quoted
  * Interpolation: `lang = "Elixir"; IO.puts("yay, #{lang}!")`
* Anonymous functions (they are first class!)
  * `fn(a, b) -> a + b end`
  * More on this in the functions section below

###### Collections

* Lists: `["some", "list", "content"]`
  * Implemented as a linked list
* Tuples: `{1, 2, 3}`
  * Stored contiguously in memory
  * Access elements by index: `elem({:a, :b, :c}, 1) == :b`
* Keyword lists: `[key: "value", another_key: "value"]`
  * Syntactic sugar for a list of two-tuples
  * `[key: "value"] == [{:key, "value"}]`
  * Ordered
  * Can have duplicate keys
* Maps: `%{"key" => "value"}`
  * Unordered
  * Keys are unique
  * Syntactic sugar: `%{a: 1} == %{:a => 1}`
  * Update syntax:

    ```elixir
    iex> map = %{a: 1, b: 2}
    %{a: 1, b: 2}
    iex> %{map | a: 3}
    %{a: 3, b: 2}
    ```
* Structs
  * A map with fixed fields that can have default values
  * Define a struct within a module using `defstruct`:
    ```elixir
    defmodule Colour do
      defstruct name: "black", r: 0, g: 0, b: 0
    end

    iex> %Colour{}
    %Colour{name: "black", r: 0, g: 0, b: 0}
    iex> %Colour{name: "magenta", r: 255, b: 255}
    %Colour{name: "magenta", r: 255, g: 0, b: 255}
    ```

#### Syntax

###### Pattern matching

* The match operator
  ```elixir
  iex> x = 1
  1
  iex> 1 = x
  1
  iex> 2 = x
  ** (MatchError) no match of right hand side value: 1
  ```

* Matching on lists
  ```elixir
  iex> list = [1, 2, 3]
  iex> [head | tail] = list
  [1, 2, 3]
  iex> head
  1
  iex> tail
  [2, 3]
  ```

* Matching on simple types
  ``` elixir
  iex> {a, b, 42} = {:hello, "world", 42}
       {:hello, "world", 42}
  iex> a
       :hello
  iex> b
       "world"
  ```

* Matching on the return value of a simple operation
  ```elixir
  iex> {:ok, files} = File.ls
       {:ok, ["README.md", "meme.jpg", "jeremy_bad_joke_list.txt"]}
  iex> files
       ["README.md", "meme.jpg", "jeremy_bad_joke_list.txt"]
  ```

* Deconstructing HTML data using Floki, an HTML parser
  ```elixir
  iex> html = "<a href='http://github.com/some/repo'>Click me</a>"

  iex> [{"a", [{"href", url}], [description]}] = Floki.find(html, "a")
       [{"a", [{"href", "http://github.com/some/repo"}], ["Click me"]}]

  iex> url
       "http://github.com/some/repo"
  iex> description
       "Click me"
  ```

* The pin operator (prevents rebinding in pattern matches)
  ```elixir
  iex> x = 1
  1
  iex> x = 2
  2
  iex> ^x = 3
  ** (MatchError) no match of right hand side value: 3
  ```

###### Control flow

* case
  ```elixir
  iex> case {1, 2, 3} do
  ...>   {4, 5, 6} ->
  ...>     "This clause won't match"
  ...>   {1, x, 3} ->
  ...>     "This will match, and the value of x is #{x}"
  ...> end
       "This clause will match, and the value of x is 2"
  ```

* cond
  ```elixir
  iex> cond do
  ...>   2 + 2 == 5 ->
  ...>     "this will not match"
  ...>   1 + 1 == 2 ->
  ...>     "this will match"
  ...>   2 * 2 == 4 ->
  ...>     "this won't match; condition already satisfied"
  ...> end
  "this will match"
  ```

* if
  ```elixir
  iex> if nil do
  ...>   "this won't be seen"
  ...> else
  ...>   "this will"
  ...> end
  "this will"
  ```

#### Functions

###### Named functions

* Named functions have a name and a function arity: `Module.function_name/2`. Functions with the same name and different arities are _not the same function_.

* Functions with multiple clauses
  ```elixir
  defmodule Math do
    def zero?(0), do: true
    def zero?(x), when is_integer(x), do: false
  end
  ```

* Default argument syntax
  ```elixir
  defmodule Concat do
    def join(a, b, sep \\ " ") do  # NOTE: this defines Concat.join/2 AND Concat.join/3
      a <> sep <> b
    end
  end
  ```

* Calling named functions
  ```elixir
  iex> Base.encode64("pizza is good")
  "cGl6emEgaXMgZ29vZA=="
  ```

* Calling erlang functions (erlang module names are plain atoms!)
  ```elixir
  iex> :crypto.rand_bytes(3)
  <<117, 252, 86>>
  ```

###### Anonymous functions

* Defining and calling an anonmyous function
  ```elixir
  iex> add = fn(a, b) -> a + b end
  iex> add.(1, 2)  # note the dot! This is necessary to invoke anonymous functions.
  ```

* __GOTCHA__: anonymous functions are closures. Named functions are not.
  ```elixir
  iex> x = 42
  iex> (fn -> x end).()
  42  # This will raise a compile error with a named function
  ```

* Function capture syntax (convert a named function to a function data type)
  ```elixir
  iex> fun = &Base.encode64/1
  iex> is_function(fun)
  true
  iex> fun.("pizza is good")
  "cGl6emEgaXMgZ29vZA=="
  ```

* Create new functions using the capture syntax
  ```elixir
  iex> fun = &(&1 + 1)
  iex> fun.(1)
  2
  ```

###### Pipe operator

* Pass the first argument to a function using a pipe

  ```elixir
  iex> map = %{a: 1}
  iex> Map.get(map, :a)
  1
  iex> map |> Map.get(:a)
  1
  ```

#### Recursion

* Recursion is the solution to enumeration in languages with immutable types
  ```elixir
  defmodule Math do
    def sum_list([head | tail], accumulator) do
      sum_list(tail, head + accumulator)
    end

    def sum_list([], accumulator) do
      accumulator
    end
  end

  iex> Math.sum_list([1,2,3], 0)
  6
  ```

* Check `Enum` and `Stream` for higher-order functions that use recursion internally


#### Mix

* Generate a new mix project (including custom app and module names, plus a supervisor); get deps and test
  ```bash
  $ mix new elixir-otp-app --app elixir_otp_app --module ElixirOTPApp --sup
  $ mix deps.get
  $ mix test
  ```

#### Compiling

* Compile a `.ex` file to a `.beam` file
  ```bash
  $ elixirc file_to_compile.ex  # creates a single beam file for each module
  ```

* Compile a file from the command line (file contains a `Test` module)
  ```elixir
  iex> c "file_to_compile.ex"
  [Test]
  ```

* "Compile" an `.exs` file in-memory in iex
  ```bash
  $ iex elixir_script.exs
  ```

#### Processes

###### Message-passing basics

* Processes can send and receive messages from one another
* Messages are stored in a process's "mailbox" on arrival
* A process uses a `receive` block that operates on a single message
* Mailbox is a queue; messages are operated on in order of arrival
* If a `receive` block is called and there are no messages in the mailbox, the
  process will block until a message arrives

* A shell sends two messages to itself, receives the first two, then blocks
  ```elixir
  iex> send self, :one
  iex> send self, :two

  iex> receive do
  ...>   msg -> msg
  ...> end
  :one

  iex> receive do
  ...>   msg -> msg
  ...> end
  :two

  iex> receive do
  ...>   msg -> msg
  ...> end
  # shell will hang here indefinitely
  ```

#### Spawning and linking processes

* Processes created by `spawn` do not affect the parent process on crash
  ```elixir
  iex(68)> spawn fn -> raise "hell" end
  #PID<0.101.0>
  iex(69)>
  20:33:42.111 [error] Process #PID<0.101.0> raised an exception
  ** (RuntimeError) hell
      :erlang.apply/2
  iex(70)>
  ```

* Processes created by `spawn_link` crash the parent process on crash
  ```elixir
  iex(68)> spawn_link fn -> raise "hell" end
  #PID<0.127.0>

  20:35:55.536 [error] Process #PID<0.127.0> raised an exception
  ** (RuntimeError) hell
      :erlang.apply/2
  ** (EXIT from #PID<0.120.0>) an exception was raised:
      ** (RuntimeError) hell
              :erlang.apply/2
  iex(1)> ## The iex process crashed and was restarted by its supervisor
  ```

* Processes created with `spawn_monitor` send a message to the parent process on crash
  ```elixir
  iex> spawn_monitor fn -> raise "hell" end
  {#PID<0.131.0>, #Reference<0.0.1.230>}

  20:37:25.693 [error] Process #PID<0.131.0> raised an exception
  ** (RuntimeError) hell
      :erlang.apply/2

  iex> receive do
  ...>   msg -> msg
  ...> end
  {:DOWN, #Reference<0.0.1.230>, :process, #PID<0.131.0>, {%RuntimeError{message: "hell"}, [{:erlang, :apply, 2, []}]}}
  ```

#### Extras

* Flush all messages from the shell mailbox (iex only)
  ```elixir
  iex> send self, :one
  iex> send self, :two
  iex> send self, :three
  iex> flush
  :one
  :two
  :three
  :ok
  ```


