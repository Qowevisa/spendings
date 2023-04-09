defmodule Spendings.Repo.Type do
  use Ecto.Schema
  import Ecto.Changeset

  @timestamps_opts [type: :utc_datetime_usec]

  schema "types" do
    field :name, :string

    timestamps()
  end

  def changeset(part, params \\ %{}) do
    part
    |> cast(params, [:name])
  end
end
