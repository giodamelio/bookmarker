defmodule Bookmarker.BookmarksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Bookmarker.Bookmarks` context.
  """

  @doc """
  Generate a folder.
  """
  def folder_fixture(attrs \\ %{}) do
    {:ok, folder} =
      attrs
      |> Enum.into(%{
        index: 42,
        title: "some title"
      })
      |> Bookmarker.Bookmarks.create_folder()

    folder
  end
end
