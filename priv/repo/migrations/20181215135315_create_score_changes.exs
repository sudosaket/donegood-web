defmodule Donegood.Repo.Migrations.CreateScoreChanges do
  use Ecto.Migration

  def change do
    create table(:score_changes) do
      add :from, :integer
      add :to, :integer
      add :user_id, references(:users, on_delete: :nothing)
      add :deed_id, references(:deeds, on_delete: :nothing)

      timestamps()
    end

    create index(:score_changes, [:user_id])
    create index(:score_changes, [:deed_id])
  end
end
