defmodule OincChallenge.Accounts.Commands.OpenAccount do
  @enforce_keys [:account_id, :user_name, :goal_name, :initial_balance]

  defstruct [:account_id, :user_name, :goal_name, :initial_balance]

  alias OincChallenge.Accounts.Commands.Validators

  def valid?(command) do
    Skooma.valid?(Map.from_struct(command), schema())
  end

  defp schema do
    %{
      initial_balance: [:int, &Validators.positive_integer(&1)]
    }
  end
end
