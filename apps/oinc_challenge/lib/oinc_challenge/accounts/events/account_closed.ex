defmodule OincChallenge.Accounts.Events.AccountClosed do
  @derive Jason.Encoder

  defstruct [:account_id]
end
