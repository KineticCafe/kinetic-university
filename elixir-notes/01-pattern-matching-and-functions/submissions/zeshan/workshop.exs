defmodule Workshop do
  def sum(0), do: 0
  def sum(x), do: x + sum(x - 1)

  def guess(actual, range) do
    midpoint = ((range.first + range.last) / 2) |> Float.floor |> Kernel.trunc

    IO.puts midpoint
    cond do
      actual == midpoint ->
        actual
      (actual < range.first) || (actual > range.last) ->
        raise "Value out of range: #{actual}"
      actual > midpoint ->
        guess(actual, (midpoint + 1)..range.last)
      actual < midpoint ->
        guess(actual, range.first..(midpoint - 1))
    end
  end
end
