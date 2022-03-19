defmodule GithubIssues.Accounts.UserToken do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ecto.UUID

  @hash_algorithm :sha256
  @required_fields ~w(refresh_token user_id)a
  @all_fields ~w(is_revoked type)a ++ @required_fields

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users_tokens" do
    field(:is_revoked, :boolean, default: false)
    field(:refresh_token, :string)
    field(:type, :string, default: "refresh-token")
    belongs_to :user, GithubIssues.Accounts.User
    timestamps()
  end

  @doc false
  def changeset(token, attrs) do
    token
    |> cast(attrs, @all_fields)
    |> generate_refresh_token()
    |> validate_required(@required_fields)
    |> unique_constraint(:refresh_token, name: :tokens_refresh_token_index)
  end

  defp generate_refresh_token(changeset) do
    with nil <- get_field(changeset, :refresh_token, nil) do
      refresh_token =
        @hash_algorithm
        |> :crypto.hash(UUID.generate())
        |> Base.encode16(case: :lower)

      changeset
      |> put_change(:refresh_token, refresh_token)
    else
      _ -> changeset
    end
  end
end
