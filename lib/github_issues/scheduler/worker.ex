defmodule GithubIssues.Scheduler.Worker do
  use Oban.Worker, queue: :github_issues

  @impl Oban.Worker
  def perform(%Oban.Job{args: args}) do
    case args do
      %{"event" => "repository_issues"} -> send_webhook(args["url"], args["issues"])
    end

    :ok
  end

  defp send_webhook(url, body) do
    HTTPoison.post!(url, Jason.encode!(body))
  end
end
