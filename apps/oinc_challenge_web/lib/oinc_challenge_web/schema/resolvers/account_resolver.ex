defmodule OincChallengeWeb.Schema.Resolvers.AccountResolver do
  @moduledoc false
  alias OincChallenge.Accounts
  alias OincChallenge.Accounts.Projections.Account

  def open_account(params, _info) do
    with {:ok, %Account{} = account} <- Accounts.open_account(params) do
      {:ok, account}
    else
      {:error, error_message} -> {:error, error_message}
    end
  end

  def get(%{id: id}, _info) do
    with {:ok, %Account{} = account} <- Accounts.get_account(id) do
      {:ok, account}
    else
      {:error, error_message} -> {:error, error_message}
    end
  end

  def index(_args, _info) do
    # case Context.validate_token(_info) do
    #   {:ok, _token} -> {:ok, Partners.list_entities()}
    #   {:error, error_message} -> {:error, error_message}
    # end
  end

  def close_account(%{id: id}, _info) do
    with {:ok, _account} <- Accounts.close_account(id) do
      {:ok}
    else
      {:error, error_message} -> {:error, error_message}
    end
  end

  def deposit(%{id: id, amount: amount}, _info) do
    with {:ok, _account} <- Accounts.deposit(id, amount) do
      {:ok}
    else
      {:error, error_message} -> {:error, error_message}
    end
  end

  def withdraw(%{id: id, amount: amount}, _info) do
    with {:ok, _account} <- Accounts.withdraw(id, amount) do
      {:ok}
    else
      {:error, error_message} -> {:error, error_message}
    end
  end
end
