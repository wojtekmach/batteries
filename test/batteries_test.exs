defmodule BatteriesTest do
  use ExUnit.Case, async: true

  test "batteries" do
    use Batteries

    Requests.get!("https://httpbin.org/json").body
    |> Jason.decode!()
    |> IO.inspect()
  end
end
