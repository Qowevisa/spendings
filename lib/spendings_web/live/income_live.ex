defmodule SpendingsWeb.IncomeLive do
  use SpendingsWeb, :live_view
  alias Spendings.Repo
  alias Spendings.Repo.Income

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:changeset, Income.changeset(%Income{}))
      |> assign(:incomes, Repo.all(Income))

    {:ok, socket}
  end

  @impl true
  def handle_event("add_income", %{"income" => income_params}, socket) do
    changeset = Income.changeset(%Income{}, income_params)

    if changeset.valid? do
      Repo.insert!(changeset)
    end

    {:noreply, assign(socket, :incomes, Repo.all(Income))}
  end

  def handle_event("delete_income", %{"id" => id}, socket) do

    Repo.get(Income, id)
    |> Repo.delete

    {:noreply, assign(socket, :incomes, Repo.all(Income))}
  end
end
