# Batteries

work-in-progress!

```
$ mix archive.install github wojtekmach/batteries
$ iex
iex> use Batteries
iex> Requests.get!("https://httpbin.org/json").body |> Jason.decode!()
%{...}
```
