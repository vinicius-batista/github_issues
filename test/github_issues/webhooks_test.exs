defmodule GithubIssues.WebhooksTest do
  use GithubIssues.DataCase

  alias GithubIssues.Webhooks

  describe "webhooks" do
    alias GithubIssues.Webhooks.Webhook

    import GithubIssues.WebhooksFixtures
    import GithubIssues.AccountsFixtures

    @invalid_attrs %{event: nil, url: nil}

    test "list_webhooks/0 returns all webhooks" do
      webhook = webhook_fixture()
      assert Webhooks.list_webhooks(webhook.user_id) == [webhook]
    end

    test "get_webhook!/1 returns the webhook with given id" do
      webhook = webhook_fixture()
      assert Webhooks.get_webhook!(webhook.id) == webhook
    end

    test "create_webhook/1 with valid data creates a webhook" do
      user = user_fixture()
      valid_attrs = %{event: :repository_issues, url: "some url", user_id: user.id}

      assert {:ok, %Webhook{} = webhook} = Webhooks.create_webhook(valid_attrs)
      assert webhook.event == :repository_issues
      assert webhook.url == "some url"
    end

    test "create_webhook/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Webhooks.create_webhook(@invalid_attrs)
    end

    test "update_webhook/2 with valid data updates the webhook" do
      webhook = webhook_fixture()
      update_attrs = %{event: :repository_issues, url: "some updated url"}

      assert {:ok, %Webhook{} = webhook} = Webhooks.update_webhook(webhook, update_attrs)
      assert webhook.event == :repository_issues
      assert webhook.url == "some updated url"
    end

    test "update_webhook/2 with invalid data returns error changeset" do
      webhook = webhook_fixture()
      assert {:error, %Ecto.Changeset{}} = Webhooks.update_webhook(webhook, @invalid_attrs)
      assert webhook == Webhooks.get_webhook!(webhook.id)
    end

    test "delete_webhook/1 deletes the webhook" do
      webhook = webhook_fixture()
      assert {:ok, %Webhook{}} = Webhooks.delete_webhook(webhook)
      assert_raise Ecto.NoResultsError, fn -> Webhooks.get_webhook!(webhook.id) end
    end

    test "change_webhook/1 returns a webhook changeset" do
      webhook = webhook_fixture()
      assert %Ecto.Changeset{} = Webhooks.change_webhook(webhook)
    end
  end
end