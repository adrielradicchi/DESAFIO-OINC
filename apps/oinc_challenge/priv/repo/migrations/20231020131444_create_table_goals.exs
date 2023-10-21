defmodule OincChallenge.Repo.Migrations.CreateTableGoals do
  use Ecto.Migration

  def change do
    create table(:goals, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:name, :string)
      add(:user_id, references(:users, on_delete: :nothing, type: :binary_id))

      timestamps()
    end
  end
end
