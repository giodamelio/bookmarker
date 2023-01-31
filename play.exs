defmodule Play do
  def gen() do
    Graph.new()
    # Add some vertices
    |> Graph.add_vertex(1, :folder)
    |> Graph.add_vertex(2, :bookmark)
    |> Graph.add_vertex(3, :bookmark)
    |> Graph.add_vertex(4, :folder)
    |> Graph.add_vertex(5, :bookmark)
    |> Graph.add_vertex(6, :bookmark)

    # Add the edges for top level
    |> Graph.add_edge(1, 2, label: :parent)
    |> Graph.add_edge(1, 3, label: :parent)
    |> Graph.add_edge(1, 4, label: :parent)

    # Add the order for top level
    |> Graph.add_edge(2, 3, label: :before)
    |> Graph.add_edge(3, 4, label: :before)

    # Add subfolder
    |> Graph.add_edge(4, 5, label: :parent)
    |> Graph.add_edge(4, 6, label: :parent)

    # Add the order for subfolder
    |> Graph.add_edge(5, 6, label: :before)
  end

  def url(g) do
    {:ok, gt} = Graph.Serializers.DOT.serialize(g)

    "https://dreampuf.github.io/GraphvizOnline/##{URI.encode(gt)}"
  end
end
