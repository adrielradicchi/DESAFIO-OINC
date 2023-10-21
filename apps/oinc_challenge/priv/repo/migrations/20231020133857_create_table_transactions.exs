defmodule OincChallenge.Repo.Migrations.CreateTableTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:amount, :integer)
      add(:type_transaction, :string)
      add(:account_id, references(:accounts, on_delete: :nothing, type: :binary_id))
      add(:user_id, references(:users, on_delete: :nothing, type: :binary_id))

      timestamps()
    end

    create(index(:transactions, [:account_id]))
    create(index(:transactions, [:user_id]))
  end
end
