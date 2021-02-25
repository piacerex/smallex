defmodule Json do
  @moduledoc """
  JSON API call library (with parse support).
  """

  @doc """
  Get JSON API (header & map_function are optional)

  ## Examples
    iex> Json.get( "https://api.github.com", "/rate_limit" )[ "rate" ][ "limit" ]
    60
  """
  def get(domain, path, header \\ []) do
    (domain <> path)
    |> HTTPoison.get!(header)
    |> parse
  end

  @doc """
  Post JSON API (header & map_function are optional)

  ## Examples
    iex> Json.post( "https://httpbin.org", "/post?param1=value1", "{ data1:value1 }", "Content-Type": "application/json" )[ "args" ]
    %{"param1" => "value1"}

    iex> Json.post( "https://httpbin.org", "/post?param1=value1", "{ data1:value1 }", "Content-Type": "application/json" )[ "data" ]
    "{ data1:value1 }"
  """
  def post(domain, path, body, header \\ []) do
    (domain <> path)
    |> HTTPoison.post!(body, header)
    |> parse
  end

  @doc """
  Put JSON API (header & map_function are optional)

  ## Examples
    iex> Json.put( "https://httpbin.org", "/put?param1=value1", "{ data1:value1 }", "Content-Type": "application/json" )[ "args" ]
    %{"param1" => "value1"}
  """
  def put(domain, path, body, header \\ []) do
    (domain <> path)
    |> HTTPoison.put!(body, header)
    |> parse
  end

  @doc """
  Patch JSON API (header & map_function are optional)

  ## Examples
    iex> Json.patch( "https://httpbin.org", "/patch?param1=value1", "{ data1:value1 }", "Content-Type": "application/json" )[ "args" ]
    %{"param1" => "value1"}
  """
  def patch(domain, path, body, header \\ []) do
    (domain <> path)
    |> HTTPoison.patch!(body, header)
    |> parse
  end

  @doc """
  Delete JSON API (header & map_function are optional)

  ## Examples
    iex> ( Json.delete( "https://httpbin.org", "/delete?param1=value1", "Content-Type": "application/json" ) |> Jason.decode! )[ "args" ]
    %{"param1" => "value1"}
  """
  def delete(domain, path, header \\ []) do
    (domain <> path)
    |> HTTPoison.delete!(header)
    |> get_body
  end

  @doc """
  Head JSON API (header & map_function are optional)

  ## Examples
    iex> Json.head( "https://httpbin.org", "/", [] )
    ""
  """
  def head(domain, path, header \\ []) do
    (domain <> path)
    |> HTTPoison.head!(header)
    |> get_body
  end

  defp parse(response) do
    response
    |> get_body
    |> Jason.decode!()
  end

  defp get_body(%{status_code: 200, body: body}), do: body
  defp get_body(%{status_code: 201, body: body}), do: body
  defp get_body(%{status_code: 204, body: body}), do: body
end
