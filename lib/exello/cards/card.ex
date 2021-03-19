defmodule Exello.Cards.Card do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cards" do
    field :body, :string
    field :title, :string
    belongs_to :list, Exello.Lists.List

    timestamps()
  end

  @doc false
  def changeset(card, attrs) do
    card
    |> cast(attrs, [:title, :body])
    |> cast_assoc(:list, with: &Exello.Lists.List.changeset/2)
    |> validate_required([:title, :body])
  end
end
