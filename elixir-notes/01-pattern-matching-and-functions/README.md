# Elixir: Session 1

## Session topics

* Pattern matching
* Control structures: `case`, `cond`, `if`
* Modules and functions
* Recursion
* A few more data types

## Workshop

Create a module, called `Workshop`, that exports the following functions:

* `sum(n)`, that uses recursion to calculate the sum of every integer from 1 to `n`. (Avoid using `Enum` functions for this).
* `guess(actual, range)`, which uses a binary search to find the number `actual` in from the given `range`.

Save your solutions as `workshop.exs` and load the module into `iex` using `iex workshop.exs`. From the shell, you should be able to create output that looks like this:

```elixir
iex> Workshop.sum(4)
10
iex> Workshop.sum(5)
15
iex> Workshop.guess(273, 1..1000)
Guessing 500
Guessing 250
Guessing 375
Guessing 312
Guessing 281
Guessing 265
Guessing 273
273
```

(In the `Workshop.guess/2` example, the `Guessing x` lines should be logs to the console. You can do this with `IO.puts/1`.)


### Exercises (for next week)

* Read [Introduction to Mix](http://elixir-lang.org/getting-started/mix-otp/introduction-to-mix.html)
