defmodule GithubIssues.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias GithubIssues.Repo

  alias GithubIssues.Accounts.User

  def get_user!(id), do: Repo.get!(User, id)

  def get_user_by(clauses \\ []), do: Repo.get_by(User, clauses)

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  alias GithubIssues.Accounts.UserToken

  def get_token_by(clauses \\ []), do: Repo.get_by(UserToken, clauses)

  def create_token(attrs \\ %{}) do
    %UserToken{}
    |> UserToken.changeset(attrs)
    |> Repo.insert()
  end

  def update_token(%UserToken{} = token, attrs) do
    token
    |> UserToken.changeset(attrs)
    |> Repo.update()
  end
end
