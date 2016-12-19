defmodule SongFinder do
  require Logger

  @doc """
  Get YouTube API data for specified list of keywords. Expects a list.
  """
  def search(keywords) do
    task = Task.async(fn -> request_for_video(keywords) end)
    Task.await(task)
  end

  defp request_for_video(keywords) do
    api_key = Application.get_env(:okaraoke, :api_key)
    keywords = Enum.join(keywords, "+")
    uri = "https://www.googleapis.com/youtube/v3/search?part=snippet&q=#{keywords}&key=#{api_key}"
    Logger.debug("Requesting uri: #{uri}")

    case HTTPoison.get!(uri) do
      %HTTPoison.Response{status_code: 200, body: body} ->
        body = Poison.decode!(body)
        body = body["items"]
        #  %{"id" => %{"kind" => kind}} = body
        #  IO.inspect(body)
        #  case body.kind do
        #    "youtube#video" -> %{"id" => %{"videoId" => video_id}, "snippet" => %{"description" => description}} = body
        #  end
        {:ok, body}
      %HTTPoison.Response{status_code: status} ->
        {:error, status}
    end
  end
end
