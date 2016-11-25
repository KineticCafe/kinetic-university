## Elixir Week 0: Getting Started

Elixir is a dynamic, functional language designed for building scalable and maintainable applications.

Elixir leverages the Erlang VM, known for running low-latency, distributed and fault-tolerant systems.

---

### Installing Elixir

* For installation instructions, visit http://elixir-lang.org/install.html

* Install with `brew install elixir`

* Use `elixir -v` to confirm a successful installation

---

### Elixir Command Line

* Similar to `irb`, Elixir comes with an interactive shell

* To run it, type `iex` into Terminal (Interactive Ruby)

* To exit, `press Crtl+C`

---

### Elixir Basic Syntax

* Integers: `3`, `0x1F`, `0b0110`

* Floats: `3.0`, `1.0e-10`

* Boolean logic: everything is truthy except `false` and `nil`
  * `||`, `&&`, `!`

* Atoms: `:some_atom`
  * Constant whose name is their value
  * Module names are also atoms: `SomeModule`, `Some.Other.Module`

* Binaries: `<<0,1,2>>`
  * A sequence of bytes
  * Concatenation: `<<0,1>> <> <<2,3>> == <<0,1,2,3>>`
  * A string is just a valid UTF-8 encoded binary
  * `<<97,98,99>> == "abc"`
  * Strings are always double quoted
  * Interpolation: `lang = "Elixir"; IO.puts("yay, #{lang}!")`

* Operations: `+`, `-`, `*`, `\`
  * `\` always returns a float
  * `div(10,5)`, `rem(10,3)`

* Comparisons: `!==`, `<=`, `>=`, `<`, `>`, `==`, `!=`, `===`
---

### Exercises (for next week)

* Read from the [Getting Started](http://elixir-lang.org/getting-started/introduction.html) section of the Elixir website:
  * Chapter 4: Pattern Matching
  * Chapter 8: Modules
