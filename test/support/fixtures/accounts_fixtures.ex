defmodule GithubIssues.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `GithubIssues.Accounts` context.
  """

  @valid_attrs %{
    name: "some name",
    password: "test"
  }

  def valid_user_attributes(attrs \\ %{}) do
    Enum.into(attrs, @valid_attrs)
    |> Enum.into(%{
      email: "email#{System.unique_integer()}@email.com"
    })
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> valid_user_attributes()
      |> GithubIssues.Accounts.create_user()

    user
  end

  def extract_user_token(fun) do
    {:ok, captured_email} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token | _] = String.split(captured_email.text_body, "[TOKEN]")
    token
  end
end
