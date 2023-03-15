defmodule Bookmarker.Link do
  use Ecto.Schema
  import Ecto.Changeset

  schema "Link" do
    field(:title, :string)
    field(:url, :string)
  end

  @doc false
  def changeset(link, attrs) do
    link
    |> cast(attrs, [:title, :url])
    |> validate_required([:title, :url])
  end
end
