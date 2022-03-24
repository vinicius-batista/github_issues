defmodule GithubIssuesWeb.WebhookControllerTest do
  use GithubIssuesWeb.ConnCase

  import GithubIssues.WebhooksFixtures

  alias GithubIssues.Webhooks.Webhook

  @create_attrs %{
    event: :repository_issues,
    url: "some url"
  }
  @update_attrs %{
    event: :repository_issues,
    url: "some updated url"
  }
  @invalid_attrs %{event: nil, url: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  setup :register_and_log_in_user

  describe "index" do
    test "lists all webhooks", %{conn: conn} do
      conn = get(conn, Routes.webhook_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create webhook" do
    test "renders webhook when data is valid", %{conn: conn} do
      conn = post(conn, Routes.webhook_path(conn, :create), webhook: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.webhook_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "event" => "repository_issues",
               "url" => "some url"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.webhook_path(conn, :create), webhook: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders errors when create same webhook to a user", %{conn: conn, user: user} do
      GithubIssues.Webhooks.create_webhook(@create_attrs |> Map.put(:user_id, user.id))
      conn = post(conn, Routes.webhook_path(conn, :create), webhook: @create_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update webhook" do
    setup [:create_webhook]

    test "renders webhook when data is valid", %{conn: conn, webhook: %Webhook{id: id} = webhook} do
      conn = put(conn, Routes.webhook_path(conn, :update, webhook), webhook: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.webhook_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "event" => "repository_issues",
               "url" => "some updated url"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, webhook: webhook} do
      conn = put(conn, Routes.webhook_path(conn, :update, webhook), webhook: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete webhook" do
    setup [:create_webhook]

    test "deletes chosen webhook", %{conn: conn, webhook: webhook} do
      conn = delete(conn, Routes.webhook_path(conn, :delete, webhook))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.webhook_path(conn, :show, webhook))
      end
    end
  end

  defp create_webhook(%{user: user}) do
    webhook = webhook_fixture(user_id: user.id)
    %{webhook: webhook}
  end
end
