defmodule Bookmarker.Bookmarks.Bookmark do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bookmarks" do
    field :title, :string
    field :url, :string

    timestamps()
  end

  @doc false
  def changeset(bookmark, attrs) do
    bookmark
    |> cast(attrs, [:title, :url])
    |> validate_required([:title, :url])
  end
end
