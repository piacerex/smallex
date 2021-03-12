defmodule Lst do
  @moduledoc """
  List library.
  """

  @doc """
  To CSV

  ## Examples
    iex> Lst.to_csv( [ 1, "ab", 8, true ] )
    "1,ab,8,true"
    # iex> Lst.to_csv( [ 1, "ab", 8, true ], :quote )
    # "\"1\", \"ab\", \"8\", \"true\""

    iex> Lst.to_csv( [ 1, "ab", 8, true ], [ quote: "'" ] )
    "'1','ab','8','true'"
    # iex> Lst.to_csv( [ 1, "ab", 8, true ], [ quote: "\"" ] )
    # "\"1\",\"ab\",\"8\",\"true\""

    iex> Lst.to_csv( [ 1, "ab", 8, true ], [ separator: ", ", post_separator: "-- " ] )
    "1, -- ab, -- 8, -- true"
    iex> Lst.to_csv( [ 1, "ab", 8, true ], [ quote: "'", separator: ", ", post_separator: "-- " ] )
    "'1', -- 'ab', -- '8', -- 'true'"
    iex> Lst.to_csv( [ 1, "ab", 8, true ], [ quote: "'", separator: " / ", post_separator: "- " ] )
    "'1' / - 'ab' / - '8' / - 'true'"
  """
  def to_csv(list, options \\ nil) do
    quote =
      if is_list(options) && options[:quote] != nil do
        options[:quote]
      else
        if options == :quote do
          "\""
        else
          ""
        end
      end

    separator =
      if is_list(options) && options[:separator] != nil, do: options[:separator], else: ","

    post_separator =
      if is_list(options) && options[:post_separator] != nil,
        do: options[:post_separator],
        else: ""

    list
    |> Enum.reduce("", fn v, acc -> "#{acc}#{separator}#{post_separator}#{quote}#{v}#{quote}" end)
    |> String.slice(String.length("#{separator}#{post_separator}")..-1)
  end

  @doc """
  Calculate frequency of values ftom list

  ## Examples
    iex> Lst.frequency( [ "abc", "abc", "xyz", "abc", "def", "xyz" ] )
    %{ "abc" => 3, "def" => 1, "xyz" => 2 }
    iex> Lst.frequency( [ %{ "a" => "abc" }, %{ "a" => "abc" }, %{ "a" => "xyz" }, %{ "a" => "abc" }, %{ "a" => "def" }, %{ "a" => "xyz" } ] )
    %{ %{ "a" => "abc"} => 3, %{ "a" => "def" } => 1, %{ "a" => "xyz" } => 2 }
  """
  def frequency(list),
    do: list |> Enum.reduce(%{}, fn k, acc -> Map.update(acc, k, 1, &(&1 + 1)) end)

  @doc """
  Zip two lists to map

  ## Examples
    iex> Lst.zip( [ "a", "b", "c" ], [ 1, 2, 3 ] )
    %{ "a" => 1, "b" => 2, "c" => 3 }
    iex> Lst.zip( [ "a", "b", "c" ], [ 1, 2, 3 ], :atom )
    %{ a: 1, b: 2, c: 3 }
  """
  def zip(list1, list2, :atom),
    do:
      Enum.zip(list1, list2)
      |> Enum.reduce(%{}, fn {k, v}, acc -> Map.put(acc, String.to_atom(k), v) end)

  def zip(list1, list2, :no_atom), do: Enum.zip(list1, list2) |> Enum.into(%{})
  def zip(list1, list2), do: zip(list1, list2, :no_atom)

  @doc """
  Zip columns list and list of rows list

  ## Examples
    iex> Lst.columns_rows( [ "c1", "c2", "c3" ], [ [ "v1", 2, true ], [ "v2", 5, false ] ] )
    [ %{ "c1" => "v1", "c2" => 2, "c3" => true }, %{ "c1" => "v2", "c2" => 5, "c3" => false } ]
    iex> Lst.columns_rows( [ "c1", "c2", "c3" ], [ [ "v1", 2, true ], [ "v2", 5, false ] ], :atom )
    [ %{ c1: "v1", c2: 2, c3: true }, %{ c1: "v2", c2: 5, c3: false } ]
  """
  def columns_rows(columns, rows, :atom), do: rows |> Enum.map(&zip(columns, &1, :atom))
  def columns_rows(columns, rows, :no_atom), do: rows |> Enum.map(&zip(columns, &1))
  def columns_rows(columns, rows), do: columns_rows(columns, rows, :no_atom)

  @doc """
  Separate

  ## Examples
    iex> Lst.separate( [ [ "c1", "c2", "c3" ], [ "v1", 2, true ], [ "v2", 5, false ] ], "columns", "rows" )
    %{ "columns" => [ "c1", "c2", "c3" ], "rows" => [ [ "v1", 2, true ], [ "v2", 5, false ] ] }
  """
  def separate(list, head_name, tail_name) do
    [head | tail] = list
    %{head_name => head, tail_name => tail}
  end

  @doc """
  Delete keyword list items by keys(string)

  ## Examples
  	iex> Lst.delete_by_keys( [ c1: 6, c2: 7, c3: 8, c4: 9, c5: 0 ], [ "c2", "c4" ] )
  	[ c1: 6, c3: 8, c5: 0 ]
  	iex> Lst.delete_by_keys( [ c1: 6, c2: 7, c3: 8, c4: 9, c5: 0 ], [ "c3", "c1" ] )
  	[ c2: 7, c4: 9, c5: 0 ]
  """
  def delete_by_keys(list, names) do
    names |> Enum.reduce(list, fn name, acc -> Keyword.delete(acc, String.to_atom(name)) end)
  end

  @doc """
  String list to atom list

  ## Examples
    iex> Lst.to_atoms_from_strings( [ "c1", "c2", "c3" ] )
    [ :c1, :c2, :c3 ]
  """
  def to_atoms_from_strings(list) do
    list |> Enum.map(&String.to_atom(&1))
  end

  @doc """
  Pickup match lists

  ## Examples
    iex> Lst.pickup_match( [ "c1", "c2", "c3", "c4", "c5" ], [ "c2", "c4" ] )
    [ "c2", "c4" ]
  """
  def pickup_match(list1, list2) do
    list1 |> Enum.filter(fn item1 -> Enum.find(list2, fn item2 -> item1 == item2 end) != nil end)
  end

  @doc """
  Pickup match index lists

  ## Examples
    iex> Lst.pickup_match_index( [ "c1", "c2", "c3", "c4", "c5", "c6" ], [ "c1", "c3", "c6" ] )
    [ 5, 2, 0 ]
  """
  def pickup_match_index(columns, find_column_names) do
    find_column_names
    |> Enum.reduce([], fn find_column_name, acc ->
      acc ++ [Enum.find_index(columns, &(&1 == find_column_name))]
    end)
    |> Enum.reverse()
  end

  @doc """
  Pickup unmatch lists

  ## Examples
    iex> Lst.pickup_unmatch( [ "c1", "c2", "c3", "c4", "c5" ], [ "c2", "c4" ] )
    [ "c1", "c3", "c5" ]
  """
  def pickup_unmatch(list1, list2) do
    list1 |> Enum.filter(fn item1 -> Enum.find(list2, fn item2 -> item1 == item2 end) == nil end)
  end

  @doc """
  Pickup match list and in map lists

  ## Examples
    iex> Lst.pickup_match_from_map( [ %{ "name" => "c2", "age" => 21 }, %{ "name" => "c4", "age" => 42 } ], [ "c1", "c2", "c3", "c4", "c5" ], "name" )
    [ %{ "name" => "c2", "age" => 21 }, %{ "name" => "c4", "age" => 42 } ]
    iex> Lst.pickup_match_from_map( [ %{ "name" => "c2", "age" => 21 }, %{ "name" => "c6", "age" => 84 } ], [ "c1", "c2", "c3", "c4", "c5" ], "name" )
    [ %{ "name" => "c2", "age" => 21 } ]
  """
  def pickup_match_from_map(map_list, list, map_list_key) do
    map_list
    |> Enum.map(fn map ->
      if Enum.find(list, &(&1 == map[map_list_key])) != nil, do: map, else: nil
    end)
    |> List.delete(nil)
  end

  @doc """
  List from map

  ## Examples
    iex> Lst.list_from_map( [ %{ "name" => "c2", "age" => 21 }, %{ "name" => "c4", "age" => 42 } ], "name" )
    [ "c2", "c4" ]
    iex> Lst.list_from_map( [ %{ "name" => "c2", "items" => [ 11, 21, 31 ] }, %{ "name" => "c4", "items" => [ 21, 22, 32 ] } ], "items", 1 )
    [ 21, 22 ]
  """
  def list_from_map(map_list, key) do
    map_list |> Enum.map(& &1[key])
  end

  def list_from_map(map_list, key, index) do
    map_list |> Enum.map(&Enum.at(&1[key], index))
  end

  @doc """
  Merge lists

  ## Examples
    iex> Lst.merge( [ [ "c4", "c5", "c6" ], [ "c7", "c8", "c9" ] ], [ "c1", "c2" ] )
    [ [ "c1", "c4", "c5", "c6" ], [ "c2", "c7", "c8", "c9" ] ]
  """
  def merge(list_list, add_list) do
    Enum.zip(list_list, add_list) |> Enum.map(fn {list, value} -> [value] ++ list end)
  end

  @doc """
  Checks containing value in list

  ## Examples
    iex> Lst.contains?(["abc", "def"], "bc")
    true
    iex> Lst.contains?(["abc", "def"], "abcd")
    false
    iex> Lst.contains?(["abc", "def"], "def")
    true
    iex> Lst.contains?(["abc", "def"], "cd")
    false
    iex> Lst.contains?(["abc", "def"], 123)
    nil
    iex> Lst.contains?(["abc", "def"], ["xy", "ef"])
    true
    iex> Lst.contains?(["abc", "def"], ["xy", "z"])
    false
    iex> Lst.contains?(["abc", "def"], ["xy", ["fg", "de"], "z"])
    true
  """
  def contains?(list, value)  when is_binary(value), do: Enum.any?(list, & String.contains?(&1, value))
  def contains?(list, values) when is_list(values),  do: Enum.reduce( values, false, fn value, acc -> contains?(list, value) || acc end )
  def contains?(_, _),                               do: nil
end
