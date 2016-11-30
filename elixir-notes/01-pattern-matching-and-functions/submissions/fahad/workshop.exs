defmodule Workshop do
  @moduledoc """
    Exercises from week 1 workshop
  """

  @doc """
    Given: Integer n
    Return: Sum of all integers from 1 to n, recursively
  """
  def sum(1), do: 1
  def sum(n) when is_integer(n), do: n + sum(n-1)

  @doc """
    Given: Integer actual, a range of integers range
    Return: Fine actual inside range using binary search, outputting each 'guess'
  """
  def guess(actual, first..last) when is_integer(first) and is_integer(last) and first <= last do
    guess(actual, first, last)
  end

  def guess(actual, start, finish)  do
    middle = div( (start+finish) , 2 )
    IO.puts(middle)
    cond do
      actual == middle ->
        actual
      actual > middle ->
        guess(actual, middle+1, finish)
      actual < middle ->
        guess(actual, start, middle-1)
    end
  end
end
