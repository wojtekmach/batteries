# Batteries

work-in-progress!

```
$ mix archive.install github wojtekmach/batteries
$ iex -pa $HOME/.mix/archives/batteries-0.1.0/**/ebin
iex> alias Batteries.{Requests, Jason}
iex> Requests.get!("https://httpbin.org/json").body |> Jason.decode!()
%{...}
```
