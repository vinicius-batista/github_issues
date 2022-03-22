defmodule GithubIssues.WebhooksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `GithubIssues.Webhooks` context.
  """

  @doc """
  Generate a webhook.
  """
  def webhook_fixture(attrs \\ %{}) do
    user = GithubIssues.AccountsFixtures.user_fixture()

    {:ok, webhook} =
      attrs
      |> Enum.into(%{
        event: :repository_issues,
        url: "some url",
        user_id: user.id
      })
      |> GithubIssues.Webhooks.create_webhook()

    webhook
  end
end
