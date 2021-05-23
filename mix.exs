defmodule Smallex.Mixfile do
  use Mix.Project

  def project do
    [
      app: :smallex,
      version: "0.2.4",
      elixir: "~> 1.8",
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
      {:ex_doc, "~> 0.24", only: :dev, runtime: false},
      {:earmark, "~> 1.4", only: :dev},
      {:power_assert, "~> 0.2.0", only: :test},
      {:mix_test_watch, "~> 1.0", only: :dev, runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:timex, "~> 3.6.3"},
      {:decimal, "~> 2.0"},
      {:httpoison, "~> 1.8"},
      {:jason, "~> 1.2"},
      {:csv, "~> 2.4"},
      {:excelion, "~> 0.0.5"},
      {:statistics, "~> 0.6.2"},
      {:git_hooks, "~> 0.6.2", only: [:test, :dev], runtime: false}
    ]
  end
end
