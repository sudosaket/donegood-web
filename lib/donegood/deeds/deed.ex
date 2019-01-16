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

    has_many :comments, Donegood.Comments.Comment
    has_many :score_changes, Donegood.Deeds.ScoreChange

    timestamps()
  end

  @doc false
  def changeset(deed, attrs) do
    deed
    |> cast(attrs, [:title, :when, :score, :user_id, :created_by_user_id, :repeats, :repeat_value, :repeat_unit])
    |> validate_required([:title, :when, :score, :user_id, :created_by_user_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:created_by_user_id)
  end
end
