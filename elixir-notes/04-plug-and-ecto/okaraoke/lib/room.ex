defmodule Room do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, "", name: __MODULE__)
  end

  @doc """
  Add song request to server's message queue with specified video_id from you_tub.
  """
  def request_song(video_id) do
    GenServer.cast(__MODULE__, video_id)
  end

  @doc """
  Get the current video being played.
  """
  def video_id do
    GenServer.call( __MODULE__, :video_id)
  end

  def handle_call(:video_id, _from, video_id) do
    {:reply, video_id, video_id}
  end

  def handle_cast(video_id, state) do
    {:noreply, video_id}
  end
end
