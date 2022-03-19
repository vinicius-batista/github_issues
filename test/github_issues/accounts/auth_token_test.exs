defmodule GithubIssues.AuthTokenTest do
  @moduledoc """
  AuthToken module test
  """
  use GithubIssues.DataCase
  alias GithubIssues.Accounts
  alias GithubIssues.Accounts.AuthToken

  @valid_attrs %{
    name: "some name",
    email: "email@email.com",
    password: "test"
  }

  setup do
    {:ok, user} = Accounts.create_user(@valid_attrs)
    {:ok, token} = Accounts.create_token(%{user_id: user.id, type: "refresh-token"})
    {:ok, %{user: %Accounts.User{user | password: nil}, token: token}}
  end

  test "generate_access_token returns new token with claims", %{user: user} do
    {:ok, access_token, claims} = AuthToken.generate_access_token(user)
    assert is_bitstring(access_token)
    assert is_map(claims)
    assert claims["sub"] == to_string(user.id)
    assert claims["typ"] == "bearer"
  end

  test "generate_access_token returns error" do
    {:error, reason} = AuthToken.generate_access_token(%{})
    assert reason == "Unknow resource type"
  end

  test "authorize returns user", %{user: user} do
    {:ok, access_token, _claims} = AuthToken.generate_access_token(user)
    %{current_user: current_user} = AuthToken.authorize(access_token)
    assert user == current_user
  end

  test "generate_refresh_token returns auth tokens", %{user: user} do
    access_token = "random-string"
    claims = %{"typ" => "bearer", "sub" => user.id}
    {:ok, tokens} = AuthToken.generate_refresh_token(access_token, claims)
    assert access_token == tokens.access_token
    assert claims["typ"] == tokens.type
    assert is_bitstring(tokens.refresh_token)
  end

  test "revoke_token returns token changeset revoked", %{token: token} do
    {:ok, token_revoked} = AuthToken.revoke_token(token)
    assert token_revoked.is_revoked
    assert token_revoked.refresh_token == token.refresh_token
    assert token_revoked.user_id == token.user_id
  end

  test "revoke_token returns error" do
    {:error, reason} = AuthToken.revoke_token(nil)
    assert reason == "Token not found"
  end
end
