# Smallex

[Smallex](https://hex.pm/packages/smallex) is a Elixir small utilities. Here is an example:

```elixir
iex> Json.call( "https://api.github.com", "/rate_limit" ) |> Map.get( "rate" ) |> Map.get( "limit" )
60
```

See the [online documentation](https://hexdocs.pm/smallex).

## Installation

Add to your ```mix.exs``` file:

```elixir
def deps do
  [
    { :smallex, "~> 0.0.4" }
  ]
end
```

## License
This project is licensed under the terms of the MIT license, see LICENSE.
