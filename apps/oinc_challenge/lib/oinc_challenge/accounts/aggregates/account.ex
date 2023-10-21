defmodule OincChallenge.Accounts.Aggregates.Account do
  defstruct id: nil,
            user: nil,
            current_balance: nil,
            closed?: false

  alias __MODULE__

  alias OincChallenge.Accounts.Projections.User

  alias OincChallenge.Accounts.Commands.{
    OpenAccount,
    CloseAccount,
    DepositIntoAccount,
    WithdrawFromAccount
  }

  alias OincChallenge.Accounts.Events.{
    AccountOpened,
    AccountClosed,
    DepositedIntoAccount,
    WithdrawnFromAccount
  }

  def execute(
        %Account{id: nil},
        %OpenAccount{
          account_id: account_id,
          user_name: user_name,
          goal_name: goal_name,
          initial_balance: initial_balance
        }
      )
      when initial_balance > 0 do
    %AccountOpened{
      account_id: account_id,
      user_name: user_name,
      goal_name: goal_name,
      initial_balance: initial_balance
    }
  end

  def execute(
        %Account{id: nil},
        %OpenAccount{
          user_name: user_name,
          goal_name: goal_name,
          initial_balance: initial_balance
        }
      )
      when initial_balance <= 0 do
    %AccountOpened{
      user_name: user_name,
      goal_name: goal_name,
      initial_balance: 0
    }
  end

  def execute(%Account{}, %OpenAccount{}) do
    {:error, :account_already_opened}
  end

  def execute(
        %Account{id: account_id, closed?: true},
        %CloseAccount{
          account_id: account_id
        }
      ) do
    {:error, :account_already_closed}
  end

  def execute(
        %Account{id: account_id, closed?: false},
        %CloseAccount{
          account_id: account_id
        }
      ) do
    %AccountClosed{
      account_id: account_id
    }
  end

  def execute(
        %Account{},
        %CloseAccount{}
      ) do
    {:error, :not_found}
  end

  def execute(
        %Account{id: account_id, closed?: false},
        %DepositIntoAccount{account_id: account_id, deposit_amount: amount}
      ) do
    %DepositedIntoAccount{
      account_id: account_id,
      new_current_balance: amount
    }
  end

  def execute(
        %Account{id: account_id, closed?: true},
        %DepositIntoAccount{account_id: account_id}
      ) do
    {:error, :account_closed}
  end

  def execute(
        %Account{},
        %DepositIntoAccount{}
      ) do
    {:error, :not_found}
  end

  def execute(
        %Account{id: account_id, closed?: false, current_balance: current_balance},
        %WithdrawFromAccount{account_id: account_id, withdraw_amount: amount}
      ) do
    if current_balance - amount > 0 do
      %WithdrawnFromAccount{
        account_id: account_id,
        new_current_balance: amount
      }
    else
      {:error, :insufficient_funds}
    end
  end

  def execute(
        %Account{id: account_id, closed?: true},
        %WithdrawFromAccount{account_id: account_id}
      ) do
    {:error, :account_closed}
  end

  def execute(
        %Account{},
        %WithdrawFromAccount{}
      ) do
    {:error, :not_found}
  end

  # state mutators

  def apply(
        %Account{} = account,
        %AccountOpened{
          user_name: user_name,
          goal_name: _goal_name,
          initial_balance: initial_balance
        }
      ) do
    %Account{
      account
      | user: %User{name: user_name},
        current_balance: initial_balance
    }
  end

  def apply(
        %Account{id: account_id} = account,
        %AccountClosed{
          account_id: account_id
        }
      ) do
    %Account{
      account
      | closed?: true
    }
  end

  def apply(
        %Account{
          id: account_id,
          current_balance: _current_balance
        } = account,
        %DepositedIntoAccount{
          account_id: account_id,
          new_current_balance: new_current_balance
        }
      ) do
    %Account{
      account
      | current_balance: new_current_balance
    }
  end

  def apply(
        %Account{
          id: account_id,
          current_balance: _current_balance
        } = account,
        %WithdrawnFromAccount{
          account_id: account_id,
          new_current_balance: new_current_balance
        }
      ) do
    %Account{
      account
      | current_balance: new_current_balance
    }
  end

  # def after_command(_command), do: :timer.minutes(1)

  # def after_event(_event), do: :timer.minutes(1)

  # def after_error(_error), do: :timer.minutes(1)
end
