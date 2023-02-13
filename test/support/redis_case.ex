defmodule Bookmarker.RedisCase do
  use ExUnit.CaseTemplate

  setup do
    # Random number from 0-9 based on the test seed
    select_index = rem(ExUnit.configuration()[:seed], 10)

    {:ok, conn} = Redix.start_link()
    {:ok, _res} = Redix.command(conn, ["SELECT", to_string(select_index)])
    {:ok, _res} = Redix.command(conn, ["FLUSHALL"])

    %{redis_conn: conn}
  end
end
