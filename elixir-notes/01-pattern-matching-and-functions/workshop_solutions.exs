defmodule Workshop do
  def sum(0) do
    0
  end

  def sum(n) when n > 0 and is_integer(n) do
    n + sum(n - 1)
  end

  def guess(actual, range) do
    lower..upper = range
    cond do
    Enum.count(range) > 1 ->
      IO.puts actual
    true ->
      middle = Float.floor((upper + 1 ) / 2)

      cond do
      actual <= middle ->
       upper = middle
      actual > middle ->
        upper = middle + 1
      end
      guess(actual, lower..upper)
    end
  end
end
