defmodule Bookmarker.CypherTest do
  use ExUnit.Case

  import Bookmarker.Cypher

  describe "create" do
    test "create a node" do
      query = cypher(create: :l)

      assert query == "CREATE (l)"
    end

    test "create a node with a label" do
      query = cypher(create: {:l, [:Link]})

      assert query == "CREATE (l:Link)"
    end

    test "create a node with multiple labels" do
      query = cypher(create: {:l, [:Link, :Other]})

      assert query == "CREATE (l:Link:Other)"
    end

    test "create a node with a label and some properties" do
      query = cypher(create: {:l, [:Link], %{foo: "bar"}})

      assert query == ~s|CREATE (l:Link {foo: "bar"})|
    end

    test "create multiple nodes" do
      query =
        cypher(
          create: [
            {:l1, [:Link], %{foo: "bar"}},
            {:l2, [:Link], %{foo: "bar"}}
          ]
        )

      assert query == ~s|CREATE (l1:Link {foo: "bar"}), (l2:Link {foo: "bar"})|
    end

    test "create a relationship" do
      query =
        cypher(
          create: {:l1, "-", {:b, :Before}, "->", :l2},
          return: [:l1, :b, :l2]
        )

      assert query == ~s|CREATE (l1)-[b:Before]->(l2) RETURN l1, b, l2|

      query =
        cypher(
          create: {:l1, "<-", {:b, :After}, "-", :l2},
          return: [:l1, :b, :l2]
        )

      assert query == ~s|CREATE (l1)<-[b:After]-(l2) RETURN l1, b, l2|
    end

    test "create a relationship with properties" do
      query =
        cypher(
          create: {:l1, "-", {:b, :Before, %{foo: "bar"}}, "->", :l2},
          return: [:l1, :b, :l2]
        )

      assert query == ~s|CREATE (l1)-[b:Before {foo: "bar"}]->(l2) RETURN l1, b, l2|

      query =
        cypher(
          create: {:l1, "<-", {:b, :After, %{foo: "bar"}}, "-", :l2},
          return: [:l1, :b, :l2]
        )

      assert query == ~s|CREATE (l1)<-[b:After {foo: "bar"}]-(l2) RETURN l1, b, l2|
    end
  end

  describe "match" do
    test "match a node" do
      query = cypher(match: :l)

      assert query == "MATCH (l)"
    end

    test "match a node with a label" do
      query = cypher(match: {:l, [:Link]})

      assert query == "MATCH (l:Link)"
    end

    test "match a node with multiple labels" do
      query = cypher(match: {:l, [:Link, :Other]})

      assert query == "MATCH (l:Link:Other)"
    end

    test "match a node with a label and some properties" do
      query = cypher(match: {:l, [:Link], %{foo: "bar"}})

      assert query == ~s|MATCH (l:Link {foo: "bar"})|
    end
  end

  describe "where" do
    test "simple string based where" do
      query =
        cypher(
          match: {:l, [:Link]},
          where: ~s|l.title = "Google"|
        )

      assert query == ~s|MATCH (l:Link) WHERE l.title = "Google"|
    end
  end

  describe "delete" do
    test "simple delete" do
      query =
        cypher(
          match: {:l, [:Link]},
          delete: :l
        )

      assert query == ~s|MATCH (l:Link) DELETE l|
    end

    test "string based delete" do
      query =
        cypher(
          match: {:l, [:Link]},
          delete: "l"
        )

      assert query == ~s|MATCH (l:Link) DELETE l|
    end
  end

  describe "detach delete" do
    test "simple detach delete" do
      query =
        cypher(
          match: {:l, [:Link]},
          detach_delete: :l
        )

      assert query == ~s|MATCH (l:Link) DETACH DELETE l|
    end

    test "string based detach delete" do
      query =
        cypher(
          match: {:l, [:Link]},
          detach_delete: "l"
        )

      assert query == ~s|MATCH (l:Link) DETACH DELETE l|
    end
  end

  describe "set" do
    test "basic set" do
      query =
        cypher(
          match: {:l, [:Link]},
          set: {"l.title", "Google"},
          return: :l
        )

      assert query == ~s|MATCH (l:Link) SET l.title = "Google" RETURN l|
    end

    test "string set" do
      query =
        cypher(
          match: {:l, [:Link]},
          set: ~s|l.title = "Google"|,
          return: :l
        )

      assert query == ~s|MATCH (l:Link) SET l.title = "Google" RETURN l|
    end
  end

  describe "return" do
    test "return a single binding" do
      query =
        cypher(
          create: :l,
          return: :l
        )

      assert query == "CREATE (l) RETURN l"
    end

    test "return multiple bindings" do
      query =
        cypher(
          create: [:l1, :l2],
          return: [:l1, :l2]
        )

      assert query == "CREATE (l1), (l2) RETURN l1, l2"
    end

    test "return an expression" do
      query =
        cypher(
          create: {:l, [:Link], %{title: "Google"}},
          return: "l.title"
        )

      assert query == ~s|CREATE (l:Link {title: "Google"}) RETURN l.title|
    end
  end

  describe "order by" do
    test "order by a single expression" do
      query =
        cypher(
          match: {:l, [:Link]},
          return: :l,
          order_by: "l.title"
        )

      assert query == "MATCH (l:Link) RETURN l ORDER BY l.title"
    end

    test "order by multiple properties" do
      query =
        cypher(
          match: {:l, [:Link]},
          return: :l,
          order_by: ["l.title", "l.url"]
        )

      assert query == "MATCH (l:Link) RETURN l ORDER BY l.title, l.url"
    end
  end

  describe "limit" do
    test "limit with integer" do
      query =
        cypher(
          match: {:l, [:Link]},
          return: :l,
          limit: 3
        )

      assert query == "MATCH (l:Link) RETURN l LIMIT 3"
    end

    test "limit with expression" do
      query =
        cypher(
          match: {:l, [:Link]},
          return: :l,
          limit: "3 + 3"
        )

      assert query == "MATCH (l:Link) RETURN l LIMIT 3 + 3"
    end
  end
end
