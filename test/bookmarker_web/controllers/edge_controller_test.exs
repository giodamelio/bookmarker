defmodule BookmarkerWeb.EdgeControllerTest do
  use BookmarkerWeb.ConnCase

  import Bookmarker.BookmarksFixtures

  @create_attrs %{label: "some label", v1: "some v1", v2: "some v2"}
  @update_attrs %{label: "some updated label", v1: "some updated v1", v2: "some updated v2"}
  @invalid_attrs %{label: nil, v1: nil, v2: nil}

  describe "index" do
    test "lists all edges", %{conn: conn} do
      conn = get(conn, ~p"/edges")
      assert html_response(conn, 200) =~ "Listing Edges"
    end
  end

  describe "new edge" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/edges/new")
      assert html_response(conn, 200) =~ "New Edge"
    end
  end

  describe "create edge" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/edges", edge: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/edges/#{id}"

      conn = get(conn, ~p"/edges/#{id}")
      assert html_response(conn, 200) =~ "Edge #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/edges", edge: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Edge"
    end
  end

  describe "edit edge" do
    setup [:create_edge]

    test "renders form for editing chosen edge", %{conn: conn, edge: edge} do
      conn = get(conn, ~p"/edges/#{edge}/edit")
      assert html_response(conn, 200) =~ "Edit Edge"
    end
  end

  describe "update edge" do
    setup [:create_edge]

    test "redirects when data is valid", %{conn: conn, edge: edge} do
      conn = put(conn, ~p"/edges/#{edge}", edge: @update_attrs)
      assert redirected_to(conn) == ~p"/edges/#{edge}"

      conn = get(conn, ~p"/edges/#{edge}")
      assert html_response(conn, 200) =~ "some updated label"
    end

    test "renders errors when data is invalid", %{conn: conn, edge: edge} do
      conn = put(conn, ~p"/edges/#{edge}", edge: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Edge"
    end
  end

  describe "delete edge" do
    setup [:create_edge]

    test "deletes chosen edge", %{conn: conn, edge: edge} do
      conn = delete(conn, ~p"/edges/#{edge}")
      assert redirected_to(conn) == ~p"/edges"

      assert_error_sent 404, fn ->
        get(conn, ~p"/edges/#{edge}")
      end
    end
  end

  defp create_edge(_) do
    edge = edge_fixture()
    %{edge: edge}
  end
end
