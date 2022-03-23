defmodule GithubIssuesWeb.IssueController do
  use GithubIssuesWeb, :controller

  action_fallback GithubIssuesWeb.FallbackController

  def schedule(conn, %{"user" => user, "repo" => repo}) do
    current_user = Guardian.Plug.current_resource(conn)

    with {:ok, issues} <- GithubIssues.Github.fetch_repo_info(user, repo),
         webhook <- GithubIssues.Webhooks.get_repository_issues_webhook(current_user.id),
         {:ok, schedule_info} <- GithubIssues.Scheduler.schedule_issues(issues, webhook) do
      conn
      |> put_status(:created)
      |> render("schedule.json", schedule_info: schedule_info)
    end
  end
end
