defmodule Spendings.Repo.Income do
  use Ecto.Schema
  import Ecto.Changeset

  @timestamps_opts [type: :utc_datetime_usec]

  schema "incomes" do
    field :value, :integer
    belongs_to :type, Spendings.Repo.Type

    timestamps()
  end

  def changeset(part, params \\ %{}) do
    part
    |> cast(params, [:value, :type_id])
  end
end
