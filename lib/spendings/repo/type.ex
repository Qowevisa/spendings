defmodule Spendings.Repo.Type do
  use Ecto.Schema
  import Ecto.Changeset
  alias Spendings.Repo
  import Ecto.Query, only: [from: 2]

  @timestamps_opts [type: :utc_datetime_usec]

  schema "types" do
    field :name, :string

    timestamps()
  end

  def changeset(part, params \\ %{}) do
    part
    |> cast(params, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end

  def get_all_names() do
    Repo.all(
      from t in "types", select: t.name
    )
  end
end
