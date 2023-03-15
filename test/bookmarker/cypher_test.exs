defmodule Bookmarker.CypherTest do
  use ExUnit.Case

  import Kernel, except: [node: 1]
  import Bookmarker.Cypher

  describe "create" do
    test "create a single node" do
      query =
        cypher([
          create(node(:l))
        ])

      assert query == "CREATE (l)"
    end

    test "create a single node with a label" do
      query =
        cypher([
          create(node(:l, [:Link]))
        ])

      assert query == "CREATE (l:Link)"
    end

    test "create multiple nodes" do
      query =
        cypher([
          create([
            node(:l1, [:Link]),
            node(:l2, [:Link])
          ])
        ])

      assert query == "CREATE (l1:Link), (l2:Link)"
    end

    test "create a single node and return it" do
      query =
        cypher([
          create(node(:l, [:Link])),
          return(:l)
        ])

      assert query == "CREATE (l:Link) RETURN l"
    end

    test "create two nodes in a relationship" do
      query =
        cypher([
          create(
            relationship(
              node(:l1, [:Link]),
              {:b, :Before},
              node(:l2, [:Link])
            )
          ),
          return([:l1, :b, :l2])
        ])

      assert query == "CREATE (l1:Link)-[b:Before]->(l2:Link) RETURN l1, b, l2"
    end

    test "create two nodes, then relate them" do
      query =
        cypher([
          create([
            node(:l1, [:Link]),
            node(:l2, [:Link]),
            relationship(node(:l1), {:b, :Before, %{foo: "bar"}}, node(:l2))
          ]),
          return([:l1, :b, :l2])
        ])

      assert query ==
               ~s|CREATE (l1:Link), (l2:Link), (l1)-[b:Before {foo: "bar"}]->(l2) RETURN l1, b, l2|
    end
  end

  describe "match" do
    test "match all nodes" do
      query =
        cypher([
          match(node(:n)),
          return(:n)
        ])

      assert query == "MATCH (n) RETURN n"
    end

    test "match by label" do
      query =
        cypher([
          match(node(:l, :Link)),
          return(:l)
        ])

      assert query == "MATCH (l:Link) RETURN l"
    end

    test "match by property" do
      query =
        cypher([
          match(node(:l, :Link, %{title: "Google"})),
          return(:l)
        ])

      assert query == ~s|MATCH (l:Link {title: "Google"}) RETURN l|
    end
  end

  describe "return" do
    test "return a thing" do
      query =
        cypher([
          return(:n)
        ])

      assert query == "RETURN n"
    end

    test "return a property" do
      query =
        cypher([
          match(node(:l, :Link)),
          return("l.title")
        ])

      assert query == "MATCH (l:Link) RETURN l.title"
    end
  end

  describe "node" do
    test "plain label node" do
      assert node(:l, :Link) == "(l:Link)"
      assert node(:l, [:Link]) == "(l:Link)"
      assert node(:l, [:Link, :Other]) == "(l:Link:Other)"
    end

    test "node with properties" do
      assert node(:l, :Link, %{title: "Google", url: "https://google.com"}) ==
               ~s|(l:Link {title: "Google", url: "https://google.com"})|
    end
  end

  describe "relationship" do
    test "create basic relationship" do
      assert relationship(
               node(:l, :Link),
               :before,
               node(:l, :Link)
             ) == "(l:Link)-[:before]->(l:Link)"
    end

    test "create relationship with binding" do
      assert relationship(
               node(:l, :Link),
               {:b, :before},
               node(:l, :Link)
             ) == "(l:Link)-[b:before]->(l:Link)"
    end

    test "create relationship with properties" do
      assert relationship(
               node(:l, :Link),
               {:b, :before, %{foo: "bar"}},
               node(:l, :Link)
             ) == ~s|(l:Link)-[b:before {foo: "bar"}]->(l:Link)|
    end
  end
end
