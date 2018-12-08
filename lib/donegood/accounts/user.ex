defmodule Donegood.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset


  schema "users" do
    field :email, :string
    field :facebook_id, :string
    field :facebook_token, :string
    field :google_id, :string
    field :google_token, :string
    field :name, :string
    field :twitter_id, :string

    has_many :deeds, DoneGood.Deeds.Deed

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :facebook_id, :facebook_token, :google_id, :google_token, :twitter_id])
    |> validate_required([:name])
  end
end
