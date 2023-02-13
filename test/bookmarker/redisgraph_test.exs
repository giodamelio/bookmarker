defmodule Bookmarker.RedisgraphTest do
  use Bookmarker.RedisCase

  alias Bookmarker.RedisGraph

  describe "decode/1" do
    test "basic decode", %{redis_conn: conn} do
      {:ok, result} =
        RedisGraph.graph_command(conn, "MATCH (a)-[e]->(b) RETURN a, e, b.name as fruit_name")

      assert result == []
    end

    test "basic write", %{redis_conn: conn} do
      {:ok, result} = RedisGraph.graph_command(conn, "CREATE (b:Bookmark {}) RETURN b")

      assert result == [%{"b" => %{id: 0, labels: ["Bookmark"], properties: %{}}}]
    end

    test "basic read", %{redis_conn: conn} do
      {:ok, result} = RedisGraph.graph_command(conn, "MATCH (b:Bookmark) RETURN b")

      assert result == []
    end
  end
end
