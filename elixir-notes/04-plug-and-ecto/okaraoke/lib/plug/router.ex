defmodule Okaraoke.Plug.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/" do
    conn
    |> put_resp_content_type("text/html")
    |> send_resp(200, EEx.eval_file("templates/home.html.eex"))
  end

  get "/room/:video" do
    conn
    |> put_resp_content_type("text/html")
    |> send_resp(200, EEx.eval_file("templates/song_playing.html.eex", [video: video]))
  end

  get "/room" do
    page_content =
    case String.length(Room.video_id) do
      0 -> EEx.eval_file("templates/request_song.html.eex")
      _ -> EEx.eval_file("templates/song_requested.html.eex", [video: Room.video_id])
    end

    conn
    |> put_resp_content_type("text/html")
    |> send_resp(200, page_content)
  end

  match _ do
    conn
    |> send_resp(404, "oops")
    |> halt
  end
end
