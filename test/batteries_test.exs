defmodule BatteriesTest do
  use ExUnit.Case, async: true

  test "batteries" do
    use Batteries

    Requests.get("https://hex.pm/api")
    |> IO.inspect()
  end
end
