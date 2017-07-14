defmodule Arbie.Application do
  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    client_children = [
      # Starts a worker by calling: Arbie.Worker.start_link(arg1, arg2, arg3)
      # worker(Arbie.Worker, [arg1, arg2, arg3]),
      Supervisor.Spec.worker(Arbie.Clients.GDax, [], name: GDaxClient),
      Supervisor.Spec.worker(Arbie.Clients.Gemini, [], name: GeminiClient),
      Arbie.Storage.InfluxConnection.child_spec
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options

    opts = [strategy: :one_for_one, name: Arbie.ClientSupervisor, max_restarts: 5, max_seconds: 1]
    Supervisor.start_link(client_children, opts)

    Supervisor.start_link(
      [Supervisor.Spec.worker(Arbie.StorageTicker, [])],
      [strategy: :one_for_one, name: Arbie.TickSupervisor, max_restarts: 5, max_seconds: 1]
    )

    Supervisor.start_link(
      [Supervisor.Spec.worker(Arbie.PriceTracker, [])],
      [strategy: :one_for_one, name: Arbie.PriceTrackerSupervisor, max_restarts: 5, max_seconds: 1]
    )



  end
end
