defmodule GithubIssues.Webhooks.Policy do
  @behaviour Bodyguard.Policy
  alias GithubIssues.Accounts.User
  alias GithubIssues.Webhooks.Webhook

  def authorize(action, _, _) when action in [:index, :create], do: true

  def authorize(action, %User{id: user_id}, %Webhook{user_id: user_id})
      when action in [:update, :delete, :show],
      do: true

  def authorize(_, _, _), do: false
end
