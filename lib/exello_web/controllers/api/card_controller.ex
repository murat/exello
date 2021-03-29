defmodule ExelloWeb.Api.CardController do
  use ExelloWeb, :controller

  alias Exello.Cards

  def create(conn, %{"card" => card_params}) do
    case Cards.create_card(card_params) do
      {:ok, card} ->
        conn
        |> render("show.json", card: card)

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> render("error.json", changeset: changeset)
    end
  end

  def update(conn, %{
        "id" => id,
        "card" => card_params
      }) do
    card = Cards.get_card!(id)

    case Cards.update_card(card, card_params) do
      {:ok, card} ->
        render(conn, "show.json", card: card)

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "error.json", changeset: changeset)
    end
  end
end
