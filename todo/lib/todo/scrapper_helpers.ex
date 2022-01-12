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
end
