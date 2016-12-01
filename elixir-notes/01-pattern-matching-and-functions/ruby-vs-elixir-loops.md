# Ruby vs Elixir Loops

## Ruby

In Ruby, we mutate the variable

```
def print_multiple_times(msg, n)
  i = 0

  while i < n
    puts msg
    i += 1
  end
end
```

## Elixir

In Elixir, we rely on recursion (a function is called recursively until a condition is reached that stops the recursive action from continuing)

```
defmodule Recursion do
  def print_multiple_times(msg, n) when n <= 1 do
    IO.puts msg
  end

  def print_multiple_times(msg, n) do
    IO.puts msg
    print_multiple_times(msg, n - 1)
  end

  Recursion.print_multiple_times("Hello!", 3)
end
```

Note: Order matters!
