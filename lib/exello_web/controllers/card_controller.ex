defmodule ExelloWeb.CardController do
  use ExelloWeb, :controller

  alias Exello.{Boards, Lists, Cards}
  alias Exello.Cards.Card

  def index(conn, %{"board_id" => board_id, "list_id" => list_id} = _params) do
    board = Boards.get_board!(board_id)
    list = Lists.get_list!(list_id)
    cards = Cards.list_cards()
    render(conn, "index.html", board: board, list: list, cards: cards)
  end

  def new(conn, %{"board_id" => board_id, "list_id" => list_id} = _params) do
    board = Boards.get_board!(board_id)
    list = Lists.get_list!(list_id)
    changeset = Cards.change_card(%Card{})
    render(conn, "new.html", board: board, list: list, changeset: changeset)
  end

  def create(conn, %{"board_id" => board_id, "list_id" => list_id, "card" => card_params}) do
    board = Boards.get_board!(board_id)
    list = Lists.get_list!(list_id)

    case Cards.create_card(card_params) do
      {:ok, card} ->
        conn
        |> put_flash(:info, "Card created successfully.")
        |> redirect(to: Routes.board_list_card_path(conn, :show, board, list, card))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", board: board, list: list, changeset: changeset)
    end
  end

  def show(conn, %{"board_id" => board_id, "list_id" => list_id, "id" => id}) do
    board = Boards.get_board!(board_id)
    list = Lists.get_list!(list_id)

    card = Cards.get_card!(id)
    render(conn, "show.html", board: board, list: list, card: card)
  end

  def edit(conn, %{"board_id" => board_id, "list_id" => list_id, "id" => id}) do
    board = Boards.get_board!(board_id)
    list = Lists.get_list!(list_id)
    card = Cards.get_card!(id)
    changeset = Cards.change_card(card)
    render(conn, "edit.html", board: board, list: list, card: card, changeset: changeset)
  end

  def update(conn, %{
        "board_id" => board_id,
        "list_id" => list_id,
        "id" => id,
        "card" => card_params
      }) do
    board = Boards.get_board!(board_id)
    list = Lists.get_list!(list_id)
    card = Cards.get_card!(id)

    case Cards.update_card(card, card_params) do
      {:ok, card} ->
        conn
        |> put_flash(:info, "Card updated successfully.")
        |> redirect(to: Routes.board_list_card_path(conn, :show, board, list, card))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", board: board, list: list, card: card, changeset: changeset)
    end
  end

  def delete(conn, %{"board_id" => board_id, "list_id" => list_id, "id" => id}) do
    board = Boards.get_board!(board_id)
    list = Lists.get_list!(list_id)
    card = Cards.get_card!(id)
    {:ok, _card} = Cards.delete_card(card)

    conn
    |> put_flash(:info, "Card deleted successfully.")
    |> redirect(to: Routes.board_list_card_path(conn, :index, board, list))
  end
end
