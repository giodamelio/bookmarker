defmodule BookmarkerWeb.EdgeController do
  use BookmarkerWeb, :controller

  alias Bookmarker.Bookmarks
  alias Bookmarker.Bookmarks.Edge

  def index(conn, _params) do
    edges = Bookmarks.list_edges()
    render(conn, :index, edges: edges)
  end

  def new(conn, _params) do
    changeset = Bookmarks.change_edge(%Edge{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"edge" => edge_params}) do
    case Bookmarks.create_edge(edge_params) do
      {:ok, edge} ->
        conn
        |> put_flash(:info, "Edge created successfully.")
        |> redirect(to: ~p"/edges/#{edge}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    edge = Bookmarks.get_edge!(id)
    render(conn, :show, edge: edge)
  end

  def edit(conn, %{"id" => id}) do
    edge = Bookmarks.get_edge!(id)
    changeset = Bookmarks.change_edge(edge)
    render(conn, :edit, edge: edge, changeset: changeset)
  end

  def update(conn, %{"id" => id, "edge" => edge_params}) do
    edge = Bookmarks.get_edge!(id)

    case Bookmarks.update_edge(edge, edge_params) do
      {:ok, edge} ->
        conn
        |> put_flash(:info, "Edge updated successfully.")
        |> redirect(to: ~p"/edges/#{edge}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, edge: edge, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    edge = Bookmarks.get_edge!(id)
    {:ok, _edge} = Bookmarks.delete_edge(edge)

    conn
    |> put_flash(:info, "Edge deleted successfully.")
    |> redirect(to: ~p"/edges")
  end
end
