defmodule OincChallenge.Accounts do
  @moduledoc """
  The accounts context
  """
  alias OincChallenge.Repo
  alias OincChallenge.App

  alias OincChallenge.Accounts.Commands.{
    CloseAccount,
    OpenAccount,
    DepositIntoAccount,
    WithdrawFromAccount
  }

  alias OincChallenge.Accounts.Projections.Account

  def get_account(id) do
    case preload_account(id) do
      %Account{} = account ->
        {:ok, account}

      _reply ->
        {:error, :not_found}
    end
  end

  def open_account(%{
        initial_balance: initial_balance,
        user_name: user_name,
        goal_name: goal_name
      }) do
    account_id = Ecto.UUID.generate()

    open_account = %OpenAccount{
      account_id: account_id,
      initial_balance: initial_balance,
      user_name: user_name,
      goal_name: goal_name
    }

    with {:ok, %{events: [%{account_id: id} | _]}} <- App.dispatch(open_account),
         {:ok, %Account{} = account} <- get_account(id) do
      {:ok, account}
    else
      reply ->
        reply
    end
  end

  def open_account(_params), do: {:error, :bad_command}

  def close_account(id) do
    %CloseAccount{
      account_id: id
    }
    |> App.dispatch()
    |> IO.inspect()
  end

  def deposit(id, amount) do
    deposit =
      %DepositIntoAccount{
        account_id: id,
        deposit_amount: amount
      }

      App.dispatch(deposit) |> IO.inspect

    # with {:ok, %{events: [%{account_id: id} | _]}} <- App.dispatch(deposit),
    #      {:ok, %Account{} = account} <- get_account(id) do
    #   {:ok, account}
    # else
    #   reply ->
    #     reply
    # end
  end

  def withdraw(id, amount) do
    withdraw =
      %WithdrawFromAccount{
        account_id: id,
        withdraw_amount: amount
      }

     with {:ok, %{events: [%{account_id: id} | _]}} <- App.dispatch(withdraw),
         {:ok, %Account{} = account} <- get_account(id) do
      {:ok, account}
    else
      reply ->
        reply
    end
  end

  def uuid_regex do
    ~r/[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/
  end

  defp preload_account(id) do
    Account
    |> Repo.get!(id)
    |> Repo.preload([:user, :transactions_user_goal])
    |> replace_att_on_account(:user, [:goal])
    |> replace_att_on_account(:transactions, [:account])
  end

  defp replace_att_on_account(account, att, preload) do
    account
    |> Map.get(att)
    |> Repo.preload(preload)
    |> replace_att_on_account_to_preload_att(account, att)
  end

  defp replace_att_on_account_to_preload_att(preload, account, att) do
    Map.replace(account, att, preload)
  end
end
