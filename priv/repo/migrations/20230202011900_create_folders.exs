defmodule Bookmarker.Repo.Migrations.CreateFolders do
  use Ecto.Migration

  def change do
    create table(:folders) do
      add :title, :string

      timestamps()
    end
  end
end
