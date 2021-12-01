defmodule GEMS.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      GEMSWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: GEMS.PubSub},
      GEMSWeb.Presence,
      # Start the Endpoint (http/https)
      GEMSWeb.Endpoint,
      GEMS.MatrixStore,
      {Cluster.Supervisor, [topologies(), [name: GEMS.ClusterSupervisor]]}
      # Start a worker by calling: GEMS.Worker.start_link(arg)
      # {GEMS.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GEMS.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    GEMSWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp topologies do
    Application.get_env(:libcluster, :topologies) || []
  end
end
