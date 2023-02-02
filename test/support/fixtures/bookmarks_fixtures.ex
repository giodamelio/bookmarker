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
        title: "some title"
      })
      |> Bookmarker.Bookmarks.create_folder()

    folder
  end

  @doc """
  Generate a bookmark.
  """
  def bookmark_fixture(attrs \\ %{}) do
    {:ok, bookmark} =
      attrs
      |> Enum.into(%{
        title: "some title",
        url: "some url"
      })
      |> Bookmarker.Bookmarks.create_bookmark()

    bookmark
  end

  @doc """
  Generate a edge.
  """
  def edge_fixture(attrs \\ %{}) do
    {:ok, edge} =
      attrs
      |> Enum.into(%{
        label: "some label",
        v1: "some v1",
        v2: "some v2"
      })
      |> Bookmarker.Bookmarks.create_edge()

    edge
  end
end
