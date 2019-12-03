defmodule EctoDot.MixProject do
  use Mix.Project

  def project do
    [
      app: :ecto_dot,
      version: "0.1.0",
      elixir: "~> 1.6",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      name: "EctoDot",
      source_url: "https://github.com/danmarcab/ecto_dot"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto, "~> 3.2"},
      {:mix_test_watch, "~> 0.5", only: :dev, runtime: false}
    ]
  end

  defp description() do
    "Create .dot diagrams from your ecto schemas. Export them to `png`, `svg` or `pdf`."
  end

  defp package() do
    [
      maintainers: ["Daniel Marín Cabillas"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/danmarcab/ecto_dot"}
    ]
  end
end
