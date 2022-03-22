defmodule GithubIssues.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias GithubIssues.Accounts.{UserToken, Encryption}
  alias GithubIssues.Webhooks.Webhook

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :email, :string
    field :password, :string, virtual: true, redact: true
    field :hashed_password, :string, redact: true
    field :name, :string
    has_many(:tokens, UserToken, on_delete: :delete_all)
    has_many(:webhooks, Webhook, on_delete: :delete_all)

    timestamps()
  end

  @required_fields ~w(email name hashed_password)a
  @all_fields ~w(password)a ++ @required_fields

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, @all_fields)
    |> hash_password()
    |> validate_required(@required_fields)
    |> update_change(:email, &String.downcase/1)
    |> unique_constraint(:email, name: :users_email_index)
    |> validate_email()
  end

  defp hash_password(%Ecto.Changeset{valid?: true, changes: %{password: pass}} = changeset) do
    changeset
    |> put_change(:hashed_password, Encryption.password_hashing(pass))
  end

  defp hash_password(changeset), do: changeset

  defp validate_email(changeset) do
    changeset
    |> get_field(:email)
    |> check_email(changeset)
  end

  defp check_email(nil, changeset), do: changeset

  defp check_email(email, changeset) do
    case EmailChecker.valid?(email) do
      true -> changeset
      false -> add_error(changeset, :email, "has invalid format", validation: :format)
    end
  end
end
