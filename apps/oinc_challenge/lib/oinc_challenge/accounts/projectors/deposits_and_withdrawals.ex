defmodule OincChallenge.Accounts.Projectors.DepositsAndWithdrawals do
  use Commanded.Projections.Ecto,
    application: OincChallenge.App,
    name: "Accounts.Projectors.DepositsAndWithdrawals",
    repo: OincChallenge.Repo,
    consistency: :strong

  alias OincChallenge.Accounts
  alias OincChallenge.Accounts.Events.{DepositedIntoAccount, WithdrawnFromAccount}
  alias OincChallenge.Accounts.Projections.{Account, Transaction}
  alias Ecto.Multi

  project(%DepositedIntoAccount{account_id: id, new_current_balance: new_balance}, _metadata, fn multi ->
    IO.inspect id
    with {:ok, %Account{current_balance: current, user_id: user_id} = account} <- Accounts.get_account(id) do
      multi
      |> Multi.insert(:transaction, Transaction.changeset(%Transaction{}, %{
          id: Ecto.UUID.generate(),
          user_id: user_id,
          account_id: id,
          amount: new_balance,
          type_transaction: :deposit
        })
      )
      |> Multi.update(
        :account,
        Account.changeset(
          account,
          %{current_balance: current + new_balance}
        )
      )
    else
      _ -> multi
    end
  end)

  project(%WithdrawnFromAccount{account_id: id, new_current_balance: new_balance} = evt, _metadata, fn multi ->
    with {:ok, %Account{current_balance: current, user_id: user_id} = account} <- Accounts.get_account(evt.account_id) do
      multi
      |> Multi.insert(:transaction, Transaction.changeset(%Transaction{}, %{
          id: Ecto.UUID.generate(),
          user_id: user_id,
          account_id: id,
          amount: new_balance,
          type_transaction: :deposit
        })
      )
      |> Multi.update(
        :account,
        Account.changeset(
          account,
          %{current_balance: current - new_balance}
        )
      )
    else
      _ -> multi
    end
  end)
end
