defmodule GithubIssues.Accounts.Encryption do
  @moduledoc """
  Module related to password encryption
  """
  def password_hashing(password), do: Argon2.hash_pwd_salt(password)

  def valid_password?(hashed_password, password)
      when is_binary(hashed_password) and byte_size(password) > 0 do
    Argon2.verify_pass(password, hashed_password)
  end

  def valid_password?(_, _) do
    Argon2.no_user_verify()
    false
  end
end
