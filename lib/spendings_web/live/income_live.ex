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

    changeset = Income.changeset(socket.assigns.changeset, Map.put(income_params, "type_id", type.id))


    if changeset.valid? do
      Repo.insert_or_update(changeset)
    end

    socket =
      socket
      |> assign(
        :incomes,
        Repo.all(Income)
        |> Repo.preload(:type)
      )
      |> assign(:changeset, Income.changeset(%Income{}))

    {:noreply, socket}
  end

  def handle_event("delete_income", %{"id" => id}, socket) do
    Repo.get(Income, id)
    |> Repo.delete()

    socket =
      socket
      |> assign(
        :incomes,
        Repo.all(Income)
        |> Repo.preload(:type)
      )


    {:noreply, socket}
  end

  def handle_event("edit_income", %{"id" => id}, socket) do
    income = Repo.get(Income, id) |> Repo.preload(:type)
    changeset = Income.changeset(income)
    {:noreply, assign(socket, :changeset, changeset)}
  end
end
