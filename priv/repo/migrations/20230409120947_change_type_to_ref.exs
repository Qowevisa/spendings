defmodule Spendings.Repo.Migrations.ChangeTypeToRef do
  use Ecto.Migration

  def change do
    alter table(:incomes) do
      remove :type
      add :type_id, references(:types, on_delete: :restrict)
    end

    alter table(:expenses) do
      remove :type
      add :type_id, references(:types, on_delete: :restrict)
    end
  end
end
