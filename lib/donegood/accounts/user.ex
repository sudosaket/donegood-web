defmodule Donegood.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset


  schema "users" do
    field :email, :string
    field :username, :string
    field :facebook_id, :string
    field :facebook_token, :string
    field :google_id, :string
    field :google_token, :string
    field :name, :string
    field :twitter_id, :string
    field :picture, :string


    has_many :deeds, Donegood.Deeds.Deed
    has_many :created_deeds, Donegood.Deeds.Deed, foreign_key: :created_by_user_id

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :facebook_id, :facebook_token, :google_id, :google_token, :twitter_id, :picture, :username])
    |> validate_required([:name])
    |> unique_constraint(:username)
  end
end
