defmodule BookmarkerWeb.FolderControllerTest do
  use BookmarkerWeb.ConnCase

  import Bookmarker.BookmarksFixtures

  @create_attrs %{title: "some title"}
  @update_attrs %{title: "some updated title"}
  @invalid_attrs %{title: nil}

  describe "index" do
    test "lists all folders", %{conn: conn} do
      conn = get(conn, ~p"/folders")
      assert html_response(conn, 200) =~ "Listing Folders"
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
    folder = folder_fixture()
    %{folder: folder}
  end
end
