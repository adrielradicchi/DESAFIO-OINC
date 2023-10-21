defmodule OincChallenge.Accounts.Events.AccountOpened do
  @derive Jason.Encoder

  defstruct [
    :account_id,
    :user_name,
    :goal_name,
    :initial_balance
  ]
end
