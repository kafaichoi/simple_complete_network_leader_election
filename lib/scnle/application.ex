defmodule Scnle.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be superviseda
    initial_peer = Application.get_env(:scnle, :initial_peer)

    if initial_peer !== nil do
      initial_peer |> String.to_atom() |> Node.connect()
    end
    children = [
      %{
        id: Scnle.Node,
        start: {Scnle.Node, :start_link, []},
        type: :supervisor
      }
      # Starts a worker by calling: Scnle.Worker.start_link(arg)
      # {Scnle.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Scnle.Supervisor]
    Supervisor.start_link(children, opts)
  end
end