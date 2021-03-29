defmodule Exello.Cards.Card do
  use Exello.Schema
  import EctoRanked
  import Ecto.Changeset

  schema "cards" do
    field(:body, :string)
    field(:title, :string)
    field(:color, :string)
    field(:card_type, :string)
    field(:rank, :integer)
    field(:position, :any, virtual: true)
    belongs_to(:list, Exello.Lists.List, type: :binary_id)

    timestamps()
  end

  @doc false
  def changeset(card, attrs) do
    card
    |> cast(attrs, [:title, :body, :color, :card_type, :list_id, :position])
    |> validate_required([:title])
    |> set_rank(scope: :list_id)
  end
end
