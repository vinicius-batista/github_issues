defmodule GithubIssues.Repo do
  use Ecto.Repo,
    otp_app: :github_issues,
    adapter: Ecto.Adapters.Postgres
end
