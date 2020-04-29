defmodule MacronBot.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # import Supervisor.Spec, warn: false

    token = ExGram.Config.get(:ex_gram, :token)

    children = [
      ExGram,
      {MacronBot, [method: :polling, token: token]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MacronBot.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
