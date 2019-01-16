defmodule Donegood.Deeds.ScoreChange do
  use Ecto.Schema
  import Ecto.Changeset


  schema "score_changes" do
    field :from, :integer
    field :to, :integer

    belongs_to :deed, Donegood.Deeds.Deed
    belongs_to :user, Donegood.Accounts.User
    timestamps()
  end

  @doc false
  def changeset(score_change, attrs) do
    score_change
    |> cast(attrs, [:from, :to, :user_id, :deed_id])
    |> validate_required([:from, :to, :user_id, :deed_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:deed_id)
  end
end
