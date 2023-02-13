defmodule Bookmarker.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      BookmarkerWeb.Telemetry,
      # Start the Ecto repository
      Bookmarker.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Bookmarker.PubSub},
      # Start Finch
      {Finch, name: Bookmarker.Finch},
      # Start the Endpoint (http/https)
      BookmarkerWeb.Endpoint,
      # Start Redix Connection
      {Redix, name: :main}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Bookmarker.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BookmarkerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
