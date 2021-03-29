defmodule Exello.Boards.Board.NameSlug do
  use EctoAutoslugField.Slug, from: :name, to: :slug

  def slug_prefix(bytes_count \\ 8)

  def slug_prefix(bytes_count) do
    bytes_count
    |> :crypto.strong_rand_bytes()
    |> Base.url_encode64(padding: false)
    |> String.downcase()
  end

  def build_slug(sources, changeset) do
    "#{slug_prefix()}-#{super(sources, changeset)}"
  end
end

defmodule Exello.Boards.Board do
  use Exello.Schema
  import Ecto.Changeset
  alias Exello.Boards.Board.NameSlug

  @derive {Phoenix.Param, key: :slug}
  schema "boards" do
    field(:name, :string)
    field(:slug, NameSlug.Type)

    has_many(:lists, Exello.Lists.List, on_delete: :delete_all)
    has_many(:cards, through: [:lists, :cards], on_delete: :delete_all)

    timestamps()
  end

  @doc false
  def changeset(board, attrs) do
    board
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> NameSlug.maybe_generate_slug()
    |> NameSlug.unique_constraint()
  end
end
