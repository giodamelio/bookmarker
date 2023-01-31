defmodule Bookmarker.Bookmarks do
  @moduledoc """
  The Bookmarks context.
  """

  alias Bookmarker.Bookmarks.Folder
  alias RedisGraph.{Node, Edge, Graph, QueryResult}

  @doc """
  Returns the list of folders.

  ## Examples

      iex> list_folders()
      [%Folder{}, ...]

  """
  def list_folders do
    []
  end

  @doc """
  Returns the list of children this folder has.

  ## Examples

      iex> list_folder_children(123)
      [%Folder{}, ...]
  """
  def list_folder_children(id) do
    []
  end

  @doc """
  Gets a single folder.

  Raises `Ecto.NoResultsError` if the Folder does not exist.

  ## Examples

      iex> get_folder!(123)
      %Folder{}

      iex> get_folder!(456)
      ** (Ecto.NoResultsError)

  """
  def get_folder!(id) do
    %Folder{}
  end

  @doc """
  Creates a folder.

  ## Examples

      iex> create_folder(%{field: value})
      {:ok, %Folder{}}

      iex> create_folder(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_folder(folder \\ %{}) do
    folder = struct(%Folder{}, folder)

    {:ok, folder}
  end

  @doc """
  Updates a folder.

  ## Examples

      iex> update_folder(folder, %{field: new_value})
      {:ok, %Folder{}}

      iex> update_folder(folder, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  # def update_folder(%Folder{} = folder, attrs) do
  def update_folder(folder, attrs) do
    # folder
    # |> Folder.changeset(attrs)
    # |> Repo.update()
  end

  @doc """
  Deletes a folder.

  ## Examples

      iex> delete_folder(folder)
      {:ok, %Folder{}}

      iex> delete_folder(folder)
      {:error, %Ecto.Changeset{}}

  """
  # def delete_folder(%Folder{} = folder) do
  def delete_folder(folder) do
    # folder
    # |> Ecto.Changeset.change()
    # |> Ecto.Changeset.no_assoc_constraint(:folders)
    # |> Repo.delete()
  end

  def change_folder(folder, attrs \\ %{}) do
    %{}
  end
end
