defmodule BookmarkerWeb.FolderController do
  use BookmarkerWeb, :controller

  alias Bookmarker.Bookmarks
  alias Bookmarker.Bookmarks.Folder

  def index(conn, _params) do
    folders = Bookmarks.list_folders()
    render(conn, :index, folders: folders)
  end

  def new(conn, _params) do
    changeset = Bookmarks.change_folder(%Folder{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"folder" => folder_params}) do
    case Bookmarks.create_folder(folder_params) do
      {:ok, folder} ->
        conn
        |> put_flash(:info, "Folder created successfully.")
        |> redirect(to: ~p"/folders/#{folder}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    folder = Bookmarks.get_folder!(id)
    children = Bookmarks.list_folder_children(id)
    render(conn, :show, folder: folder, children: children)
  end

  def edit(conn, %{"id" => id}) do
    folder = Bookmarks.get_folder!(id)
    changeset = Bookmarks.change_folder(folder)
    render(conn, :edit, folder: folder, changeset: changeset)
  end

  def update(conn, %{"id" => id, "folder" => folder_params}) do
    folder = Bookmarks.get_folder!(id)

    case Bookmarks.update_folder(folder, folder_params) do
      {:ok, folder} ->
        conn
        |> put_flash(:info, "Folder updated successfully.")
        |> redirect(to: ~p"/folders/#{folder}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, folder: folder, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    folder = Bookmarks.get_folder!(id)
    {:ok, _folder} = Bookmarks.delete_folder(folder)

    conn
    |> put_flash(:info, "Folder deleted successfully.")
    |> redirect(to: ~p"/folders")
  end
end
