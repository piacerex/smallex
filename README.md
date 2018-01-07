# Smallex

[Smallex](https://hex.pm/packages/smallex) is a Elixir small utilities. Here is an example:

```elixir
iex> Json.get( "https://api.github.com", "/rate_limit" )[ "rate" ][ "limit" ]
60

iex> Json.post( "https://httpbin.org", "/post?param1=value1", "{ data1:value1 }" )[ "args" ]
%{"param1" => "value1"}

iex> Json.post( "https://httpbin.org", "/post?param1=value1", "{ data1:value1 }" )[ "data" ]
"{ data1:value1 }"
```

See the [online documentation](https://hexdocs.pm/smallex).

## Installation

Add to your ```mix.exs``` file:

```elixir
def deps do
  [
    { :smallex, "~> 0.0.7" }
  ]
end
```

## License
This project is licensed under the terms of the Apache 2.0 license, see LICENSE.
