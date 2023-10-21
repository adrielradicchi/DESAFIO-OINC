defmodule OincChallenge.Accounts.Projections.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  alias OincChallenge.Accounts.Projections.{Account, User}

  @primary_key {:id, :binary_id, autogenerate: false}
  @foreign_key_type :binary_id
  schema "transactions" do
    field(:amount, :integer)
    field(:type_transaction, Ecto.Enum, values: [:deposit, :withdraw])

    belongs_to(:account, Account)
    belongs_to(:user, User)
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:id, :amount, :type_transaction, :account_id, :user_id])
    |> validate_required([:id, :amount, :type_transaction, :account_id, :user_id])
    |> assoc_constraint(:account)
  end
end
