defmodule BookmarkerWeb.BookmarkControllerTest do
  use BookmarkerWeb.ConnCase

  import Bookmarker.BookmarksFixtures

  @create_attrs %{title: "some title", url: "some url"}
  @update_attrs %{title: "some updated title", url: "some updated url"}
  @invalid_attrs %{title: nil, url: nil}

  describe "index" do
    test "lists all bookmarks", %{conn: conn} do
      conn = get(conn, ~p"/bookmarks")
      assert html_response(conn, 200) =~ "Listing Bookmarks"
    end
  end

  describe "new bookmark" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/bookmarks/new")
      assert html_response(conn, 200) =~ "New Bookmark"
    end
  end

  describe "create bookmark" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/bookmarks", bookmark: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/bookmarks/#{id}"

      conn = get(conn, ~p"/bookmarks/#{id}")
      assert html_response(conn, 200) =~ "Bookmark #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/bookmarks", bookmark: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Bookmark"
    end
  end

  describe "edit bookmark" do
    setup [:create_bookmark]

    test "renders form for editing chosen bookmark", %{conn: conn, bookmark: bookmark} do
      conn = get(conn, ~p"/bookmarks/#{bookmark}/edit")
      assert html_response(conn, 200) =~ "Edit Bookmark"
    end
  end

  describe "update bookmark" do
    setup [:create_bookmark]

    test "redirects when data is valid", %{conn: conn, bookmark: bookmark} do
      conn = put(conn, ~p"/bookmarks/#{bookmark}", bookmark: @update_attrs)
      assert redirected_to(conn) == ~p"/bookmarks/#{bookmark}"

      conn = get(conn, ~p"/bookmarks/#{bookmark}")
      assert html_response(conn, 200) =~ "some updated title"
    end

    test "renders errors when data is invalid", %{conn: conn, bookmark: bookmark} do
      conn = put(conn, ~p"/bookmarks/#{bookmark}", bookmark: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Bookmark"
    end
  end

  describe "delete bookmark" do
    setup [:create_bookmark]

    test "deletes chosen bookmark", %{conn: conn, bookmark: bookmark} do
      conn = delete(conn, ~p"/bookmarks/#{bookmark}")
      assert redirected_to(conn) == ~p"/bookmarks"

      assert_error_sent 404, fn ->
        get(conn, ~p"/bookmarks/#{bookmark}")
      end
    end
  end

  defp create_bookmark(_) do
    bookmark = bookmark_fixture()
    %{bookmark: bookmark}
  end
end
