defmodule Loxe.Mixfile do
  use Mix.Project

  def project do
    [
      app: :loxe,
      version: "0.4.0",
      elixir: "~> 1.14",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      name: "Loxe",
      source_url: "https://github.com/polyfox/loxe"
    ]
  end

  defp description do
    """
    A Logfmt based logger for Elixir.
    """
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:logfmt, ">= 3.3.0"},
      {:benchee, "~> 1.1", only: [:dev]},
    ]
  end

  defp package do
    # These are the default files included in the package
    [
      name: :loxe,
      files: ["lib", "priv", "mix.exs", "README*", "readme*", "LICENSE*", "license*"],
      maintainers: ["Blaž Hrastnik", "Corey Powell"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/polyfox/loxe"}
    ]
  end
end
