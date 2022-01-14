defmodule Todo.Scrapp.Scrapp do
  use Ecto.Schema
  import Ecto.Changeset

  schema "scrapper" do
    field :page_number, :integer

    timestamps()
  end


  @doc false
  def changeset(scrapp, params \\ %{}) do
    cast(scrapp, params, [:page_number])
  end
end
