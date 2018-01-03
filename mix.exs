defmodule Smallex.Mixfile do
  use Mix.Project

  def project do
    [
      app: :smallex,
      version: "0.0.1",
      elixir: "~> 1.5",
		description: "Elixir small utilities", 
		package: 
		[
			maintainers: [ "data-maestro" ], 
			licenses:    [ "MIT" ], 
			links:       %{ "GitHub" => "https://github.com/data-maestro/smallex" }, 
		],
      start_permanent: Mix.env == :prod,
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
			{ :ex_doc,         "~> 0.18.1", only: :dev, runtime: false }, 
			{ :earmark,        "~> 1.2.4" }, 
			{ :power_assert,   "~> 0.1.1",  only: :test }, 
			{ :mix_test_watch, "~> 0.5.0",  only: :dev, runtime: false }, 
			{ :dialyxir,       "~> 0.5.1" }, 

			{ :timex,          "~> 3.1.24" }, 
			{ :math,           "~> 0.3.0" }, 
			{ :complex_num,    "~> 1.0.0" }, 

			{ :nimble_csv,     "~> 0.4.0" }, 

			{ :ecto,           "~> 2.2.6" }, 

			{ :httpoison,      "~> 0.13.0" }, 
			{ :poison,         "~> 3.1.0" }, 
			{ :floki,          "~> 0.19.2" },

			{ :combine,        "~> 0.10.0" }, 

			{ :scrivener_html, "~> 1.7.1" }, 
			{ :scrivener_list, "~> 1.0.1" }, 

			{ :quantum,        "~> 2.2.0" }, 

			{ :slack,          "~> 0.12.0" }, 

			{ :flow,           "~> 0.12.0" }, 
		]
	end
end
