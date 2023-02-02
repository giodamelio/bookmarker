defmodule BookmarkerWeb.BookmarkController do
  use BookmarkerWeb, :controller

  alias Bookmarker.Bookmarks
  alias Bookmarker.Bookmarks.Bookmark

  def index(conn, _params) do
    bookmarks = Bookmarks.list_bookmarks()
    render(conn, :index, bookmarks: bookmarks)
  end

  def new(conn, _params) do
    changeset = Bookmarks.change_bookmark(%Bookmark{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"bookmark" => bookmark_params}) do
    case Bookmarks.create_bookmark(bookmark_params) do
      {:ok, bookmark} ->
        conn
        |> put_flash(:info, "Bookmark created successfully.")
        |> redirect(to: ~p"/bookmarks/#{bookmark}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    bookmark = Bookmarks.get_bookmark!(id)
    render(conn, :show, bookmark: bookmark)
  end

  def edit(conn, %{"id" => id}) do
    bookmark = Bookmarks.get_bookmark!(id)
    changeset = Bookmarks.change_bookmark(bookmark)
    render(conn, :edit, bookmark: bookmark, changeset: changeset)
  end

  def update(conn, %{"id" => id, "bookmark" => bookmark_params}) do
    bookmark = Bookmarks.get_bookmark!(id)

    case Bookmarks.update_bookmark(bookmark, bookmark_params) do
      {:ok, bookmark} ->
        conn
        |> put_flash(:info, "Bookmark updated successfully.")
        |> redirect(to: ~p"/bookmarks/#{bookmark}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, bookmark: bookmark, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    bookmark = Bookmarks.get_bookmark!(id)
    {:ok, _bookmark} = Bookmarks.delete_bookmark(bookmark)

    conn
    |> put_flash(:info, "Bookmark deleted successfully.")
    |> redirect(to: ~p"/bookmarks")
  end
end
