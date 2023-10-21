defmodule OincChallenge.Accounts.Supervisor do
  use Supervisor

  alias OincChallenge.Accounts

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def init(_arg) do
    Supervisor.init(
      [
        Accounts.Projectors.AccountClosed,
        Accounts.Projectors.AccountOpened,
        Accounts.Projectors.DepositsAndWithdrawals
      ],
      strategy: :one_for_one
    )
  end
end
