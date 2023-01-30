defmodule Bookmarker.Repo.Migrations.CreateFolders do
  use Ecto.Migration

  def change do
    create table(:folders) do
      add :title, :string
      add :index, :integer
      add :parent_id, references(:folders, on_delete: :nothing)

      timestamps()
    end

    create index(:folders, [:parent_id])
  end
end
