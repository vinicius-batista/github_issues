defmodule GithubIssues.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      GithubIssues.Repo,
      # Start the Telemetry supervisor
      GithubIssuesWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: GithubIssues.PubSub},
      # Start the Endpoint (http/https)
      GithubIssuesWeb.Endpoint,
      # Start a worker by calling: GithubIssues.Worker.start_link(arg)
      {Oban, oban_config()}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GithubIssues.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    GithubIssuesWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  # Conditionally disable queues or plugins here.
  defp oban_config do
    Application.fetch_env!(:github_issues, Oban)
  end
end
