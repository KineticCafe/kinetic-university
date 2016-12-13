defmodule GithubUserInfo.Requester do
  @moduledoc """
  A basic process that requests JSON user data from the GitHub API.

  Due to its implementation, this module will only make one HTTP request at a
  time. It caches the results of each call as part of its internal state.
  Multiple requests for the same user data will use cached data, if it is
  available.
  """

  use GenServer
  require Logger

  # client API

  @doc """
  Starts an instance of `Requester` using the given process `name`.
  """
  def start_link(name) do
    GenServer.start_link(__MODULE__, %{}, name: name)
  end

  @doc """
  Get API data for the user specified by `username`.
  """
  def get(pid, username) do
    GenServer.call(pid, {:get, username})
  end

  @doc """
  Clears the cache.
  """
  def empty_cache(pid) do
    GenServer.cast(pid, :empty_cache)
  end

  # server callbacks

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
