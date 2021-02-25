defmodule Number do
  @moduledoc """
  Number library.
  """

  @doc """
  Round

  ## Examples
  	iex> Number.round( 123 )
  	123
  	iex> Number.round( 123.456 )
  	123.456
  	iex> Number.round( 123.456, 2 )
  	123.46
  	iex> Number.round( 123.456, 1 )
  	123.5
  """
  # <- default parameter function is separately declared
  def round(value, precision \\ -1)

  def round(value, precision) when is_float(value) == true,
    do: if(precision >= 0, do: value |> Float.round(precision), else: value)

  def round(value, _) when is_integer(value) == true, do: value

  @doc """
  To number return float or integer)

  ## Examples
  	iex> Number.to_number( 123 )
  	123
  	iex> Number.to_number( 123.456 )
  	123.456
  	iex> Number.to_number( Decimal.from_float( 123456.78 ) )
  	123456.78
  	iex> Number.to_number( "123456.78" )
  	123456.78
  """
  def to_number(value) when is_binary(value) == true, do: value |> String.to_float()

  def to_number(value),
    do: if(Decimal.decimal?(value) == true, do: value |> Decimal.to_float(), else: value)

  @doc """
  To string

  ## Examples
  	iex> Number.to_string( 123 )
  	"123"
  	iex> Number.to_string( 123.456 )
  	"123.456"
  	iex> Number.to_string( 123.456, 2 )
  	"123.46"
  	iex> Number.to_string( 123.456, 1 )
  	"123.5"
  	iex> Number.to_string( Decimal.from_float( 123.456 ) )
  	"123.456"
  	iex> Number.to_string( "123.456" )
  	"123.456"
  """
  # <- default parameter function is separately declared
  def to_string(value, precision \\ -1)

  def to_string(value, precision) when is_float(value) == true,
    do: value |> Number.round(precision) |> Float.to_string()

  def to_string(value, _) when is_integer(value) == true, do: value |> Integer.to_string()

  def to_string(value, precision) when is_binary(value) == true,
    do: value |> String.to_float() |> Number.round(precision) |> Float.to_string()

  def to_string(value, precision),
    do:
      if(Decimal.decimal?(value) == true,
        do: Decimal.to_float(value) |> Number.round(precision) |> Float.to_string()
      )

  @doc """
  Pad number at zero (return string)

  ## Examples
  	iex> Number.pad_zero( 123 )
  	"00000000000123"
  """
  def pad_zero(number, length \\ 14), do: pad(number, length, "0")

  @doc """
  Pad number at any (return string)

  ## Examples
  	iex> Number.pad( 123, 6, "_" )
  	"___123"
  """
  def pad(number, length, padding) when is_integer(number) do
    number |> Integer.to_string() |> String.pad_leading(length, padding)
  end

  @doc """
  Calculate percent (return string)

  ## Examples
  	iex> Number.percent( 100, 8 )
  	"12.5%"
  	iex> Number.percent( 0, 8 )
  	"0.0%"
  	iex> Number.percent( 100, 0 )
  	"(n/a)"
  """
  def percent(numerator, denominator, precision \\ 2) do
    cond do
      denominator == 0 || denominator == nil -> "(n/a)"
      denominator != 0 -> Number.to_string(numerator / denominator, precision) <> "%"
    end
  end

  @doc """
  Add comma (return string)

  ## Examples
  	iex> Number.add_comma( 123 )
  	"123"
  	iex> Number.add_comma( 1234 )
  	"1,234"
  	iex> Number.add_comma( 1234.56 )
  	"1,234.56"
  	iex> Number.add_comma( 123456.78 )
  	"123,456.78"
  	iex> Number.add_comma( 1234567.890123, -1 )
  	"1,234,567.890,123"
  	iex> Number.add_comma( 1234567.890123 )
  	"1,234,567.89"
  	iex> Number.add_comma( Decimal.from_float( 123456.78 ) )
  	"123,456.78"
  	iex> Number.add_comma( "123456.78" )
  	"123,456.78"
  """
  def add_comma(value, precision \\ 2), do: value |> Number.to_string(precision) |> _insert_comma
  defp _insert_comma(value), do: Regex.replace(~r/(\d)(?=(\d\d\d)+(?!\d))/, value, "\\1,")

  @doc """
  To integer (return integer)

  ## Examples
  	iex> Number.to_integer( 1234 )
  	1234
  	iex> Number.to_integer( 1234.56 )
  	1234
  	iex> Number.to_integer( Decimal.from_float( 1234.56 ) )
  	1234
  	iex> Number.to_integer( "1234.56" )
  	1234
  """
  def to_integer(value), do: value |> Number.to_string() |> _head_split_dot

  defp _head_split_dot(value),
    do: value |> String.split(".") |> List.first() |> String.to_integer()

  @doc """
  To percent (return string)

  ## Examples
  	iex> Number.to_percent( 123 )
  	"12300%"
  	iex> Number.to_percent( 0.123 )
  	"12.3%"
  	iex> Number.to_percent( 0.123456 )
  	"12.35%"
  	iex> Number.to_percent( Decimal.from_float( 0.123 ) )
  	"12.3%"
  	iex> Number.to_percent( Decimal.from_float( 0.123456 ) )
  	"12.35%"
  	iex> Number.to_percent( "0.123" )
  	"12.3%"
  	iex> Number.to_percent( "0.123456" )
  	"12.35%"
  """
  def to_percent(value, precision \\ 2),
    do: (Number.to_number(value) * 100) |> Number.to_string(precision) |> _add_percent

  defp _add_percent(value), do: value <> "%"

  @doc """
  Add sign (return string)

  ## Examples
  	iex> Number.add_sign( 0 )
  	"±0"
  	iex> Number.add_sign( 123 )
  	"+123"
  	iex> Number.add_sign( -123 )
  	"-123"
  	iex> Number.add_sign( 0.0 )
  	"±0.0"
  	iex> Number.add_sign( 0.00 )
  	"±0.0"
  	iex> Number.add_sign( 0.001 )
  	"+0.0"
  	iex> Number.add_sign( 0.001, 3 )
  	"+0.001"
  	iex> Number.add_sign( 0.001, -1 )
  	"+0.001"
  	iex> Number.add_sign( 0.09, 2 )
  	"+0.09"
  	iex> Number.add_sign( 0.09, 1 )
  	"+0.1"
  	iex> Number.add_sign( -0.001 )
  	"0.0"
  	iex> Number.add_sign( -0.001, 3 )
  	"-0.001"
  	iex> Number.add_sign( -0.001, -1 )
  	"-0.001"
  """
  def add_sign(value, precision \\ 2) do
    cond do
      Number.to_number(value) == 0 -> "±" <> Number.to_string(value, precision)
      Number.to_number(value) > 0 -> "+" <> Number.to_string(value, precision)
      Number.to_number(value) < 0 -> Number.to_string(value, precision)
    end
  end
end
