defmodule Workshop do
  @moduledoc """
  Solutions for the session one workshop.
  """

  @doc """
  Calculates the sum of every integer from 1 to n.
  """
  @spec sum(non_neg_integer) :: non_neg_integer
  def sum(0), do: 0
  def sum(n) when is_integer(n) and n > 0, do: n + sum(n-1)

  @doc """
  Uses a binary search to find the number `actual` from the given `range`.

  The function will log each guess it makes to the console.
  """
  @spec guess(pos_integer, Range.t) :: pos_integer
  def guess(actual, range = low..high) when low < actual and actual < high do
    guess = div(low+high, 2)
    IO.puts "Is it #{guess}?"
    do_guess(actual, guess, range)
  end

  defp do_guess(actual, actual, _range), do: actual

  defp do_guess(actual, guess,  _low..high) when guess < actual,
    do: guess(actual, guess+1..high)

  defp do_guess(actual, guess,  low.._high) when guess > actual,
    do: guess(actual, low..guess-1)
end
