defmodule Bookmarker.Repo.Migrations.CreateBookmarks do
  use Ecto.Migration

  def change do
    create table(:bookmarks) do
      add :title, :string
      add :url, :string

      timestamps()
    end
  end
end
