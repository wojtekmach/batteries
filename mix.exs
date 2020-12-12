defmodule Batteries.MixProject do
  use Mix.Project

  def project do
    [
      app: :batteries,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(Mix.env())
    ]
  end

  def application do
    [
      extra_applications: [:logger, :ssl],
      mod: {Batteries.Application, []}
    ]
  end

  defp aliases(env) when env in [:dev, :test] do
    [
      compile: [&compile/1, "compile"]
    ]
  end

  defp aliases(_), do: []

  defp compile(_) do
    vendor([
      {"jason", "Jason"},
      {"finch", "Finch"},
      {"castore", "CAStore"},
      {"mint", "Mint"},
      {"nimble_options", "NimbleOptions"},
      {"nimble_pool", "NimblePool"},
      {"telemetry", "telemetry"}
    ])
  end

  defp vendor(projects) do
    modules =
      for {_, module} <- projects do
        module
      end

    for {name, _} <- projects do
      vendor(name, modules)
    end
  end

  defp vendor(name, modules) do
    {:ok, metadata} = :file.consult("deps/#{name}/hex_metadata.config")
    {"version", version} = List.keyfind(metadata, "version", 0)

    for path <- Path.wildcard("deps/#{name}/{lib,src}/**/*"),
        not File.dir?(path) do
      relative_path = Path.relative_to(path, "deps/#{name}")
      [root | rest] = Path.split(relative_path)
      new_path = Path.join([root, "vendored" | rest])
      File.mkdir_p!(Path.dirname(new_path))

      code = File.read!(path)

      code =
        if Path.extname(path) == ".ex" do
          code =
            Enum.reduce(modules, code, fn module, acc ->
              # naive check if it's erlang module
              new_module =
                if String.downcase(module) == module do
                  "batteries_#{module}"
                else
                  "Batteries.#{module}"
                end

              String.replace(acc, module, new_module)
            end)

          "# vendored from #{name} #{version}\n" <> code
        else
          code
        end

      cond do
        not File.exists?(new_path) ->
          File.write!(new_path, code)

        File.read!(new_path) != code ->
          File.write!(new_path, code)

        true ->
          :ok
      end
    end
  end

  defp deps do
    [
      {:jason, "~> 1.0", only: [:dev]},
      {:finch, "~> 0.5.0", only: [:dev]},
      {:castore, "~> 0.1", only: [:dev]},
      {:mint, "~> 1.2", only: [:dev]},
      {:nimble_options, "~> 0.3.5", only: [:dev]},
      {:nimble_pool, "~> 0.2", only: [:dev]},
      {:telemetry, "~> 0.4", only: [:dev]}
    ]
  end
end
