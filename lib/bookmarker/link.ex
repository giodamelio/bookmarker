defmodule Bookmarker.Link do
  use Ecto.Schema

  import Ecto.Changeset
  import Bookmarker.Cypher

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
    with {:ok, link} <-
           %Link{}
           |> changeset(attrs)
           |> apply_action(:insert),
         link = link |> Map.delete(:id) |> Map.delete(:__meta__),
         query =
           cypher(
             create: {:l, [:Link], link},
             return: :l
           ),
         {:ok, redis_result} <- RedisGraph.graph_command(:main, @db, query) do
      redis_result
      |> get_in([Access.at(0), "l", :id])
      |> then(&Map.put(link, :id, &1))
    end
  end
end
