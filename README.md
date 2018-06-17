# Smallex

[Smallex](https://hex.pm/packages/smallex) is a Elixir small utilities. Here is an example:

```elixir
iex> Dt.to_datetime( "2018/1" )
~N[2018-01-01 00:00:00]

iex> Dt.to_datetime( "2018/1/2 03:04:05" )
~N[2018-01-02 03:04:05]

iex> Dt.to_datetime( "2018-01-02 23:44:09" )
~N[2018-01-02 23:44:09]

iex> Dt.to_datetime( "Jan-02-18" )
~N[2018-01-02 00:00:00]

iex> Dt.to_datetime( "Jan-02-18 23:44:09" )
~N[2018-01-02 23:44:09]

iex> Dt.to_jst( "2018/1/2 10:23:45" )
"2018/01/02 19:23"

iex> Number.to_string( 123.456 )
"123.456"

iex> Number.to_string( 123.456, 1 )
"123.5"

iex> Number.to_string( Decimal.new( 123.456 ) )
"123.456"

iex> Number.pad_zero( 123 )
"00000000000123"

iex> Number.percent( 100, 8 )
"12.5%"

iex> Number.percent( 0, 8 )
"0.0%"

iex> Number.percent( 100, 0 )
"(n/a)"

iex> Number.add_comma( 123456.78 )
"123,456.78"

iex> Number.add_comma( 1234567.890123 )
"1,234,567.89"

iex> Number.add_comma( 1234567.890123, -1 )
"1,234,567.890,123"

iex> Number.add_sign( 0 )
"±0"

iex> Number.add_sign( 0.001, 3 )
"+0.001"

iex> Number.add_sign( 0.09, 1 )
"+0.1"

iex> Number.add_sign( -0.001, 3 )
"-0.001"

iex> { :ok, "success" } |> Tpl.ok
"success"

iex> { :error, "error" } |> Tpl.error
"error"

iex> Lst.to_csv( [ 1, "ab", 8, true ] )
"1, ab, 8, true"

iex> Lst.frequency( [ "abc", "abc", "xyz", "abc", "def", "xyz" ] )
%{ "abc" => 3, "def" => 1, "xyz" => 2 }

iex> MapList.zip( [ "a", "b", "c" ], [ 1, 2, 3 ] )
%{ "a" => 1, "b" => 2, "c" => 3 }

iex> MapList.zip_atom( [ "a", "b", "c" ], [ 1, 2, 3 ] )
%{ a: 1, b: 2, c: 3 }

iex> MapList.merge( [ %{ "a" => "key1", "b" => 12 }, %{ "a" => "key2", "b" => 22 } ], [ %{ "a" => "key1", "c" => 13 }, %{ "a" => "key3", "c" => 23 } ], "a", "no_match" )
[ %{ "a" => "key1", "b" => 12, "c" => 13 }, %{ "a" => "key2", "b" => 22, "c" => "no_match" } ]

iex> MapList.replace( [ %{ "a" => "key1", "b" => 12 }, %{ "a" => "key2", "b" => 22 } ], [ %{ "a" => "key1", "c" => 13 }, %{ "a" => "key3", "c" => 23 } ], "a" )
[ %{ "a" => "key1", "b" => 12, "c" => 13 }, %{ "a" => "key2", "b" => 22 } ]

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
    { :smallex, "~> 0.1.7" }
  ]
end
```

## License
This project is licensed under the terms of the Apache 2.0 license, see LICENSE.
