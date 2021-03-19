defmodule Exello.Repo.Migrations.CreateCards do
  use Ecto.Migration

  def change do
    create table(:cards) do
      add :title, :string
      add :body, :text
      add :list_id, references(:lists, on_delete: :nothing)

      timestamps()
    end

    create index(:cards, [:list_id])
  end
end
