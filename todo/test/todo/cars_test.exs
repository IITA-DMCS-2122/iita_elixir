defmodule Todo.CarsTest do
  use Todo.DataCase

  alias Todo.Cars

  describe "cars" do
    alias Todo.Cars.Car

    import Todo.CarsFixtures

    @invalid_attrs %{link: nil, make: nil, model: nil}

    test "list_cars/0 returns all cars" do
      car = car_fixture()
      assert Cars.list_cars() == [car]
    end

    test "get_car!/1 returns the car with given id" do
      car = car_fixture()
      assert Cars.get_car!(car.id) == car
    end

    test "create_car/1 with valid data creates a car" do
      valid_attrs = %{link: "some link", make: "some make", model: "some model"}

      assert {:ok, %Car{} = car} = Cars.create_car(valid_attrs)
      assert car.link == "some link"
      assert car.make == "some make"
      assert car.model == "some model"
    end

    test "create_car/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Cars.create_car(@invalid_attrs)
    end

    test "update_car/2 with valid data updates the car" do
      car = car_fixture()
      update_attrs = %{link: "some updated link", make: "some updated make", model: "some updated model"}

      assert {:ok, %Car{} = car} = Cars.update_car(car, update_attrs)
      assert car.link == "some updated link"
      assert car.make == "some updated make"
      assert car.model == "some updated model"
    end

    test "update_car/2 with invalid data returns error changeset" do
      car = car_fixture()
      assert {:error, %Ecto.Changeset{}} = Cars.update_car(car, @invalid_attrs)
      assert car == Cars.get_car!(car.id)
    end

    test "delete_car/1 deletes the car" do
      car = car_fixture()
      assert {:ok, %Car{}} = Cars.delete_car(car)
      assert_raise Ecto.NoResultsError, fn -> Cars.get_car!(car.id) end
    end

    test "change_car/1 returns a car changeset" do
      car = car_fixture()
      assert %Ecto.Changeset{} = Cars.change_car(car)
    end

    test "create_car/1 increments total count of cars and delete_car/1 decrements it" do
      count_before = length(Cars.list_cars())

      create_attrs = %{link: "some link", make: "some make", model: "some model"}
      {:ok, %Car{} = car} = Cars.create_car(create_attrs)
      assert length(Cars.list_cars()) == count_before + 1

      Cars.delete_car(car)
      assert length(Cars.list_cars()) == count_before
    end
  end
end
