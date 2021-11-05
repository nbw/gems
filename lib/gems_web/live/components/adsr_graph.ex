defmodule GEMSWeb.Components.AdsrGraph do
  @moduledoc """
  ADSR Graph component. Returns an SVG.
  """
  use Phoenix.Component

  alias GEMS.Music

  def graph(
        %{
          w: w,
          h: h,
          adsr: %{a: a, d: d, s: s, r: r}
        } = assigns
      ) do
    coords =
      Music.adsr_coords(a, d, s, r)
      |> format_coordinates(w - 2, h)

    ~H"""
    <svg height={h} width={w} viewBox={"-2 0 #{w} #{h}"} xmlns="http://www.w3.org/2000/svg">
      <%= for i <- 0..3 do %>
        <% [x1, y1] =  Enum.at(coords, i) %>
        <% [x2, y2] =  Enum.at(coords, i+1) %>
        <line
          vector-effect="non-scaling-stroke"
          x1={x1} y1={y1} x2={x2} y2={y2}
        />
      <% end %>
    </svg>
    """
  end

  defp format_coordinates(coords, w, h) do
    Stream.map(coords, fn [x, y] ->
      # reason: svg 0,0 origin is top left corner
      [x, 100 - y]
    end)
    |> Enum.map(fn [x, y] ->
      # scale to size of svg
      [x * (w / 100), y * h / 100]
    end)
  end
end
