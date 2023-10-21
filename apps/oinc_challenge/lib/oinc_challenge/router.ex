defmodule OincChallenge.Router do
  use Commanded.Commands.Router

  alias OincChallenge.Accounts.Aggregates.Account

  alias OincChallenge.Accounts.Commands.{
    CloseAccount,
    OpenAccount,
    DepositIntoAccount,
    WithdrawFromAccount
  }

  middleware(OincChallenge.Support.Middleware.ValidateCommand)

  dispatch([OpenAccount, CloseAccount, DepositIntoAccount, WithdrawFromAccount],
    to: Account,
    identity: :account_id,
    timeout: 1_000
  )
end
