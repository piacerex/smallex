defmodule Rest do
  @doc """
  Path list devide last id

  ## Examples
      iex> Rest.separate_id( [ "abc", "def", "123" ] )
      { "abc/def/", 123 }
      iex> Rest.separate_id( [ "456" ] )
      { "", 456 }
      iex> Rest.separate_id( [ "abc", "def" ] )
      { "abc/def/", nil }
      iex> Rest.separate_id( [] )
      { "", nil }
      iex> Rest.separate_id( [ "" ] )
      { "", nil }
      iex> Rest.separate_id( nil )
      { "", nil }
  """
  def separate_id(nil), do: {"", nil}

  def separate_id(path_list) when is_list(path_list) do
    id = path_list |> List.last() |> Type.to_number()
    no_id_path_list = if id == nil, do: path_list, else: path_list |> Enum.drop(-1)
    {no_id_path_list |> concat_path, id}
  end

  @doc """
  Path list concat to path string

  ## Examples
      iex> Rest.concat_path( [ "abc", "def" ] )
      "abc/def/"
      iex> Rest.concat_path( [] )
      ""
      iex> Rest.concat_path( [ "" ] )
      ""
      iex> Rest.concat_path( [ "", "" ] )
      ""
  """
  def concat_path([]), do: ""

  def concat_path(path_list) when is_list(path_list) do
    if List.first(path_list) == "" do
      ""
    else
      Enum.join(path_list, "/") <> "/"
    end
  end

  def json_eval!(json_path, params) do
    File.read!(json_path)
    |> Code.eval_string(params)
    |> elem(0)
  end

  @doc """
  Error body
  """
  def error_body(body), do: %{error: body} |> Jason.encode!()
end
