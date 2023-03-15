defmodule Bookmarker.Repo do
  use Ecto.Repo,
    adapter: Bookmarker.RedisGraphAdapter,
    otp_app: :bookmarker
end
