defmodule Exello.Repo.Migrations.CreateLists do
  use Ecto.Migration

  def change do
    create table(:lists, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :color, :string
      add :board_id, references(:boards, on_delete: :delete_all, type: :binary_id)
      add :rank, :integer

      timestamps()
    end

    create index(:lists, [:board_id])
  end
end
