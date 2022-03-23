defmodule GithubIssues.Github do
  alias GithubIssues.Github.Client

  def fetch_repo_info(user, repo) do
    with {:ok, issues} <- fetch_issues(user, repo),
         {:ok, contributors} <- fetch_contributors(user, repo) do
      {:ok, %{user: user, repository: repo, issues: issues, contributors: contributors}}
    end
  end

  def fetch_issues(user, repo) do
    url = "/repos/#{user}/#{repo}/issues"

    with {:ok, response} <- Client.get(url) do
      issues =
        response.body
        |> Enum.map(&Map.take(&1, ["title", "user", "labels"]))

      {:ok, issues}
    end
  end

  def fetch_contributors(user, repo) do
    url = "/repos/#{user}/#{repo}/contributors"

    with {:ok, response} <- Client.get(url) do
      contributors =
        response.body
        |> Enum.map(&Map.take(&1, ["login", "contributions"]))

      {:ok, contributors}
    end
  end

  defp fetch_all_user_names(contributors) do
    contributors
    |> Enum.map(fn contributor ->
      name = fetch_user_name(contributor["login"])
      Enum.into(contributor, %{"name" => name})
    end)
  end

  defp fetch_user_name(user) do
    url = "/users/#{user}"

    with {:ok, response} <- Client.get(url) do
      user =
        response.body
        |> Map.take(["name"])

      user["name"]
    end
  end
end
