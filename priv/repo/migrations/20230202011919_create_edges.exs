defmodule Bookmarker.Repo.Migrations.CreateEdges do
  use Ecto.Migration

  def change do
    create table(:edges) do
      add :v1, :string
      add :v2, :string
      add :label, :string

      timestamps()
    end
  end
end
