defmodule GithubIssues.Guardian do
  use Guardian, otp_app: :github_issues

  alias GithubIssues.Accounts.User
  alias GithubIssues.Repo

  def subject_for_token(%User{} = user, _claims), do: {:ok, to_string(user.id)}
  def subject_for_token(_, _), do: {:error, "Unknow resource type"}

  def resource_from_claims(%{"sub" => user_id}), do: {:ok, Repo.get(User, user_id)}
  def resource_from_claims(_claims), do: {:error, "Unknow resource type"}
end
