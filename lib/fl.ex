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
  Write file available on the pipe (return is body)

  ## Examples
      iex> "sample text" |> Fl.write!("test/sample.txt")
      "sample text"
      iex> File.read!("test/sample.txt")
      "sample text"
      iex> File.rm!("test/sample.txt")
      :ok
  """
  def write!(body, path, modes \\ []) when is_binary(body) do
    File.write!(path, body, modes)
    body
  end

  @doc """
  Read file to map with error handling (File contents are held in return[ key ], errors are held in return[ "error" ]

  ## Examples
      iex> "sample text" |> Fl.write!("test/sample.txt")
      iex> Fl.read_map("raw", "test/sample.txt")
      %{"raw" => "sample text", "error" => ""}
      iex> Fl.read_map( "raw", "test/no_exist.txt")
      %{"raw" => "", "error" => "no such file or directory (enoent)"}
      iex> File.rm!("test/sample.txt")
      :ok
  """
  def read_map(key, path), do: File.read(path) |> Fl.handling_ok(key)

  @doc """
  Read file if exist (return: empty string if not exist, "folder" if folder)

  ## Examples
      iex> "sample text" |> Fl.write!("test/sample.txt")
      iex> Fl.read_if_exist("test/sample.txt")
      "sample text"
      iex> Fl.read_if_exist("test/")
      "folder"
      iex> Fl.read_if_exist("no_exist")
      ""
      iex> File.rm!("test/sample.txt")
      :ok
  """
  def read_if_exist(path) do
    if File.exists?(path) do
      if File.dir?(path) do
        "folder"
      else
        File.read!(path)
      end
    else
      ""
    end
  end

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

  @doc """
  Split file

  ## Examples
      iex> result = Fl.split!( "test/split_sample.txt", 2 )
      [ "test/split_sample-0.txt", "test/split_sample-1.txt", "test/split_sample-2.txt", "test/split_sample-3.txt" ]
      iex> result |> Enum.map( & File.rm!( &1 ) )
      [ :ok, :ok, :ok, :ok ]
  """
  def split!(path, row_unit, is_header \\ false) do
    stream = File.stream!(path)

    row_count = stream |> Enum.count()

    header = if is_header, do: Enum.take(stream, 1), else: []

    path_postfix = "." <> (Regex.split(~r/.*\./, path) |> List.last())
    path_prefix = String.slice(path, 0..-(String.length(path_postfix) + 1))
    split_starts = if(is_header, do: 1, else: 0)..(row_count + 1) |> Enum.take_every(row_unit)

    split_ends =
      (row_unit - 1 + if(is_header, do: 1, else: 0))..(row_count + row_unit)
      |> Enum.take_every(row_unit)

    splits =
      Enum.zip([split_starts, split_ends])
      |> Enum.with_index()
      |> Enum.map(
        &%{
          "start" => elem(elem(&1, 0), 0),
          "end" => elem(elem(&1, 0), 1),
          "path" => "#{path_prefix}-#{elem(&1, 1)}#{path_postfix}"
        }
      )

    splits
    |> Enum.map(fn split ->
      if !File.exists?(split["path"]) do
        slice = header ++ (stream |> Enum.slice(split["start"]..split["end"]))

        if slice != [] do
          slice
          |> Enum.join()
          |> write!(split["path"])

          split["path"]
        end
      else
        split["path"]
      end
    end)
    |> Enum.filter(&(&1 != nil))
  end

  @doc ~S"""
  Split file

  ## Examples
      iex> Fl.split_csv!( "test/split_sample.csv", 1, true, true )
      [ "test/split_sample-0.csv", "test/split_sample-1.csv", "test/split_sample-2.csv" ]
      iex> File.read!( "test/split_sample-1.csv" )
      "\"c1\",\"c2\"\n\"split_row-2-1\",\"split_row-\"\"2-2\"\"\"\n"
      iex> File.read!( "test/split_sample-2.csv" )
      "\"c1\",\"c2\"\n\"split_row-3-1\",\"split_row-\n\n3-2\"\n"
      iex> [ "test/split_sample-0.csv", "test/split_sample-1.csv", "test/split_sample-2.csv" ] |> Enum.map( & File.rm!( &1 ) )
      [ :ok, :ok, :ok ]
  """
  def split_csv!(path, row_unit, is_header \\ false, re_create \\ false) do
    stream =
      File.stream!(path)
      |> CSV.decode()
      # TODO: apply libraried
      |> Stream.filter(&(elem(&1, 0) == :ok))
      |> Stream.map(
        &(elem(&1, 1)
          |> Enum.map(fn column ->
            column
            |> String.replace("\"", "\"\"")
            |> String.replace("\n\r\n", "\n")
          end))
      )

    row_count = stream |> Enum.count()

    header = if is_header, do: Enum.take(stream, 1), else: []

    path_postfix = "." <> (Regex.split(~r/.*\./, path) |> List.last())
    path_prefix = String.slice(path, 0..-(String.length(path_postfix) + 1))
    split_starts = if(is_header, do: 1, else: 0)..(row_count + 1) |> Enum.take_every(row_unit)

    split_ends =
      (row_unit - 1 + if(is_header, do: 1, else: 0))..(row_count + row_unit)
      |> Enum.take_every(row_unit)

    splits =
      Enum.zip([split_starts, split_ends])
      |> Enum.with_index()
      |> Enum.map(
        &%{
          "start" => elem(elem(&1, 0), 0),
          "end" => elem(elem(&1, 0), 1),
          "path" => "#{path_prefix}-#{elem(&1, 1)}#{path_postfix}"
        }
      )

    splits
    |> Enum.map(fn split ->
      if re_create == true || File.exists?(split["path"]) == false do
        slice = stream |> Enum.slice(split["start"]..split["end"])

        if slice != [] do
          (header ++ slice)
          |> Stream.map(&((&1 |> Lst.to_csv(quote: "\"")) <> "\n"))
          |> Enum.join()
          |> write!(split["path"])

          split["path"]
        end
      else
        split["path"]
      end
    end)
    |> Enum.filter(&(&1 != nil))
  end
end
