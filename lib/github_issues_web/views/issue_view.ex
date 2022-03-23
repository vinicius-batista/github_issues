defmodule GithubIssuesWeb.IssueView do
  use GithubIssuesWeb, :view

  def render("schedule.json", %{schedule_info: schedule_info}) do
    {:ok, datetime} = DateTime.now("Etc/UTC")
    schedule_time = datetime |> DateTime.add(schedule_info.time_to_wait)

    %{
      data: %{
        message: "Issues will be send to #{schedule_info.url} at #{schedule_time}"
      }
    }
  end
end
