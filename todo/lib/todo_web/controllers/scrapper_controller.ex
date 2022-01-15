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

  def create(conn, %{"scrapp" => scrapp_params}) do
    Sentry.capture_message("Info", extra: %{extra: "Scrapping process started"})
    scrapped_data = Scrapper.get_car_details_from_page(scrapp_params["page_number"])
    for car_params <- scrapped_data do
      if car_params[:link] not in [nil] and car_params[:make] not in [nil] and car_params[:model] not in [nil] do
        try do
            Cars.create_car(car_params)
          rescue
            e in Ecto.ConstraintError ->
              IO.puts("Attempt to add already exising db entry")
              Sentry.capture_exception(e, [stacktrace: __STACKTRACE__, extra: %{extra: "Attempt to add already exising db entry"}])
          end
      end
    end
    changeset = Scrapp.changeset(%Scrapp{})
    Sentry.capture_message("Info", extra: %{extra: "Scrapping process completed"})
    conn = put_flash(conn, :info, "Scrapping process completed")
    render(conn, "new.html", changeset: changeset)
  end
end
