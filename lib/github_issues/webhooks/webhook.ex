defmodule GithubIssues.Webhooks.Webhook do
  use Ecto.Schema
  import Ecto.Changeset
  alias GithubIssues.Accounts.User

  defdelegate authorize(action, user, params), to: GithubIssues.Webhooks.Policy

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "webhooks" do
    field :event, Ecto.Enum, values: [:repository_issues]
    field :url, :string
    belongs_to :user, User
    timestamps()
  end

  @required_fields ~w(url event user_id)a
  @all_fields ~w()a ++ @required_fields

  @doc false
  def changeset(webhook, attrs) do
    webhook
    |> cast(attrs, @all_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:event, name: :webhooks_event_user_id_index)
  end
end
