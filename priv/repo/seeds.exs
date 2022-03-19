# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     GithubIssues.Repo.insert!(%GithubIssues.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias GithubIssues.Repo
alias GithubIssues.Accounts.User

attrs = %{
  email: "viniciusbfs2012@gmail.com",
  password: "Teste123",
  name: "Vinicius Batista"
}

%User{}
|> User.changeset(attrs)
|> Repo.insert!()
