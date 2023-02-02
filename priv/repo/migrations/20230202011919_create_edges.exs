defmodule Bookmarker.Repo.Migrations.CreateEdges do
  use Ecto.Migration

  def change do
    create table(:edges) do
      add :v1, :string, null: false
      add :v2, :string, null: false
      add :label, :string, null: false

      timestamps()
    end
  end
end
