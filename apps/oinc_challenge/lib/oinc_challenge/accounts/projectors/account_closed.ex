defmodule OincChallenge.Accounts.Projectors.AccountClosed do
  use Commanded.Projections.Ecto,
    application: OincChallenge.App,
    name: "Accounts.Projectors.AccountClosed",
    repo: OincChallenge.Repo,
    consistency: :strong

  alias OincChallenge.Accounts
  alias OincChallenge.Accounts.Events.AccountClosed
  alias OincChallenge.Accounts.Projections.Account
  alias Ecto.Multi

  project(%AccountClosed{account_id: account_id}, _metadata, fn multi ->
    with {:ok, %Account{} = account} <- Accounts.get_account(account_id) do
      Multi.update(
        multi,
        :account,
        Account.changeset(account, %{status: Account.status().closed})
      )
    else
      _ -> multi
    end
  end)
end
