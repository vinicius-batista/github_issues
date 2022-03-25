defmodule GithubIssues.Scheduler do
  alias GithubIssues.Scheduler.Worker
  @time_to_wait 60 * 60 * 24

  def schedule_issues(issues, webhook) do
    %{event: :repository_issues, issues: issues, url: webhook.url}
    |> Worker.new(schedule_in: @time_to_wait)
    |> Oban.insert()

    {:ok, %{time_to_wait: @time_to_wait, url: webhook.url}}
  end
end
