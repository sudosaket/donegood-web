defmodule Donegood.Repo.Migrations.AddRepeatsToDeeds do
  use Ecto.Migration

  def change do
    alter table(:deeds) do
      add :repeats, :boolean
      add :repeat_value, :float
      add :repeat_unit, :integer
    end
  end
end
