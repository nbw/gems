defmodule GEMS.Flyio.Region do
  @moduledoc """
  Helper module for Fly Regions

  [Fly Documenation](https://fly.io/docs/reference/regions/)
  """

  def current do
    System.fetch_env("FLY_REGION")
    |> case do
      {:ok, region} -> region
      _ -> "LOCAL"
    end
  end
end
