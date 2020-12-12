defmodule Batteries.Requests do
  def get(url) do
    unless Process.whereis(Batteries.Finch) do
      Batteries.Finch.start_link(name: Batteries.Finch)
    end

    Batteries.Finch.build(:get, url)
    |> Batteries.Finch.request(Batteries.Finch)
  end

  def get!(url) do
    case get(url) do
      {:ok, response} -> response
      {:error, exception} -> raise exception
    end
  end
end
