defmodule SpendingsWeb.ExpenseLive do
  use SpendingsWeb, :live_view
  alias Spendings.Repo.Type
  alias Spendings.Repo
  alias Spendings.Repo.Expense
  require Logger

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:changeset, Expense.changeset(%Expense{}))
      |> assign(:expenses, Expense.get_all())
      |> assign(:types, Type.get_all_names())

    {:ok, socket}
  end

  @impl true
  def handle_event("add_expense", %{"expense" => expense_params}, socket) do
    type = Repo.get_by(Type, name: expense_params["type_id"])

    changeset =
      Expense.changeset(socket.assigns.changeset, Map.put(expense_params, "type_id", type.id))

    if changeset.valid? do
      result =
        case Repo.insert_or_update(changeset) do
          {:ok, res} -> [Expense.get(res.id)]
          _ -> []
        end

      socket =
        case socket.assigns.changeset.data.id do
          nil ->
            assign(socket, :expenses, socket.assigns.expenses ++ result)

          _ ->
            updated_expenses = Enum.map(
              socket.assigns.expenses,
              fn e ->
                if e.id == List.first(result).id do
                  List.first(result)
                else
                  e
                end
              end
            )
            socket
            |> assign(:expenses, updated_expenses)
            |> assign(:changeset, Expense.changeset(%Expense{}))
        end

      {:noreply, socket}
    else
      {:noreply, socket}
    end
  end

  def handle_event("delete_expense", %{"id" => id}, socket) do
    try do
      {id, _} = Integer.parse(id)
      Repo.delete(%Expense{id: id})

      socket =
        socket
        |> assign(
          :expenses,
          Enum.filter(socket.assigns.expenses, fn e -> e.id != id end)
        )

      {:noreply, socket}
    rescue
      e in MatchError ->
        Logger.log(:error, e)
        {:noreply, socket}
    end
  end

  def handle_event("edit_expense", %{"id" => id}, socket) do
    changeset = Expense.get(id) |> Expense.changeset()
    {:noreply, assign(socket, :changeset, changeset)}
  end
end
