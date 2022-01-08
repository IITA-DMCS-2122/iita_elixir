defmodule Todo.Cars.Car do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cars" do
    field :link, :string
    field :make, :string
    field :model, :string

    timestamps()
  end

  @doc false
  def changeset(car, attrs) do
    car
    |> cast(attrs, [:make, :model, :link])
    |> validate_required([:make, :model, :link])
  end
end
