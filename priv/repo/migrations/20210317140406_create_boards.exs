defmodule Exello.Repo.Migrations.CreateBoards do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS pgcrypto"

    create table(:boards, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :slug, :string

      timestamps()
    end

    create unique_index(:boards, [:slug])
  end
end
