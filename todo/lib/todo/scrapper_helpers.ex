defmodule Todo.Scrapper.Helpers do

@spec validate_attrs(any, any, any) :: boolean
  def validate_attrs(attrs, attr, val) do
    try do
      for a <- attrs,
        do: if a === {attr, val},
          do: throw(:break)
      false
    catch
      :break -> true
    end
  end

  def get_elements_with_attribute_value(html, attr, val) do
    html
    |> Floki.traverse_and_update(fn {tag, attrs, children} ->
      if validate_attrs(attrs, attr, val),
        do: {tag, attrs, children}, else: nil
      _other -> nil end)
  end

  def get_offer_links(body) do
    body
    |> Floki.parse_document!()
    |> Floki.find("a")
    |> get_elements_with_attribute_value("data-cy", "listing-ad-title")
    |> Floki.attribute("href")
  end

  def next_to_end(link) do
    case HTTPoison.get(link) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        next_link = body
        |> Floki.parse_document!()
        |> Floki.find("a")
        |> get_elements_with_attribute_value("data-cy", "page-link-next")
        |> Floki.attribute("href")
        IO.inspect(next_link)
        if next_link !== [],
          do: get_offer_links(body) ++ next_to_end(next_link),
          else: get_offer_links(body)
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Not found :("
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end

  def parse_car_details(tags) do
    make = for tag <- tags do
      span_text = tag |> Floki.find("span.offer-params__label") |> Floki.text()
      div_text = tag |> Floki.find("div.offer-params__value") |> Floki.text()
      if span_text === "Marka pojazdu", do: div_text |> String.trim()
    end |> Enum.reject(&is_nil/1) |> Enum.at(0)
    model = for tag <- tags do
      span_text = tag |> Floki.find("span.offer-params__label") |> Floki.text()
      div_text = tag |> Floki.find("div.offer-params__value") |> Floki.text()
      if span_text === "Model pojazdu", do: div_text |> String.trim()
    end |> Enum.reject(&is_nil/1) |> Enum.at(0)
    {:make, make, :model, model}
  end

  def get_car_details(link) do
    case HTTPoison.get(link) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body
        |> Floki.parse_document!()
        |> Floki.find("li.offer-params__item")
        |> parse_car_details()
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Not found :("
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end
end
