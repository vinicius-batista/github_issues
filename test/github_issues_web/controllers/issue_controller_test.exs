defmodule GithubIssuesWeb.IssueControllerTest do
  use GithubIssuesWeb.ConnCase
  use Oban.Testing, repo: GithubIssues.Repo
  import GithubIssues.WebhooksFixtures

  describe "schedule" do
    setup [:register_and_log_in_user, :create_webhook]

    test "issues webhook are enqueued", %{conn: conn} do
      conn =
        post(conn, Routes.issue_path(conn, :schedule), %{user: "elixir-lang", repo: "elixir"})

      data = json_response(conn, 201)["data"]
      assert data != %{}
      assert is_bitstring(data["message"])
    end
  end

  defp create_webhook(%{user: user}) do
    webhook = webhook_fixture(user_id: user.id)
    %{webhook: webhook}
  end
end
