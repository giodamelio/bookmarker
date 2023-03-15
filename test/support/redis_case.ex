defmodule Bookmarker.RedisCase do
  use ExUnit.CaseTemplate

  setup do
    {:ok, conn} = Redix.start_link()
    {:ok, _res} = Redix.command(conn, ["FLUSHALL"])

    {:ok, redis_conn: conn}
  end
end
