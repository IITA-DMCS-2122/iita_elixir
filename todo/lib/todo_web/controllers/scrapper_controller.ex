defmodule TodoWeb.ScrapperController do
  use TodoWeb, :controller

  alias Todo.Cars
  alias Todo.Scrapp.Scrapp
  alias Todo.Scrapper

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def new(conn, _params) do
    changeset = Scrapp.changeset(%Scrapp{})
    render(conn, "new.html", changeset: changeset)
  end

  @spec create(Plug.Conn.t(), map) :: Plug.Conn.t()
  def create(conn, %{"scrapp" => scrapp_params}) do
    Scrapper.get_car_details_from_page(scrapp_params["page_number"])
    |> Enum.map(&Cars.create_car/1)
    changeset = Scrapp.changeset(%Scrapp{})
    Sentry.capture_message("Info", extra: %{extra: "Scrapping process completed"})
    conn = put_flash(conn, :info, "Scrapping process completed")
    render(conn, "new.html", changeset: changeset)
  end
end
