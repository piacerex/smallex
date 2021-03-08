defmodule Type do
  @moduledoc """
  Type library.
  """

  @doc """
  Type check

  ## Examples
    iex> Type.is( nil )
    "nil"
    iex> Type.is( "v1" )
    "String"
    iex> Type.is( "2" )
    "Integer"
    iex> Type.is( 2 )
    "Integer"
    iex> Type.is( "true" )
    "Boolean"
    iex> Type.is( true )
    "Boolean"
    iex> Type.is( "false" )
    "Boolean"
    iex> Type.is( false )
    "Boolean"
    iex> Type.is( "12.34" )
    "Float"
    iex> Type.is( 12.34 )
    "Float"
    iex> Type.is( %{ "cs" => "v1", "ci" => "2", "cb" => "true", "cf" => "12.34" } )
    %{ "cs" => "String", "ci" => "Integer", "cb" => "Boolean", "cf" => "Float" }
    iex> Type.is( %{ "cs" => "v1", "ci" => 2, "cb" => true, "cf" => 12.34 } )
    %{ "cs" => "String", "ci" => "Integer", "cb" => "Boolean", "cf" => "Float" }
    iex> Type.is( [ "v1", 2, true, 12.34 ] )
    [ "String", "Integer", "Boolean", "Float" ]
  """
  def is(map) when is_map(map),
    do: map |> Enum.reduce(%{}, fn {k, v}, acc -> Map.put(acc, k, is(v)) end)

  def is(list) when is_list(list), do: list |> Enum.map(&is(&1))
  def is(nil), do: "nil"

  def is(value) when is_binary(value) do
    cond do
      is_boolean_include_string(value) -> "Boolean"
      is_float_include_string(value) -> "Float"
      is_integer_include_string(value) -> "Integer"
      true -> "String"
    end
  end

  def is(value) when is_boolean(value), do: "Boolean"
  def is(value) when is_float(value), do: "Float"
  def is(value) when is_integer(value), do: "Integer"

  def is_boolean_include_string(value) when is_binary(value) do
    String.downcase(value) == "true" || String.downcase(value) == "false"
  end

  def is_boolean_include_string(value), do: is_boolean(value)

  def is_float_include_string(value) when is_binary(value) do
    try do
      if String.to_float(value), do: true, else: false
    catch
      _, _ -> false
    end
  end

  def is_float_include_string(value), do: is_float(value)

  def is_integer_include_string(value) when is_binary(value) do
    try do
      if String.to_integer(value), do: true, else: false
    catch
      _, _ -> false
    end
  end

  def is_integer_include_string(value), do: is_integer(value)

  def is_datetime(value) do
    try do
      if Dt.to_datetime(value) |> is_map, do: true, else: false
    catch
      _, _ -> false
    end
  end

  @doc """
  aa

  ## Examples
    iex> Type.is_empty( nil )
    true
    iex> Type.is_empty( "" )
    true
    iex> Type.is_empty( "abc" )
    false
    iex> Type.is_empty( 123 )
    false
    iex> Type.is_empty( 12.34 )
    false
  """
  def is_empty(nil), do: true
  def is_empty(""), do: true
  def is_empty(_), do: false

  @doc """
  aa

  ## Examples
    iex> Type.float( nil )
    "NaN"
    iex> Type.float( "" )
    "NaN"
    iex> Type.float( "12.34567" )
    "12.35"
    iex> Type.float( "12.34444" )
    "12.34"
    iex> Type.float( 12.34567 )
    "12.35"
    iex> Type.float( 12.34444 )
    "12.34"
  """
  def float(nil), do: "NaN"
  def float(""), do: "NaN"

  def float(value) when is_number(value) do
    case is(value) do
      "Float" -> value |> Number.to_string(2)
      "Integer" -> value |> Number.to_string()
    end
  end

  def float(value) when is_binary(value) do
    case is(value) do
      "Float" -> value |> String.to_float() |> Number.to_string(2)
      "Integer" -> value |> String.to_integer() |> Number.to_string()
    end
  end

  @doc """
  aa

  ## Examples
    iex> Type.to_number( nil )
    nil
    iex> Type.to_number( "123" )
    123
    iex> Type.to_number( "12.34" )
    12.34
    iex> Type.to_number( 123 )
    123
    iex> Type.to_number( 12.34 )
    12.34
    iex> Type.to_number( "" )
    nil
    iex> Type.to_number( "abc" )
    nil
  """
  def to_number(nil), do: nil
  def to_number(value) when is_number(value), do: value

  def to_number(value) when is_binary(value) do
    case is(value) do
      "Float" -> value |> String.to_float()
      "Integer" -> value |> String.to_integer()
      _ -> nil
    end
  end

  @doc """
  To string

  ## Examples
    iex> Type.to_string( nil )
    ""
    iex> Type.to_string( 123 )
    "123"
    iex> Type.to_string( 12.34 )
    "12.34"
    iex> Type.to_string( "123" )
    "123"
    iex> Type.to_string( "12.34" )
    "12.34"
    iex> Type.to_string( ~N[2015-01-28 01:15:52.00] )
    "2015-01-28T01:15:52.000Z"
  """
  def to_string(nil), do: ""
  def to_string(value) when is_binary(value), do: value

  def to_string(value) when is_number(value) do
    case is(value) do
      "Float" -> value |> Float.to_string()
      "Integer" -> value |> Integer.to_string()
      _ -> nil
    end
  end

  def to_string(value) when is_map(value) do
    if is_datetime(value) do
      Dt.to_datetime(value) |> Dt.to_string("%Y-%0m-%0dT%0H:%0M:%0S.%0LZ")
    else
      inspect(value)
    end
  end

  def to_string_datetime(value) when is_map(value),
    do: Dt.to_string(value, "%Y-%0m-%0dT%0H:%0M:%0S.%0LZ")

  def to_string_datetime(value), do: value

  @doc """
  Possible types(not collentions)

  ## Examples
    iex> Type.possible_types( "" )
    [ "String" ]
    iex> Type.possible_types( "1" )
    [ "Integer", "String" ]
    iex> Type.possible_types( 1 )
    [ "Integer" ]
    iex> Type.possible_types( "1.2" )
    [ "Float", "String" ]
    iex> Type.possible_types( 1.2 )
    [ "Float" ]
    iex> Type.possible_types( true )
    [ "Boolean" ]
    iex> Type.possible_types( "true" )
    [ "Boolean", "String" ]
    iex> Type.possible_types( "True" )
    [ "Boolean", "String" ]
    iex> Type.possible_types( false )
    [ "Boolean" ]
    iex> Type.possible_types( "false" )
    [ "Boolean", "String" ]
    iex> Type.possible_types( "False" )
    [ "Boolean", "String" ]
  """
  def possible_types(value) do
    [
      %{"label" => "Integer", "checker" => &is_integer_include_string/1},
      %{"label" => "Float", "checker" => &is_float_include_string/1},
      %{"label" => "String", "checker" => &is_binary/1},
      %{"label" => "Boolean", "checker" => &is_boolean_include_string/1}
    ]
    |> Enum.map(&if &1["checker"].(value) == true, do: &1["label"], else: nil)
    |> Enum.filter(&(&1 != nil))
    |> Enum.sort()
  end

  @doc """
  Is missing

  ## Examples
    iex> Type.is_missing( "" )
    true
    iex> Type.is_missing( nil )
    true
    iex> Type.is_missing( "a" )
    false
    iex> Type.is_missing( 1 )
    false
    iex> Type.is_missing( 1.2 )
    false
    iex> Type.is_missing( true )
    false
  """
  def is_missing(value), do: value == nil || value == ""
end
