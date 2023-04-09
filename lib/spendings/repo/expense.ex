defmodule Spendings.Repo.Expense do
  use Ecto.Schema
  import Ecto.Changeset
  alias Spendings.Repo
  import Ecto.Query, only: [from: 2]

  @timestamps_opts [type: :utc_datetime_usec]

  schema "expenses" do
    field :value, :integer
    belongs_to :type, Spendings.Repo.Type

    timestamps()
  end

  def changeset(part, params \\ %{}) do
    part
    |> cast(params, [:value, :type_id])
  end

  def get_all() do
    query =
      from i in __MODULE__,
        join: t in assoc(i, :type),
        select: merge(i, %{type: t})

    Repo.all(query)
  end

  def get(id) do
    query =
      from i in __MODULE__,
        where: i.id == ^id,
        join: t in assoc(i, :type),
        select: merge(i, %{type: t})

    Repo.all(query) |> List.first()
  end
end
