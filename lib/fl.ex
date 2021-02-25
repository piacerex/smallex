defmodule Fl do
  @moduledoc """
  File library.
  """

  @doc """
  Write from map list to file after pipe

  ## Examples
    iex> [ %{ "key" => "k1", "value" => "v1" }, %{ "key" => "k2", "value" => "v2" }, %{ "key" => "k3", "value" => "v3" } ] |> Fl.write_map_list!( "test/sample.csv", :no_quote )
    [ %{ "key" => "k1", "value" => "v1" }, %{ "key" => "k2", "value" => "v2" }, %{ "key" => "k3", "value" => "v3" } ]
    iex> File.read!( "test/sample.csv" )
    "key,value
    k1,v1
    k2,v2
    k3,v3
    "
    iex> File.rm!( "test/sample.csv" )
    :ok

    iex> [] |> Fl.write_map_list!( "test/sample2.csv", :no_quote )
    []
    iex> File.read!( "test/sample2.csv" )
    ""
    iex> File.rm!( "test/sample2.csv" )
    :ok
  """
  def write_map_list!(map_list, path, option \\ :quote, modes \\ []) do
    _write_map_list!(map_list, path, option, modes)
  end

  defp _write_map_list!([], path, _option, modes) do
    File.write!(path, "", modes)
    []
  end

  defp _write_map_list!([head | _tail] = map_list, path, option, modes) when is_map(head) do
    File.write!(path, map_list |> MapList.to_csv(option), modes)
    map_list
  end

  @doc """
  Write file after pipe

  ## Examples
    iex> "sample text" |> Fl.write!( "test/sample.txt" )
    "sample text"
    iex> File.read!( "test/sample.txt" )
    "sample text"
    iex> File.rm!( "test/sample.txt" )
    :ok
  """
  def write!(content, path, modes \\ []) when is_binary(content) do
    File.write!(path, content, modes)
    content
  end

  @doc """
  Read file to map with error handling (File contents are held in return[ key ], errors are held in return[ "error" ]

  ## Examples
    iex> "sample text" |> Fl.write!( "test/sample.txt" )
    iex> Fl.read_map( "raw", "test/sample.txt" )
    %{ "raw" => "sample text", "error" => "" }
    iex> Fl.read_map( "raw", "test/no_exist.txt" )
    %{ "raw" => "", "error" => "no such file or directory (enoent)" }
    iex> File.rm!( "test/sample.txt" )
    :ok
  """
  def read_map(key, path), do: File.read(path) |> Fl.handling_ok(key)

  @doc """
  File result handler (2 states)

  ## Examples
    iex> :ok |> Fl.handling
    ""
    iex> { :ok, "result text" } |> Fl.handling
    "result text"
    iex> { :error, :eexist } |> Fl.handling
    "Already exist, please change input"
    iex> { :error, :eisdir, "dummy" } |> Fl.handling
    "Folder not readable"
  """
  def handling(:ok), do: ""
  def handling({:ok, result}), do: result
  def handling({:error, :eexist}), do: "Already exist, please change input"
  def handling({:error, :eisdir}), do: "Folder not readable"
  def handling({:error, err_code}), do: "#{:file.format_error(err_code)} (#{err_code})"
  def handling({:error, err_code, _}), do: handling({:error, err_code})

  @doc """
  File result handler (3 states)

  ## Examples
    iex> { :ok, "result text" } |> Fl.handling_ok( "raw" )
    %{ "raw" => "result text", "error" => "" }
    iex> { :error, :eexist } |> Fl.handling_ok( "raw" )
    %{ "raw" => "", "error" => "Already exist, please change input" }
  """
  def handling_ok({:ok, result}, key), do: %{key => result, "error" => ""}
  def handling_ok({:error, result}, key), do: %{key => "", "error" => handling({:error, result})}
end
