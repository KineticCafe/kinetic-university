defmodule GithubUserInfo do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      worker(GithubUserInfo.Requester, [GithubUserInfo.Requester])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GithubUserInfo.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def make_lots_of_requests do
    [
      "josevalim",
      "lexmag",
      "ericmj",
      "alco",
      "eksperimental",
      "whatyouhide",
      "yrashk",
      "jwarwick"
    ]
    |> Enum.map(fn(user) ->
      GithubUserInfo.Requester.get(GithubUserInfo.Requester, user)
    end)
  end
end
