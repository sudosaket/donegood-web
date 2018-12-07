defmodule Donegood.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :email, :string
      add :facebook_id, :string
      add :facebook_token, :string
      add :google_id, :string
      add :google_token, :string
      add :twitter_id, :string

      timestamps()
    end

  end
end
