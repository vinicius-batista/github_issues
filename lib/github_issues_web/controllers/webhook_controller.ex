defmodule GithubIssuesWeb.WebhookController do
  use GithubIssuesWeb, :controller

  alias GithubIssues.Webhooks
  alias GithubIssues.Webhooks.Webhook

  action_fallback GithubIssuesWeb.FallbackController

  def index(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    webhooks = Webhooks.list_webhooks(user.id)
    render(conn, "index.json", webhooks: webhooks)
  end

  # TODO: improve validation
  def create(conn, %{"webhook" => webhook_params}) do
    user = Guardian.Plug.current_resource(conn)

    with {:ok, %Webhook{} = webhook} <-
           Webhooks.create_webhook(webhook_params |> Enum.into(%{"user_id" => user.id})) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.webhook_path(conn, :show, webhook))
      |> render("show.json", webhook: webhook)
    end
  end

  # TODO: Implement bodyguard validation
  def show(conn, %{"id" => id}) do
    webhook = Webhooks.get_webhook!(id)
    render(conn, "show.json", webhook: webhook)
  end

  def update(conn, %{"id" => id, "webhook" => webhook_params}) do
    webhook = Webhooks.get_webhook!(id)

    with {:ok, %Webhook{} = webhook} <- Webhooks.update_webhook(webhook, webhook_params) do
      render(conn, "show.json", webhook: webhook)
    end
  end

  def delete(conn, %{"id" => id}) do
    webhook = Webhooks.get_webhook!(id)

    with {:ok, %Webhook{}} <- Webhooks.delete_webhook(webhook) do
      send_resp(conn, :no_content, "")
    end
  end
end
