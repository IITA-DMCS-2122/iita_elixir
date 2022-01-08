defmodule Todo.Repo.Migrations.CreateCars do
  use Ecto.Migration

  def change do
    create table(:cars) do
      add :make, :string
      add :model, :string
      add :link, :string

      timestamps()
    end
  end
end
