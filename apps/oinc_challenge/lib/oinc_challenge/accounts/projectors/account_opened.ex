defmodule OincChallenge.Accounts.Projectors.AccountOpened do
  use Commanded.Projections.Ecto,
    application: OincChallenge.App,
    repo: OincChallenge.Repo,
    name: "Accounts.Projectors.AccountOpened",
    consistency: :strong

  alias Ecto.Multi
  # alias Phoenix.PubSub
  # alias Commanded.PubSub.PhoenixPubSub
  alias OincChallenge.Accounts.Events.AccountOpened
  alias OincChallenge.Accounts.Projections.{Account, Goal, Transaction, User}

  project(
    %AccountOpened{
      account_id: account_id,
      user_name: user_name,
      goal_name: goal_name,
      initial_balance: initial_balance
    },
    _metadata,
    fn multi ->
      multi
      |> Multi.insert(
        :user,
        User.changeset(%User{}, %{id: Ecto.UUID.generate(), name: user_name})
      )
      |> Multi.insert(:goal, fn %{user: user} ->
        Goal.changeset(%Goal{}, %{
          id: Ecto.UUID.generate(),
          name: goal_name,
          user_id: user.id,
          user: user
        })
      end)
      |> Multi.insert(:account_opened, fn %{goal: %Goal{user_id: user_id}} ->
        Account.changeset(%Account{}, %{
          id: account_id,
          user_id: user_id,
          current_balance: initial_balance,
          status: Account.status().open
        })
      end)
      |> Multi.insert(:transaction, fn %{account_opened: %Account{id: id, user_id: user_id}} ->
        Transaction.changeset(%Transaction{}, %{
          id: Ecto.UUID.generate(),
          user_id: user_id,
          account_id: id,
          amount: initial_balance,
          type_transaction: :deposit
        })
      end)
    end
  )

  # @impl Commanded.Projections.Ecto
  # def after_update(_event, _metadata, %{account_opened: account}) do
  #   # Use the event, metadata, or `Ecto.Multi` changes and return `:ok`
  #   # IO.inspect event
  #   # IO.inspect metadata
  #   # IO.inspect changes
  #   # PubSub.subscribe(OincChallenge.PubSub, "account_opened:#{account.id}")

  #   # PubSub.broadcast(
  #   #   OincChallenge.PubSub,
  #   #   "account_opened:#{account.id}",
  #   #   {:account_opened, account}
  #   # )

  #   # Absinthe.Subscription.publish(OincChallengeWeb.Endpoint, account, account_opened: account.id)
  #   {:ok, account}
  # end
end
