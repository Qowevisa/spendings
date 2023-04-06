defmodule Spendings.Repo do
  use Ecto.Repo,
    otp_app: :spendings,
    adapter: Ecto.Adapters.Postgres
end
