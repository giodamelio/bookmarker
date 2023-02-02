defmodule Bookmarker.Bookmarks.Edge do
  use Ecto.Schema
  import Ecto.Changeset

  schema "edges" do
    field :label, :string
    field :v1, :string
    field :v2, :string

    timestamps()
  end

  @doc false
  def changeset(edge, attrs) do
    edge
    |> cast(attrs, [:v1, :v2, :label])
    |> validate_required([:v1, :v2, :label])
  end
end
