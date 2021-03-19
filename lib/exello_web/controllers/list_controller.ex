defmodule ExelloWeb.ListController do
  use ExelloWeb, :controller

  alias Exello.{Boards, Lists}
  alias Exello.Lists.List

  def index(conn, %{"board_id" => board_id} = _params) do
    board = Boards.get_board!(board_id)
    lists = Lists.list_lists()
    render(conn, "index.html", board: board, lists: lists)
  end

  def new(conn, %{"board_id" => board_id} = _params) do
    board = Boards.get_board!(board_id)
    changeset = Lists.change_list(%List{})
    render(conn, "new.html", board: board, changeset: changeset)
  end

  def create(conn, %{"board_id" => board_id, "list" => list_params}) do
    board = Boards.get_board!(board_id)

    case Lists.create_list(list_params) do
      {:ok, list} ->
        conn
        |> put_flash(:info, "List created successfully.")
        |> redirect(to: Routes.board_list_path(conn, :show, board, list))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", board: board, changeset: changeset)
    end
  end

  def show(conn, %{"board_id" => board_id, "id" => id}) do
    board = Boards.get_board!(board_id)
    list = Lists.get_list!(id)
    render(conn, "show.html", board: board, list: list)
  end

  def edit(conn, %{"board_id" => board_id, "id" => id}) do
    board = Boards.get_board!(board_id)
    list = Lists.get_list!(id)
    changeset = Lists.change_list(list)
    render(conn, "edit.html", board: board, list: list, changeset: changeset)
  end

  def update(conn, %{"board_id" => board_id, "id" => id, "list" => list_params}) do
    board = Boards.get_board!(board_id)
    list = Lists.get_list!(id)

    case Lists.update_list(list, list_params) do
      {:ok, list} ->
        conn
        |> put_flash(:info, "List updated successfully.")
        |> redirect(to: Routes.board_list_path(conn, :show, board, list))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", board: board, list: list, changeset: changeset)
    end
  end

  def delete(conn, %{"board_id" => board_id, "id" => id}) do
    board = Boards.get_board!(board_id)
    list = Lists.get_list!(id)
    {:ok, _list} = Lists.delete_list(list)

    conn
    |> put_flash(:info, "List deleted successfully.")
    |> redirect(to: Routes.board_list_path(conn, :index, board))
  end
end
