defmodule Spendings.Repo.Migrations.CreateIncomeEntity do
  use Ecto.Migration

  def change do
    create table(:incomes) do
      add :value, :bigint
      add :type, :string

      timestamps()
    end
  end
end
