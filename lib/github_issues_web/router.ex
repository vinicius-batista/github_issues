defmodule GithubIssuesWeb.Router do
  use GithubIssuesWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.Pipeline,
      error_handler: GithubIssuesWeb.AuthController,
      module: GithubIssues.Guardian

    plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "bearer"}
    plug Guardian.Plug.EnsureAuthenticated
    plug Guardian.Plug.LoadResource
  end

  scope "/api/v1", GithubIssuesWeb do
    pipe_through :api

    scope "/auth" do
      post "/login", AuthController, :login
    end
  end

  scope "/api/v1", GithubIssuesWeb do
    pipe_through [:api, :ensure_auth]

    scope "/auth" do
      get "/me", AuthController, :me
    end

    resources "/webhooks", WebhookController, except: [:new, :edit]
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: GithubIssuesWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
