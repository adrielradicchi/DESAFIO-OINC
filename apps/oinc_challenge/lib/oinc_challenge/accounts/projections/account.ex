defmodule OincChallenge.Accounts.Projections.Account do
  use Ecto.Schema
  import Ecto.Changeset

  alias OincChallenge.Accounts.Projections.{User, Transaction}

  @primary_key {:id, :binary_id, autogenerate: false}
  @foreign_key_type :binary_id
  schema "accounts" do
    field(:current_balance, :integer)
    field(:status, Ecto.Enum, values: [:open, :close])

    belongs_to(:user, User)

    has_many(:transactions, Transaction)
    has_many(:transactions_user_goal, through: [:transactions, :user, :goal])

    timestamps()
  end

  def status do
    %{
      open: "open",
      closed: "closed"
    }
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:id, :current_balance, :status, :user_id])
    |> validate_required([:id, :current_balance, :status, :user_id])
    |> assoc_constraint(:user)
  end
end
