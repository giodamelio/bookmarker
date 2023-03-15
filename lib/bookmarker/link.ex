defmodule Bookmarker.Link do
  use Ecto.Schema

  import Ecto.Changeset
  alias Bookmarker.RedisGraph
  alias Bookmarker.Link

  @db "main"

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

  # Create a Link
  def create(attrs) do
    with {:ok, link} =
           %Link{}
           |> changeset(attrs)
           |> apply_action(:insert),
         props = RedisGraph.to_cypher(link),
         {:ok, redis_result} =
           RedisGraph.graph_command(:main, @db, "CREATE (l:Link #{props}) RETURN l") do
      redis_result
      |> get_in([Access.at(0), "l", :id])
      |> then(&Map.put(link, :id, &1))
    end
  end
end
