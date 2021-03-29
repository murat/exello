defmodule ExelloWeb.Api.CardView do
  use ExelloWeb, :view

  def render("error.json", %{changeset: changeset}) do
    %{
      errors: Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
    }
  end

  def render("show.json", %{card: card}) do
    %{data: render_one(card, ExelloWeb.Api.CardView, "card.json")}
  end

  def render("card.json", %{card: card}) do
    %{
      id: card.id,
      title: card.title,
      body: card.body,
      color: card.color,
      card_type: card.card_type,
      inserted_at: card.inserted_at,
      updated_at: card.updated_at
    }
  end

  def render_detail({message, values}) do
    Enum.reduce(values, message, fn {k, v}, acc ->
      String.replace(acc, "%{#{k}}", to_string(v))
    end)
  end

  def render_detail(message) do
    message
  end
end
