defmodule Bookmarker.BookmarksTest do
  use Bookmarker.DataCase

  alias Bookmarker.Bookmarks

  describe "folders" do
    alias Bookmarker.Bookmarks.Folder

    import Bookmarker.BookmarksFixtures

    @invalid_attrs %{title: nil}

    test "list_folders/0 returns all folders" do
      folder = folder_fixture()
      assert Bookmarks.list_folders() == [folder]
    end

    test "get_folder!/1 returns the folder with given id" do
      folder = folder_fixture()
      assert Bookmarks.get_folder!(folder.id) == folder
    end

    test "create_folder/1 with valid data creates a folder" do
      valid_attrs = %{title: "some title"}

      assert {:ok, %Folder{} = folder} = Bookmarks.create_folder(valid_attrs)
      assert folder.title == "some title"
    end

    test "create_folder/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Bookmarks.create_folder(@invalid_attrs)
    end

    test "update_folder/2 with valid data updates the folder" do
      folder = folder_fixture()
      update_attrs = %{title: "some updated title"}

      assert {:ok, %Folder{} = folder} = Bookmarks.update_folder(folder, update_attrs)
      assert folder.title == "some updated title"
    end

    test "update_folder/2 with invalid data returns error changeset" do
      folder = folder_fixture()
      assert {:error, %Ecto.Changeset{}} = Bookmarks.update_folder(folder, @invalid_attrs)
      assert folder == Bookmarks.get_folder!(folder.id)
    end

    test "delete_folder/1 deletes the folder" do
      folder = folder_fixture()
      assert {:ok, %Folder{}} = Bookmarks.delete_folder(folder)
      assert_raise Ecto.NoResultsError, fn -> Bookmarks.get_folder!(folder.id) end
    end

    test "change_folder/1 returns a folder changeset" do
      folder = folder_fixture()
      assert %Ecto.Changeset{} = Bookmarks.change_folder(folder)
    end
  end

  describe "bookmarks" do
    alias Bookmarker.Bookmarks.Bookmark

    import Bookmarker.BookmarksFixtures

    @invalid_attrs %{title: nil, url: nil}

    test "list_bookmarks/0 returns all bookmarks" do
      bookmark = bookmark_fixture()
      assert Bookmarks.list_bookmarks() == [bookmark]
    end

    test "get_bookmark!/1 returns the bookmark with given id" do
      bookmark = bookmark_fixture()
      assert Bookmarks.get_bookmark!(bookmark.id) == bookmark
    end

    test "create_bookmark/1 with valid data creates a bookmark" do
      valid_attrs = %{title: "some title", url: "some url"}

      assert {:ok, %Bookmark{} = bookmark} = Bookmarks.create_bookmark(valid_attrs)
      assert bookmark.title == "some title"
      assert bookmark.url == "some url"
    end

    test "create_bookmark/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Bookmarks.create_bookmark(@invalid_attrs)
    end

    test "update_bookmark/2 with valid data updates the bookmark" do
      bookmark = bookmark_fixture()
      update_attrs = %{title: "some updated title", url: "some updated url"}

      assert {:ok, %Bookmark{} = bookmark} = Bookmarks.update_bookmark(bookmark, update_attrs)
      assert bookmark.title == "some updated title"
      assert bookmark.url == "some updated url"
    end

    test "update_bookmark/2 with invalid data returns error changeset" do
      bookmark = bookmark_fixture()
      assert {:error, %Ecto.Changeset{}} = Bookmarks.update_bookmark(bookmark, @invalid_attrs)
      assert bookmark == Bookmarks.get_bookmark!(bookmark.id)
    end

    test "delete_bookmark/1 deletes the bookmark" do
      bookmark = bookmark_fixture()
      assert {:ok, %Bookmark{}} = Bookmarks.delete_bookmark(bookmark)
      assert_raise Ecto.NoResultsError, fn -> Bookmarks.get_bookmark!(bookmark.id) end
    end

    test "change_bookmark/1 returns a bookmark changeset" do
      bookmark = bookmark_fixture()
      assert %Ecto.Changeset{} = Bookmarks.change_bookmark(bookmark)
    end
  end

  describe "edges" do
    alias Bookmarker.Bookmarks.Edge

    import Bookmarker.BookmarksFixtures

    @invalid_attrs %{label: nil, v1: nil, v2: nil}

    test "list_edges/0 returns all edges" do
      edge = edge_fixture()
      assert Bookmarks.list_edges() == [edge]
    end

    test "get_edge!/1 returns the edge with given id" do
      edge = edge_fixture()
      assert Bookmarks.get_edge!(edge.id) == edge
    end

    test "create_edge/1 with valid data creates a edge" do
      valid_attrs = %{label: "some label", v1: "some v1", v2: "some v2"}

      assert {:ok, %Edge{} = edge} = Bookmarks.create_edge(valid_attrs)
      assert edge.label == "some label"
      assert edge.v1 == "some v1"
      assert edge.v2 == "some v2"
    end

    test "create_edge/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Bookmarks.create_edge(@invalid_attrs)
    end

    test "update_edge/2 with valid data updates the edge" do
      edge = edge_fixture()
      update_attrs = %{label: "some updated label", v1: "some updated v1", v2: "some updated v2"}

      assert {:ok, %Edge{} = edge} = Bookmarks.update_edge(edge, update_attrs)
      assert edge.label == "some updated label"
      assert edge.v1 == "some updated v1"
      assert edge.v2 == "some updated v2"
    end

    test "update_edge/2 with invalid data returns error changeset" do
      edge = edge_fixture()
      assert {:error, %Ecto.Changeset{}} = Bookmarks.update_edge(edge, @invalid_attrs)
      assert edge == Bookmarks.get_edge!(edge.id)
    end

    test "delete_edge/1 deletes the edge" do
      edge = edge_fixture()
      assert {:ok, %Edge{}} = Bookmarks.delete_edge(edge)
      assert_raise Ecto.NoResultsError, fn -> Bookmarks.get_edge!(edge.id) end
    end

    test "change_edge/1 returns a edge changeset" do
      edge = edge_fixture()
      assert %Ecto.Changeset{} = Bookmarks.change_edge(edge)
    end
  end
end
