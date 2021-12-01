defmodule GEMS.Util.Time do
  def now(tz \\ "Etc/UTC"), do: DateTime.now!(tz)
end
