defmodule OincChallenge.Accounts.Commands.DepositIntoAccount do
  @enforce_keys [:account_id]

  defstruct [:account_id, :deposit_amount]

  alias OincChallenge.Accounts
  alias OincChallenge.Accounts.Commands.Validators

  def valid?(command) do
    Skooma.valid?(Map.from_struct(command), schema())
  end

  defp schema do
    %{
      account_id: [:string, Skooma.Validators.regex(Accounts.uuid_regex())],
      deposit_amount: [:int, &Validators.positive_integer(&1, 1)]
    }
  end
end
