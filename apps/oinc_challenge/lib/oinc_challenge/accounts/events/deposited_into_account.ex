defmodule OincChallenge.Accounts.Events.DepositedIntoAccount do
  @derive Jason.Encoder

  defstruct [
    :account_id,
    :new_current_balance
  ]
end
