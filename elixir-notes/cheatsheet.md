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

#### Syntax

###### Pattern matching

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

* Deconstructing HTML using Floki, an HTML parser
  ```elixir
  iex> html = "<a href='http://github.com/some/repo'>Click me</a>"

  iex> [{"a", [{"href", url}], [description]}] = Floki.find(html, "a")
       [{"a", [{"href", "http://github.com/some/repo"}], ["Click me"]}]

  iex> url
       "http://github.com/some/repo"
  iex> description
       "Click me"
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

* Function names are listed with their arity (number of arguments): `Module.function_name/2`
* Functions with the same name, but different arities, are _distinctly different functions_
* Functions can also have multiple _clauses_, distinguished via guards
