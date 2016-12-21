defmodule Okaraoke do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      Plug.Adapters.Cowboy.child_spec(:http, Okaraoke.Plug.Router, [], [port: 4001]),
      worker(Room, []),
      supervisor(Okaraoke.Repo, [])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Okaraoke.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
