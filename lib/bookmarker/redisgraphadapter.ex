defmodule Bookmarker.RedisGraphAdapter do
  @behaviour Ecto.Adapter

  # Fake it till you make it
  @impl true
  def init(_config) do
    a = Supervisor.child_spec({Agent, fn -> :ok end}, id: {Agent, 1})
    {:ok, a, %{}}
  end

  # Stolen from Ecto.Adapters.SQL
  @impl true
  def loaders({:map, _}, type), do: [&Ecto.Type.embedded_load(type, &1, :json)]
  def loaders(:binary_id, type), do: [Ecto.UUID, type]
  def loaders(_, type), do: [type]

  # Stolen from Ecto.Adapters.SQL
  @impl true
  def dumpers({:map, _}, type), do: [&Ecto.Type.embedded_dump(type, &1, :json)]
  def dumpers(:binary_id, type), do: [type, Ecto.UUID]
  def dumpers(_, type), do: [type]

  # Fake it till you make it
  @impl true
  def ensure_all_started(_config, _type) do
    {:ok, [:things_are_probably_fine]}
  end

  # We don't provide a pool, so nothing to do here
  @impl true
  def checkout(_adapter_meta, _config, function) do
    function.()
  end

  # No pool, so we are never checked out
  @impl true
  def checked_out?(_adapter_meta) do
    false
  end

  # Not sure if this will work...
  @impl true
  defmacro __before_compile__(_env) do
    nil
  end

  def insert() do
    IO.inspect("Inserting")
    nil
  end
end
