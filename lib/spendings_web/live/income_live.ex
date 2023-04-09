defmodule SpendingsWeb.IncomeLive do
  use SpendingsWeb, :live_view
  alias Spendings.Repo
  alias Spendings.Repo.Income

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :changeset, Income.changeset(%Income{}))}
  end

  @impl true
  def handle_event("add_income", %{"income" => income_params}, socket) do
    changeset = Income.changeset(%Income{}, income_params)
    if changeset.valid? do
      Repo.insert!(changeset)
    end

    {:noreply, assign(socket, :incomes, Repo.all(Income))}
  end

  # @impl true
  # def render(assigns) do

  # end
end
