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
      Repo.insert!(changeset)
    end

    {:noreply, assign(socket, :types, Repo.all(Type))}
  end

  def handle_event("delete_type", %{"id" => id}, socket) do
    Repo.get(Type, id)
    |> Repo.delete()

    {:noreply, assign(socket, :types, Repo.all(Income))}
  end
end
