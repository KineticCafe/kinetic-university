defmodule Scully do
  def start_link() do
    {:ok, spawn_link(fn -> loop(%{}) end)}
  end

  defp loop(state) do
    receive do
      {:get, key, from} ->
        send from, {:ok, Map.get(state, key)}
        loop(state)
      {:put, key, value, from} ->
        new_state = Map.put(state, key, value)
        send from, {:ok, value}
        loop(new_state)
      {:delete, key, from} ->
        new_state = Map.delete(state, key)
        send from, {:ok, key}
        loop(new_state)
      other ->
        raise "#{__MODULE__} received an invalid message: #{Kernel.inspect other}"
    end
  end

  ## Client API functions

  def get(pid, key) do
    send pid, {:get, key, self}
    receive do
      {:ok, value} -> {:ok, value}
    end
  end

  def put(pid, key, value) do
    send pid, {:put, key, value, self}
    receive do
      {:ok, value} -> {:ok, value}
    end
  end

  def delete(pid, key) do
    send pid, {:delete, key, self}
    receive do
      {:ok, key} -> {:ok, key}
    end
  end
end
