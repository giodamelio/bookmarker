defmodule Bookmarker.BookmarksTest do
  use Bookmarker.DataCase

  alias Bookmarker.Bookmarks

  describe "folders" do
    alias Bookmarker.Bookmarks.Folder

    import Bookmarker.BookmarksFixtures

    @invalid_attrs %{index: nil, title: nil}

    test "list_folders/0 returns all folders" do
      folder = folder_fixture()
      assert Bookmarks.list_folders() == [folder]
    end

    test "list_folder_children/1 returns all child folders" do
      parent_folder = folder_fixture()
      child_folder_1 = folder_fixture(parent_id: parent_folder.id)
      child_folder_2 = folder_fixture(parent_id: parent_folder.id)
      _not_a_child = folder_fixture()

      assert Bookmarks.list_folder_children(parent_folder.id) == [child_folder_1, child_folder_2]
    end

    test "get_folder!/1 returns the folder with given id" do
      folder = folder_fixture()
      assert Bookmarks.get_folder!(folder.id) == folder
    end

    test "create_folder/1 with valid data creates a folder" do
      valid_attrs = %{index: 42, title: "some title"}

      assert {:ok, %Folder{} = folder} = Bookmarks.create_folder(valid_attrs)
      assert folder.index == 42
      assert folder.title == "some title"
    end

    test "create_folder/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Bookmarks.create_folder(@invalid_attrs)
    end

    test "update_folder/2 with valid data updates the folder" do
      folder = folder_fixture()
      update_attrs = %{index: 43, title: "some updated title"}

      assert {:ok, %Folder{} = folder} = Bookmarks.update_folder(folder, update_attrs)
      assert folder.index == 43
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
end
