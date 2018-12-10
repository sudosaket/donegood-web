defmodule Donegood.Repo.Migrations.AddCreatedByUserToDeed do
  use Ecto.Migration
  import Ecto.Query

  def change do
    alter table(:deeds) do
      add :created_by_user_id, references(:users, on_delete: :nothing)
    end
    flush
    from(p in "deeds",
      update: [set: [created_by_user_id: p.user_id]]
      )
    |> Donegood.Repo.update_all([])
  end
end
