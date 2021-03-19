defmodule Exello.Lists.List do
  use Ecto.Schema
  import Ecto.Changeset

  schema "lists" do
    field :name, :string
    # field :board_id, :integer
    belongs_to :board, Exello.Boards.Board

    timestamps()
  end

  @doc false
  def changeset(list, attrs) do
    list
    |> cast(attrs, [:name])
    |> cast_assoc(:board, with: &Exello.Boards.Board.changeset/2)
    |> validate_required([:name])
  end
end
