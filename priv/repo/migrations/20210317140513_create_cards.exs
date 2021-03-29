defmodule Exello.Repo.Migrations.CreateCards do
  use Ecto.Migration

  def change do
    create table(:cards, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :body, :text
      add :color, :string
      add :card_type, :string
      add :list_id, references(:lists, on_delete: :delete_all, type: :binary_id)
      add :rank, :integer

      timestamps()
    end

    create index(:cards, [:list_id])
  end
end
