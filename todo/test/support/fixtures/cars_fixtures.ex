defmodule Todo.CarsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Todo.Cars` context.
  """

  @doc """
  Generate a car.
  """
  def car_fixture(attrs \\ %{}) do
    {:ok, car} =
      attrs
      |> Enum.into(%{
        link: "some link",
        make: "some make",
        model: "some model"
      })
      |> Todo.Cars.create_car()

    car
  end
end
