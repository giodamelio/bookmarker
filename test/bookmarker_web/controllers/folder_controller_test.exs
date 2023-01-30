defmodule BookmarkerWeb.FolderControllerTest do
  use BookmarkerWeb.ConnCase

  import Bookmarker.BookmarksFixtures

  @create_attrs %{index: 42, title: "some title"}
  @update_attrs %{index: 43, title: "some updated title"}
  @invalid_attrs %{index: nil, title: nil}

  describe "index" do
    test "lists all folders", %{conn: conn} do
      conn = get(conn, ~p"/folders")
      assert html_response(conn, 200) =~ "Listing Folders"
    end
  end

  describe "show folder" do
    setup [:create_folder]

    test "shows all the children folders", %{conn: conn, folder: folder, children: children} do
      conn = get(conn, ~p"/folders/#{folder.id}")
      assert html_response(conn, 200) =~ "This folder has #{length(children)} children"
    end
  end

  describe "new folder" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/folders/new")
      assert html_response(conn, 200) =~ "New Folder"
    end
  end

  describe "create folder" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/folders", folder: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/folders/#{id}"

      conn = get(conn, ~p"/folders/#{id}")
      assert html_response(conn, 200) =~ "Folder #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/folders", folder: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Folder"
    end
  end

  describe "edit folder" do
    setup [:create_folder]

    test "renders form for editing chosen folder", %{conn: conn, folder: folder} do
      conn = get(conn, ~p"/folders/#{folder}/edit")
      assert html_response(conn, 200) =~ "Edit Folder"
    end
  end

  describe "update folder" do
    setup [:create_folder]

    test "redirects when data is valid", %{conn: conn, folder: folder} do
      conn = put(conn, ~p"/folders/#{folder}", folder: @update_attrs)
      assert redirected_to(conn) == ~p"/folders/#{folder}"

      conn = get(conn, ~p"/folders/#{folder}")
      assert html_response(conn, 200) =~ "some updated title"
    end

    test "renders errors when data is invalid", %{conn: conn, folder: folder} do
      conn = put(conn, ~p"/folders/#{folder}", folder: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Folder"
    end
  end

  describe "delete folder" do
    setup [:create_folder]

    test "deletes chosen folder", %{conn: conn, folder: folder} do
      conn = delete(conn, ~p"/folders/#{folder}")
      assert redirected_to(conn) == ~p"/folders"

      assert_error_sent 404, fn ->
        get(conn, ~p"/folders/#{folder}")
      end
    end
  end

  defp create_folder(_) do
    parent_folder = folder_fixture()
    child_folder_1 = folder_fixture(parent_id: parent_folder.id)
    child_folder_2 = folder_fixture(parent_id: parent_folder.id)
    _not_a_child = folder_fixture()
    %{folder: parent_folder, children: [child_folder_1, child_folder_2]}
  end
end
