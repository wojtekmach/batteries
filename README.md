# Batteries

work-in-progress!

```
$ mix archive.install github wojtekmach/batteries
$ iex
iex> alias Batteries.{Requests, Jason}
iex> Requests.get!("https://httpbin.org/json").body |> Jason.decode!()
%{...}
```
