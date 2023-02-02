defmodule Bookmarker.Repo.Migrations.CreateBookmarks do
  use Ecto.Migration

  def change do
    create table(:bookmarks) do
      add :title, :string, null: false
      add :url, :string, null: false

      timestamps()
    end
  end
end
