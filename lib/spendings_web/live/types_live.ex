defmodule SpendingsWeb.TypesLive do
  use SpendingsWeb, :live_view
  alias Spendings.Repo
  alias Spendings.Repo.Type

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:changeset, Type.changeset(%Type{}))
      |> assign(:types, Repo.all(Type))

    {:ok, socket}
  end

  @impl true
  def handle_event("add_type", %{"type" => income_params}, socket) do
    changeset = Type.changeset(%Type{}, income_params)

    if changeset.valid? do
      case Repo.insert(changeset) do
        {:ok, _type} ->
          socket = socket
          |> assign(:types, Repo.all(Type))
          |> assign(:changeset, Type.changeset(%Type{}))
          {:noreply, socket}
        {:error, changeset} ->
          {:noreply, assign(socket, :changeset, changeset)}
      end
    else
      {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  def handle_event("delete_type", %{"id" => id}, socket) do
    Repo.get(Type, id)
    |> Repo.delete()

    {:noreply, assign(socket, :types, Repo.all(Type))}
  end
end
