defmodule ExelloWeb.Api.ListView do
  use ExelloWeb, :view

  def render("errors.json", %{changeset: changeset}) do
    %{
      errors: Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
    }
  end

  def render("show.json", %{list: list}) do
    %{data: render_one(list, ExelloWeb.Api.ListView, "list.json")}
  end

  def render("list.json", %{list: list}) do
    %{
      id: list.id,
      name: list.name,
      color: list.color,
      inserted_at: list.inserted_at,
      updated_at: list.updated_at
    }
  end
end
