defmodule Bookmarker.Worker.Bookmarks do
  use GenServer

  ## Client API
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  # Load the graph from the DB
  def load(server) do
    GenServer.call(server, :load)
  end

  ## Server callbacks

  @impl true
  def init(:ok) do
    graph = Graph.new()

    {:ok, {graph}}
  end

  @impl true
  def handle_call(:load, _from, {graph}) do
    edges = Bookmarker.Bookmarks.list_edges()

    graph =
      for edge <- edges, reduce: graph do
        g -> Graph.add_edge(g, edge.v1, edge.v2, label: edge.label)
      end

    {:reply, {:ok, length(edges)}, {graph}}
  end
end
