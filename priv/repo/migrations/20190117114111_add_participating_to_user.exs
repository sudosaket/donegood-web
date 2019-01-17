defmodule Donegood.Repo.Migrations.AddParticipatingToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :participating, :boolean
    end
  end
end
