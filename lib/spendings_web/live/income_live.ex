defmodule SpendingsWeb.IncomeLive do
  use SpendingsWeb, :live_view
  alias Spendings.Repo.Type
  alias Spendings.Repo
  alias Spendings.Repo.Income
  require Logger

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:changeset, Income.changeset(%Income{}))
      |> assign(:incomes, Income.get_all())
      |> assign(:types, Type.get_all_names())

    {:ok, socket}
  end

  @impl true
  def handle_event("add_income", %{"income" => income_params}, socket) do
    type = Repo.get_by(Type, name: income_params["type_id"])

    changeset =
      Income.changeset(socket.assigns.changeset, Map.put(income_params, "type_id", type.id))

    if changeset.valid? do
      result =
        case Repo.insert_or_update(changeset) do
          {:ok, res} -> [Income.get(res.id)]
          _ -> []
        end

      socket =
        case socket.assigns.changeset.data.id do
          nil ->
            assign(socket, :incomes, socket.assigns.incomes ++ result)

          _ ->
            updated_incomes = Enum.map(
              socket.assigns.incomes,
              fn i ->
                if i.id == List.first(result).id do
                  List.first(result)
                else
                  i
                end
              end
            )
            assign(socket, :incomes, updated_incomes)
        end

      {:noreply, socket}
    else
      {:noreply, socket}
    end
  end

  def handle_event("delete_income", %{"id" => id}, socket) do
    try do
      {id, _} = Integer.parse(id)
      Repo.delete(%Income{id: id})

      socket =
        socket
        |> assign(
          :incomes,
          Enum.filter(socket.assigns.incomes, fn i -> i.id != id end)
        )

      {:noreply, socket}
    rescue
      e in MatchError ->
        Logger.log(:error, e)
        {:noreply, socket}
    end
  end

  def handle_event("edit_income", %{"id" => id}, socket) do
    changeset = Income.get(id) |> Income.changeset()
    {:noreply, assign(socket, :changeset, changeset)}
  end
end
