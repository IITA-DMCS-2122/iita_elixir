defmodule Todo.Scrapper do
  @moduledoc """
  The Scrapper context.
  """

  import Todo.Scrapper.Helpers
  @doc """
  Returns a link list of individual cars for specified page from olx page.

  ## Examples

      iex> get_page_cars_links(1)
      [%String, ...]

  """
  def get_page_cars_links(page_number) do
    adress = if page_number === 1 do
        "https://www.olx.pl/motoryzacja/samochody/"
      else
        "https://www.olx.pl/motoryzacja/samochody/?page=" <> Integer.to_string(page_number)
    end
    case HTTPoison.get(adress) do
    {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
      body
      |> Floki.parse_document!()
      |> Floki.find("a")
      |> get_elements_with_attribute_value("data-cy", "listing-ad-title")
      |> Floki.attribute("href")

    {:ok, %HTTPoison.Response{status_code: 404}} ->
      IO.puts "Not found :("
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
      urls =
      body
      |> Floki.find("span")
      |> Floki.find("a")
      |> Floki.find("span")
      |> Floki.text
      splitted_urls = String.split(urls, "...")
      cuurent_string = List.last(splitted_urls)
      splitted_urls = String.split(cuurent_string, "następna")
      pages_number = List.first(splitted_urls)
      elem(Integer.parse(pages_number), 0)
    {:ok, %HTTPoison.Response{status_code: 404}} ->
      IO.puts "Not found :("
    {:error, %HTTPoison.Error{reason: reason}} ->
      IO.inspect reason
   end
  end


  @doc """
  Returns a list of link list of individual cars from olx page.

  ## Examples

      iex> get_all_cars_from_all_pages()
      [[%String, ...], ...]

  """
  def get_all_cars_from_all_pages() do
    pages_number = Todo.Scrapper.get_pages_number()
    for n <- 1..pages_number do
      get_page_cars_links(n)
    end
  end


  @doc """
  Returns a link list of individual cars from olx page.

  ## Examples

      iex> get_result_as_one_list()
      [[%String, ...]]

  """
  def get_result_as_one_list() do
    all_pages = Todo.Scrapper.get_all_cars_from_all_pages()
    List.flatten(all_pages)
  end
end
