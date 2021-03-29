defmodule ExelloWeb.BoardController do
  use ExelloWeb, :controller

  import Ecto.Query, only: [from: 2]
  alias Exello.{Repo, Boards, Boards.Board, Lists.List, Cards.Card}

  def index(conn, _params) do
    boards = Boards.list_boards()
    render(conn, "index.html", boards: boards)
  end

  def new(conn, _params) do
    changeset = Boards.change_board(%Board{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"board" => board_params}) do
    case Boards.create_board(board_params) do
      {:ok, board} ->
        conn
        |> put_flash(:info, "Board created successfully.")
        |> redirect(to: Routes.board_path(conn, :show, board))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    lists_query = from l in List, order_by: l.rank
    cards_query = from c in Card, order_by: c.rank

    board =
      from(b in Board,
        where: b.slug == ^id,
        preload: [lists: ^lists_query, cards: ^cards_query]
      )
      |> Repo.one()

    render(conn, "show.html", board: board)
  end

  def edit(conn, %{"id" => id}) do
    board = Boards.get_board!(id)
    changeset = Boards.change_board(board)
    render(conn, "edit.html", board: board, changeset: changeset)
  end

  def update(conn, %{"id" => id, "board" => board_params}) do
    board = Boards.get_board!(id)

    case Boards.update_board(board, board_params) do
      {:ok, board} ->
        conn
        |> put_flash(:info, "Board updated successfully.")
        |> redirect(to: Routes.board_path(conn, :show, board))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", board: board, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    board = Boards.get_board!(id)
    {:ok, _board} = Boards.delete_board(board)

    conn
    |> put_flash(:info, "Board deleted successfully.")
    |> redirect(to: Routes.board_path(conn, :index))
  end
end
