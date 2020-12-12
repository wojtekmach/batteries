defmodule Batteries.Requests do
  def get(url, opts \\ []) do
    Application.ensure_all_started(:inets)
    Application.ensure_all_started(:ssl)

    request_headers =
      for {name, value} <- Keyword.get(opts, :headers, []) do
        name = name |> Atom.to_charlist() |> :string.replace('_', '-')
        {name, String.to_charlist(value)}
      end

    request = {url, request_headers}

    case :httpc.request(:get, request, [], body_format: :binary) do
      {:ok, {{_, status, _}, resp_headers, body}} ->
        resp_headers =
          for {key, value} <- resp_headers, do: {List.to_string(key), List.to_string(value)}

        {:ok, %{status: status, headers: resp_headers, body: body}}

      other ->
        other
    end
  end

  def get!(url, opts \\ []) do
    case get(url, opts) do
      {:ok, response} -> response
      {:error, exception} -> raise exception
    end
  end
end
