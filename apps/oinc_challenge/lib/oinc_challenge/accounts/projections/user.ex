defmodule OincChallenge.Accounts.Projections.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias OincChallenge.Accounts.Projections.{Account, Goal, Transaction}

  @primary_key {:id, :binary_id, autogenerate: false}
  @foreign_key_type :binary_id
  schema "users" do
    field(:name, :string)

    has_one(:account, Account)
    has_one(:goal, Goal)
    has_many(:transactions, Transaction)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:id, :name])
    |> validate_required([:id, :name])
  end
end
