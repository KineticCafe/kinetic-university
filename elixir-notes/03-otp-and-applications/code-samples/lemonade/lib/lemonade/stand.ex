defmodule Lemonade.Stand do
  @moduledoc """
  A lemonade stand.
  """
  use GenServer
  require Logger

  @price_per_cup 2.50


  ## client API

  @doc """
  Start the lemonade server.
  """
  def start_link do
    GenServer.start_link(__MODULE__, 0, name: __MODULE__)
  end

  @doc """
  Order some lemonade.

  Lemonade orders will be fully fulfilled if `cash` is greater than the price
  per given `quantity`. If the given amount of `cash` can't fill the desired
  `quantity`, the lemonade stand will make as much lemonade as possible with
  the `cash` provided.

  ## Examples

      iex> Lemonade.Stand.order(5.0, 1)
      {:ok, [quantity: 1, change: 2.5]}

      iex> Lemonade.Stand.order(2.5, 100)
      {:ok, [quantity: 1, change: 0]}

      iex> Lemonade.Stand.order(1.0, 2)
      {:error, :not_enough_cash}

  """
  @spec order(float, pos_integer) ::
    {:ok, [quantity: pos_integer, change: float]} |
    {:error, :not_enough_cash}
  def order(cash, quantity \\ 1) do
    GenServer.call(__MODULE__, {:order, cash: cash, quantity: quantity}, :infinity)
  end

  @doc """
  Get the total earnings of the lemonade stand.
  """
  def total_earnings do
    GenServer.call(__MODULE__, :total_earnings)
  end

  @doc """
  Get the price per cup of lemonade at this lemonade stand.
  """
  def price_per_cup, do: @price_per_cup

  # server functions

  def handle_call({:order, cash: cash, quantity: quantity}, _from, total_earnings) do
    case calculate_payment(cash, quantity) do
      {0, _, _} ->
        reply = {:error, :not_enough_cash}
        {:reply, reply, total_earnings}

      {quantity, earnings, change} ->
        for _ <- 1..quantity do make_lemonade end
        reply = {:ok, quantity: quantity, change: change}
        {:reply, reply, total_earnings + earnings}
    end
  end

  def handle_call(:total_earnings, _from, total_earnings) do
    {:reply, total_earnings, total_earnings}
  end

  # spec @calculate_payment(float, pos_integer) ::
  #   {quantity :: non_neg_integer, earnings :: float, change :: float}
  defp calculate_payment(cash, quantity)
    when is_float(cash) and is_integer(quantity) and quantity > 0 do
    Enum.find_value(quantity..0, fn(n) -> do_calculate_payment(cash, n) end)
  end

  defp do_calculate_payment(_cash, 0), do: {0, 0.0, 0.0}
  defp do_calculate_payment(cash, quantity) do
    total_cost = quantity * @price_per_cup
    if cash >= total_cost do
      {quantity, total_cost, cash - total_cost}
    end
  end

  defp make_lemonade do
    squeeze_lemons
    |> make_simple_syrup
    |> combine
    |> add_ice
    |> garnish
  end

  defp squeeze_lemons, do: do_work("squeezing lemons")
  defp make_simple_syrup(:ok), do: do_work("making simple syrup")
  defp combine(:ok), do: do_work("combining ingredients")
  defp add_ice(:ok), do: do_work("adding ice")
  defp garnish(:ok), do: do_work("adding a garnish. all done!")

  defp do_work(msg) do
    Logger.debug(msg)
    500 |> :rand.uniform |> :timer.sleep
    :ok
  end
end
