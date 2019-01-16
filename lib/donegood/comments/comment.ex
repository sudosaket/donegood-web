defmodule Donegood.Comments.Comment do
  use Ecto.Schema
  import Ecto.Changeset


  schema "comments" do
    field :body, :string

    belongs_to :user, Donegood.Accounts.User
    belongs_to :deed, Donegood.Deeds.Deed

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:body, :user_id, :deed_id])
    |> validate_required([:body, :user_id, :deed_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:deed_id)
  end
end
