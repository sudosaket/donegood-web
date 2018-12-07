defmodule Donegood.Repo.Migrations.CreateDeeds do
  use Ecto.Migration

  def change do
    create table(:deeds) do
      add :title, :string
      add :when, :date
      add :score, :integer
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:deeds, [:user_id])
  end
end
