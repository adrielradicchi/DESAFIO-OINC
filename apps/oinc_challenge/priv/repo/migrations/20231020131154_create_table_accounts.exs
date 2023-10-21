defmodule OincChallenge.Repo.Migrations.CreateTableAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :current_balance, :integer
      add :status, :string
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end
  end
end
