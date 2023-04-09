defmodule SpendingsWeb.IncomeLive.Index do
  use Phoenix.Component
  use Phoenix.HTML
  use SpendingsWeb, :live_view
  alias Spendings.Repo
  alias Spendings.Repo.Income

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :incomes, Repo.all(Income))}
  end

  @impl true
  def handle_event("delete_income", %{"id" => id}, socket) do
    income = Repo.get!(Income, id)
    Repo.delete!(income)

    {:noreply, assign(socket, :incomes, Repo.all(Income))}
  end
end
