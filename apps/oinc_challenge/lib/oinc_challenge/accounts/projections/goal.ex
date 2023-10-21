defmodule OincChallenge.Accounts.Projections.Goal do
  use Ecto.Schema
  import Ecto.Changeset

  alias OincChallenge.Accounts.Projections.User

  @primary_key {:id, :binary_id, autogenerate: false}
  @foreign_key_type :binary_id
  schema "goals" do
    field(:name, :string)

    belongs_to(:user, User)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:id, :name, :user_id])
    |> validate_required([:id, :name, :user_id])
    |> assoc_constraint(:user)
  end
end
