defmodule Spendings.Repo.Migrations.CreateExpenceEntity do
  use Ecto.Migration

  def change do
    create table(:expences) do
      add :value, :bigint
      add :type, :string

      timestamps()
    end
  end
end
