defmodule Bookmarker.Bookmarks.Folder do
  use Ecto.Schema
  import Ecto.Changeset

  schema "folders" do
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(folder, attrs) do
    folder
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end
