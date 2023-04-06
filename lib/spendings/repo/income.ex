defmodule Spendings.Repo.Income do
  use Ecto.Schema
  import Ecto.Changeset

  @timestamps_opts [type: :utc_datetime_usec]

  schema "incomes" do
    field :value, :integer
    field :type, :string

    timestamps()
  end

  def changeset(part, params \\ %{}) do
    part
    |> cast(params, [:value, :type])
  end
end
