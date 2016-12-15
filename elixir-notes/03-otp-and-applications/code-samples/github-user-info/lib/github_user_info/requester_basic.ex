defmodule GithubUserInfo.RequesterBasic do
  use GenServer
  require Logger

  def handle_call({:get, username}, _from, state) do
    value = case Map.get(state, username) do
      nil ->
        {:ok, response} = request_for_username(username)
        response
      value -> value
    end

    new_state = Map.put(state, username, value)
    {:reply, value, new_state}
  end

  def handle_cast(:empty_cache, _state) do
    {:noreply, %{}}
  end

  defp request_for_username(username) do
    uri = "https://api.github.com/users/#{username}"
    Logger.debug("Requesting uri: #{uri}")

    case HTTPoison.get!(uri) do
      %HTTPoison.Response{status_code: 200, body: body} ->
        {:ok, Poison.decode!(body)}
      %HTTPoison.Response{status_code: status} ->
        {:error, status}
    end
  end
end
