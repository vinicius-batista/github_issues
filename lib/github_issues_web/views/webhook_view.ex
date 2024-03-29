defmodule GithubIssuesWeb.WebhookView do
  use GithubIssuesWeb, :view
  alias GithubIssuesWeb.WebhookView

  def render("index.json", %{webhooks: webhooks}) do
    %{data: render_many(webhooks, WebhookView, "webhook.json")}
  end

  def render("show.json", %{webhook: webhook}) do
    %{data: render_one(webhook, WebhookView, "webhook.json")}
  end

  def render("webhook.json", %{webhook: webhook}) do
    %{
      id: webhook.id,
      url: webhook.url,
      event: webhook.event
    }
  end
end
