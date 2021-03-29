defmodule Exello.Lists.List do
  use Exello.Schema
  import EctoRanked
  import Ecto.Changeset

  schema "lists" do
    field(:name, :string)
    field(:color, :string)
    field(:rank, :integer)
    field(:position, :any, virtual: true)
    belongs_to(:board, Exello.Boards.Board, type: :binary_id)
    has_many(:cards, Exello.Cards.Card, on_delete: :delete_all)

    timestamps()
  end

  @doc false
  def changeset(list, attrs) do
    list
    |> cast(attrs, [:name, :color, :board_id, :position])
    |> validate_required([:name])
    |> set_rank(scope: :board_id)
  end
end
