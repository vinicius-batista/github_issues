defmodule GithubIssues.SchedulerTest do
  use GithubIssues.DataCase
  use Oban.Testing, repo: GithubIssues.Repo

  alias GithubIssues.Scheduler

  describe "scheduler" do
    import GithubIssues.WebhooksFixtures

    test "issues webhook are enqueued" do
      issues = %{}
      webhook = webhook_fixture()
      {:ok, schedule_info} = Scheduler.schedule_issues(issues, webhook)

      assert schedule_info.url == webhook.url
      assert schedule_info.time_to_wait == 24 * 60 * 60

      schedule_time = DateTime.add(DateTime.utc_now(), schedule_info.time_to_wait, :second)

      assert_enqueued(
        worker: Scheduler.Worker,
        args: %{event: :repository_issues, issues: issues, url: webhook.url},
        scheduled_at: schedule_time
      )
    end
  end
end
