defmodule Mockompare.MixProject do
  use Mix.Project

  def project do
    [
      app: :mockompare,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
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
      {:meck, "~> 0.9.2"},
      {:mock, "~> 0.3.7"},
      {:mockery, "~> 2.3.0"},
      {:mox, "~> 1.0", only: :test},
      {:patch, "~> 0.6.0", only: :test}
    ]
  end
end
