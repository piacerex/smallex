defmodule Smallex.Mixfile do
  use Mix.Project

  def project do
    [
      app: :smallex,
      version: "0.2.4",
      elixir: "~> 1.6",
      description: "Elixir small utilities",
      package: [
        maintainers: ["piacere-ex"],
        licenses: ["Apache 2.0"],
        links: %{"GitHub" => "https://github.com/piacere-ex/smallex"}
      ],
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
      {:ex_doc, "~> 0.19", only: :dev, runtime: false},
      {:earmark, "~> 1.2", only: :dev},
      {:power_assert, "~> 0.1.1", only: :test},
      {:mix_test_watch, "~> 0.6", only: :dev, runtime: false},
      {:dialyxir, "~> 0.5.1", only: :dev},
      {:timex, "~> 3.3"},
      {:decimal, "~> 1.0"},
      {:httpoison, "~> 1.8"},
      {:jason, "~> 1.2"},
      {:csv, "~> 2.1"},
      {:excelion, "~> 0.0.5"},
      {:statistics, "~> 0.5.1"}
    ]
  end
end
