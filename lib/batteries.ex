defmodule Batteries do
  defmacro __using__(_) do
    quoted = []

    quoted =
      if Code.ensure_loaded?(Jason) do
        quoted
      else
        [quote(do: alias(Batteries.Jason)) | quoted]
      end

    quoted = [quote(do: alias(Batteries.Requests)) | quoted]

    quoted
  end
end
