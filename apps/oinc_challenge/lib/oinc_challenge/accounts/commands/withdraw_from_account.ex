defmodule OincChallenge.Accounts.Commands.WithdrawFromAccount do
  @enforce_keys [:account_id]

  defstruct [:account_id, :withdraw_amount]

  alias OincChallenge.Accounts
  alias OincChallenge.Accounts.Commands.Validators

  def valid?(command) do
    Skooma.valid?(Map.from_struct(command), schema())
  end

  defp schema do
    %{
      account_id: [:string, Skooma.Validators.regex(Accounts.uuid_regex())],
      withdraw_amount: [:int, &Validators.positive_integer(&1, 1)]
    }
  end
end
