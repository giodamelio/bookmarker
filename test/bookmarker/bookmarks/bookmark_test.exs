defmodule Bookmarker.Bookmarks.BookmarkTest do
  use Bookmarker.RedisCase

  alias Bookmarker.Bookmarks
  alias Bookmarker.Bookmarks.Bookmark

  describe "create_bookmark/1" do
    test "successfully create a bookmark" do
      {:ok, node} = Bookmarks.create_bookmark(bookmark_fixture())

      assert is_integer(node.id)
      assert node.labels == ["Bookmark"]

      assert node.properties == %{
               id: node.properties.id,
               title: "Test",
               url: "https://google.com"
             }
    end
  end

  describe "get_bookmarks/0" do
    test "get a few bookmarks" do
      {:ok, _node} = Bookmarks.create_bookmark(bookmark_fixture())
      {:ok, _node} = Bookmarks.create_bookmark(bookmark_fixture())

      {:ok, bookmarks} = Bookmarks.get_bookmarks()
      assert bookmarks == []
    end
  end

  describe "get_bookmark_by_id/1" do
    test "get a bookmark" do
      {:ok, created_node} = Bookmarks.create_bookmark(bookmark_fixture())

      {:ok, fetched_node} = Bookmarks.get_bookmark_by_id(created_node.properties.id)
      assert is_integer(fetched_node.id)
      assert fetched_node.labels == ["Bookmark"]

      assert fetched_node.properties == %{
               id: fetched_node.properties.id,
               title: "Test",
               url: "https://google.com"
             }
    end

    test "id without a bookmark" do
      {:ok, fetched_node} = Bookmarks.get_bookmark_by_id("not an id")
      assert fetched_node == nil
    end
  end

  defp bookmark_fixture(attrs \\ %{}) do
    Bookmark.new(Map.merge(%{title: "Test", url: "https://google.com"}, attrs))
  end
end
