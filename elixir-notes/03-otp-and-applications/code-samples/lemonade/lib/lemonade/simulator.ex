defmodule Lemonade.Simulate do
  require Logger

  @orders [{"Charlie", 5.0, 2},
           {"Linus", 10.0, 100},
           {"Lucy", 1.0, 1},
           {"Snoopy", 100.0, 1},
           {"Peppermint Patty", 20.0, 5},
           {"Schroeder", 5.0, 1}]

  def lineup do
    @orders
    |> Enum.map(&(order_lemonade(&1)))
  end

  def kiosk do
    @orders
    |> Enum.map(fn(order) ->
      2_000 |> :rand.uniform |> :timer.sleep
      Task.async(fn -> order_lemonade(order) end)
    end)
    |> Enum.map(&(Task.await(&1, :infinity)))
  end

  defp order_lemonade({name, cash, order_quantity}) do
    Logger.info "ORDER: #{name} orders #{order_quantity} lemonades with $#{cash}."

    case Lemonade.Stand.order(cash, order_quantity) do
      {:ok, quantity: quantity, change: change} ->
        Logger.info "PICKUP: #{name} ordered #{order_quantity}, got #{quantity} lemonade(s) and got back $#{change} change."
        {:ok, name: name, order_quantity: order_quantity, quantity: quantity, change: change}

      {:error, :not_enough_cash} ->
        Logger.info "PICKUP: #{name} didn't have enough cash to buy any lemonade."
        {:error, :not_enough_cash, name: name, order_quantity: order_quantity}
    end
  end
end
