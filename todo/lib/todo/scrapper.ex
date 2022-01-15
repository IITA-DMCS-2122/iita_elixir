defmodule Todo.Scrapper do
  @moduledoc """
  The Scrapper context.
  """

  import Todo.Scrapper.Helpers

  @doc """
  Returns list of all car details from olx page.
  # WARINING ------ THIS MAY TAKE A REALLY LONG TIME !!!
  ## Examples

      iex> get_all_car_details()
      [{:make, "Audi", :model, "A4"}, ...]

  """
  def get_all_car_details() do
    get_all_car_offers()
    |> get_car_details()
  end

  @doc """
  Returns list of links to all car offers at olx page.

  ## Examples

      iex> get_all_car_offers()
      [%String, ...]

  """
  def get_all_car_offers() do
    address = "https://www.olx.pl/motoryzacja/samochody/?page=25"
    next_to_end(address)
  end

  @spec get_car_details_from_page(any) :: list
  @doc """
  Returns list of car details from olx page.

  ## Examples

      iex> get_car_details_from_page(25)
      [{:make, "Audi", :model, "A4"}, ...]

  """
  def get_car_details_from_page(page_number) do
    get_page_cars_links(page_number)
    |> Enum.map(&get_car_details/1)
  end

  @doc """
  Returns a link list of individual cars for specified page from olx page.

  ## Examples

      iex> get_page_cars_links(1)
      [%String, ...]

  """
  def get_page_cars_links(page_number) do
    adress = if page_number === "1" do
        "https://www.olx.pl/motoryzacja/samochody/"
      else
        "https://www.olx.pl/motoryzacja/samochody/?page=" <> page_number
    end
    case HTTPoison.get(adress) do
    {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
      get_offer_links(body)
    {:ok, %HTTPoison.Response{status_code: 404}} ->
      IO.puts "Not found"
    {:ok, %HTTPoison.Response{status_code: 301}} ->
      IO.puts "Unauthorized"
    {:error, %HTTPoison.Error{reason: reason}} ->
      IO.inspect reason
   end
  end

  @doc """
  Returns a page number for cars from olx page

  ## Examples

      iex> get_pages_number()
      21

  """
  def get_pages_number() do
    case HTTPoison.get("https://www.olx.pl/motoryzacja/samochody/") do
    {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
      last_link = body
      |> Floki.parse_document!()
      |> Floki.find("a")
      |> get_elements_with_attribute_value("data-cy", "page-link-last")
      |> Floki.attribute("href")
      |> Enum.at(0)

      Regex.split(~r{\?page=}, last_link)
      |> Enum.at(1)
      |> String.to_integer()
      #|> Integer.parse()
    {:ok, %HTTPoison.Response{status_code: 404}} ->
      IO.puts "Not found :("
    {:error, %HTTPoison.Error{reason: reason}} ->
      IO.inspect reason
   end
  end

end
