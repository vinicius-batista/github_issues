defmodule GithubIssues.Repo.Migrations.AddWebhookUniqueIndex do
  use Ecto.Migration

  def change do
    create(unique_index(:webhooks, [:event, :user_id], name: :webhooks_event_user_id_index))
  end
end
