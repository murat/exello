defmodule ExelloWeb.Api.ListController do
  use ExelloWeb, :controller

  alias Exello.Lists

  def create(conn, %{"board_id" => board_id, "list" => list_params}) do
    case Lists.create_list(board_id, list_params) do
      {:ok, list} ->
        render(conn, "show.json", list: list)

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "error.json", changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "list" => list_params}) do
    list = Lists.get_list!(id)

    case Lists.update_list(list, list_params) do
      {:ok, list} ->
        render(conn, "show.json", list: list)

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "errors.json", changeset: changeset)
    end
  end
end
