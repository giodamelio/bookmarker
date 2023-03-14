defmodule Bookmarker.RedisgraphTest do
  use Bookmarker.RedisCase

  alias Bookmarker.RedisGraph

  @db "main"

  describe "graph_command/2" do
    test "simple node creation", %{redis_conn: conn} do
      {:ok, [result]} =
        RedisGraph.graph_command(conn, "CREATE (p:Person {name:'Kirsten'}) RETURN p")

      assert result["p"].properties["name"] == "Kirsten"
    end
  end

  describe "decode/2" do
    test "decode simple nodes and relationship", %{redis_conn: conn} do
      {:ok, _results} =
        Redix.command(conn, [
          "GRAPH.QUERY",
          @db,
          ~s|CREATE
          (g:Person {name:'Gio'}),
          (s:Person {name:'Sophie'}),
          (g)-[r1:Sister]->(s),
          (s)-[r2:Brother]->(g)
          RETURN g, s, r1, r2|,
          "--compact"
        ])

      {:ok, results} =
        Redix.command(conn, [
          "GRAPH.QUERY",
          @db,
          "MATCH (p1:Person)-[r]->(p2:Person) RETURN p1, r, p2 ORDER BY p1.name",
          "--compact"
        ])

      {:ok, [val1, val2]} = RedisGraph.decode(conn, results)
      assert val1["p1"].properties["name"] == "Gio"
      assert val1["p2"].properties["name"] == "Sophie"
      assert val2["p1"].properties["name"] == "Sophie"
      assert val2["p2"].properties["name"] == "Gio"
    end
  end

  describe "decode_value/2" do
    test "string", %{redis_conn: conn} do
      assert RedisGraph.decode_value(conn, [2, "testing"]) == "testing"
    end

    test "integer", %{redis_conn: conn} do
      assert RedisGraph.decode_value(conn, [3, "100"]) == 100
    end

    test "edge", %{redis_conn: conn} do
      {:ok, [_headers, [[result]], _stats]} =
        Redix.command(conn, [
          "GRAPH.QUERY",
          @db,
          "CREATE (g:Person {name:'Gio'})-[r:Sibling {test: 'HAHA'}]->(s:Person {name:'Sophie'}) RETURN r",
          "--compact"
        ])

      val = RedisGraph.decode_value(conn, result)
      assert val.properties == %{"test" => "HAHA"}
      assert val.type == "Sibling"
    end

    test "node", %{redis_conn: conn} do
      {:ok, [_headers, [[result]], _stats]} =
        Redix.command(conn, [
          "GRAPH.QUERY",
          @db,
          "CREATE (p:Person {name:'Gio'}) RETURN p",
          "--compact"
        ])

      val = RedisGraph.decode_value(conn, result)
      assert val.labels == ["Person"]
      assert val.properties == %{"name" => "Gio"}
    end
  end
end
