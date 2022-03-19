defmodule GithubIssues.Repo.Migrations.CreateUsersAuthTables do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :email, :citext, null: false
      add :hashed_password, :string, null: false
      add :name, :string
      timestamps()
    end

    create unique_index(:users, [:email])

    create table(:users_tokens, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all), null: false
      add :refresh_token, :string, null: false
      add :type, :string, null: false
      add :is_revoked, :boolean, default: false
      timestamps()
    end

    create index(:users_tokens, [:user_id])
    create(unique_index(:users_tokens, [:refresh_token]))
  end
end
