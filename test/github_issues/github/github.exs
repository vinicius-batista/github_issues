defmodule GithubIssues.GithubTest do
  @moduledoc """
  Github module test
  """
  use GithubIssues.DataCase

  describe "Github" do
    test "check if fetch_issues/2 returns all issues from a repo" do
      with {:ok, issues} <- GithubIssues.Github.fetch_issues("elixir-lang", "elixir") do
        first_issue = List.first(issues)
        assert is_list(issues)
        assert is_map(first_issue)
        assert is_list(first_issue["labels"])
        assert is_map(first_issue["user"])
      end
    end

    test "check if fetch_contributors/2 returns all contributors from a repo" do
      with {:ok, contributors} <- GithubIssues.Github.fetch_contributors("elixir-lang", "elixir") do
        first_contributor = List.first(contributors)
        assert is_list(contributors)
        assert is_map(first_contributor)
        assert is_binary(first_contributor["login"])
        assert is_number(first_contributor["contributions"])
      end
    end

    test "check if fetch_repo_info/2 returns all issues, contributors from a repo" do
      with {:ok, repo_info} <- GithubIssues.Github.fetch_repo_info("elixir-lang", "elixir") do
        IO.inspect(repo_info)
        assert is_map(repo_info)
        assert is_list(repo_info["issues"])
        assert is_list(repo_info["contributors"])
        assert is_binary(repo_info["user"])
      end
    end
  end
end
