defmodule Donegood.Deeds.Deed do
  use Ecto.Schema
  import Ecto.Changeset


  schema "deeds" do
    field :score, :integer
    field :title, :string
    field :when, :date

    field :repeats, :boolean
    field :repeat_value, :integer
    field :repeat_unit, RepetitionUnitEnum

    belongs_to :user, Donegood.Accounts.User
    belongs_to :created_by_user, Donegood.Accounts.User
    timestamps()
  end

  @doc false
  def changeset(deed, attrs) do
    deed
    |> cast(attrs, [:title, :when, :score, :user_id])
    |> validate_required([:title, :when, :score, :user_id, :created_by_user_id])
  end
end
