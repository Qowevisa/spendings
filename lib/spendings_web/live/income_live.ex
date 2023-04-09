defmodule SpendingsWeb.IncomeLive do
  use SpendingsWeb, :live_view
  alias Spendings.Repo.Type
  alias Spendings.Repo
  alias Spendings.Repo.Income

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:changeset, Income.changeset(%Income{}))
      |> assign(
        :incomes,
        Repo.all(Income)
        |> Repo.preload(:type)
      )
      |> assign(:types, Type.get_all_names())

    {:ok, socket}
  end

  @impl true
  def handle_event("add_income", %{"income" => income_params}, socket) do
    type = Repo.get_by(Type, name: income_params["type_id"])

    changeset = Income.changeset(%Income{}, Map.put(income_params, "type_id", type.id))

    IO.inspect(changeset)
    if changeset.valid? do
      Repo.insert!(changeset)
    end

    {:noreply, assign(socket, :incomes, Repo.all(Income))}
  end

  def handle_event("delete_income", %{"id" => id}, socket) do
    Repo.get(Income, id)
    |> Repo.delete()

    {:noreply, assign(socket, :incomes, Repo.all(Income))}
  end
end
