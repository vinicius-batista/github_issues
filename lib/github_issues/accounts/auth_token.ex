defmodule GithubIssues.Accounts.AuthToken do
  @moduledoc """
  Authentication token module
  """
  alias GithubIssues.Accounts
  alias GithubIssues.Guardian

  def generate_refresh_token(access_token, %{"typ" => type, "sub" => user_id}) do
    attrs = %{user_id: user_id, type: type}

    with {:ok, token} <- Accounts.create_token(attrs) do
      tokens =
        token
        |> Map.from_struct()
        |> Map.put(:access_token, access_token)
        |> Map.take([:access_token, :refresh_token, :type])

      {:ok, tokens}
    end
  end

  def generate_access_token(user), do: Guardian.encode_and_sign(user, %{}, token_type: :bearer)

  def revoke_token(nil), do: {:error, "Token not found"}

  def revoke_token(token) do
    token
    |> Accounts.update_token(%{is_revoked: true})
  end

  def authorize(token) do
    case Guardian.resource_from_token(token) do
      {:error, _} -> %{}
      {:ok, current_user, _claims} -> %{current_user: current_user}
    end
  end
end
