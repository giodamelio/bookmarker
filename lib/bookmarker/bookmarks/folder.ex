defmodule Bookmarker.Bookmarks.Folder do
  use Ecto.Schema
  import Ecto.Changeset

  schema "folders" do
    field :index, :integer
    field :title, :string
    field :parent_id, :id

    timestamps()
  end

  @doc false
  def changeset(folder, attrs) do
    folder
    |> cast(attrs, [:title, :index, :parent_id])
    |> validate_required([:title, :index])
  end
end
