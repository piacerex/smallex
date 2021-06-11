defmodule Dt do
  @moduledoc """
  DateTime utiity.
  """

  # https://hexdocs.pm/timex/Timex.Format.DateTime.Formatters.Strftime.html

  def now_ym(), do: Timex.now() |> to_ym
  def now_ymd(), do: Timex.now() |> to_ymd
  def now_ymdhms(), do: Timex.now() |> to_ymdhms
  def now(), do: Timex.now() |> to_ymdhmsl
  def now_no_delimiter(), do: Timex.now() |> to_ymdhmsl_no_delimiter

  @doc """
  To yyyy/mm string

  ## Examples
      iex> Dt.to_ym(~N[2018-01-02 03:04:05])
      "2018/01"
  """
  def to_ym(dt), do: dt |> to_string("%Y/%0m")

  @doc """
  To yyyy/mm/dd string

  ## Examples
      iex> Dt.to_ymd(~N[2018-01-02 03:04:05])
      "2018/01/02"
  """
  def to_ymd(dt), do: dt |> to_string("%Y/%0m/%0d")

  @doc """
  To yyyy/mm/dd string

  ## Examples
      iex> Dt.to_ymdhms(~N[2018-01-02 03:04:05])
      "2018/01/02 03:04:05"
      iex> Dt.to_ymdhms(~D[2018-01-02])
      "2018/01/02 00:00:00"
  """
  def to_ymdhms(dt), do: dt |> to_string("%Y/%0m/%0d %0H:%0M:%0S")

  @doc """
  To yyyy/mm/dd HH:MM:SS.L string

  ## Examples
      iex> Dt.to_ymdhmsl(~N[2018-01-02 03:04:05.012])
      "2018/01/02 03:04:05.012"
      iex> Dt.to_ymdhmsl(~N[2018-01-02 03:04:05.012345])
      "2018/01/02 03:04:05.012345"
      iex> Dt.to_ymdhmsl(~D[2018-01-02])
      "2018/01/02 00:00:00."
  """
  def to_ymdhmsl(dt), do: dt |> to_string("%Y/%0m/%0d %0H:%0M:%0S.%L")

  @doc """
  To yyyy/mm/dd HH:MM:SS.L string

  ## Examples
      iex> Dt.to_ymdhmsl_no_delimiter(~N[2018-01-02 03:04:05.012345])
      "20180102030405012345"
      iex> Dt.to_ymdhmsl_no_delimiter(~D[2018-01-02])
      "20180102000000"
  """
  def to_ymdhmsl_no_delimiter(dt), do: dt |> to_string("%Y%0m%0d%0H%0M%0S%L")

  @doc """
  Get time difference from string of datetime format

  ## Examples
    iex> Dt.diff_ymd_string("2017-04-12 09:08:58", "2017-04-11 19:08:58", :hours)
    14
    iex> Dt.diff_ymd_string("2017-04-11 19:08:58", "2017-04-12 09:08:58", :hours)
    -14
    iex> Dt.diff_ymd_string("2017-04-12 09:08:58", "2017-04-11 19:08:58", :minutes)
    840
    iex> Dt.diff_ymd_string("2017-04-14 09:08:58", "2017-04-11 19:08:58", :days)
    2
  """
  def diff_ymd_string(to, from, units),
    do: Timex.diff(Dt.to_datetime(to), to_datetime(from), units)

  @doc """
  Add days in yyyy/mm/dd format

  ## Examples
    iex> Dt.add_days("2017/04/11", 2)
    "2017/04/13"
  """
  def add_days(dt, days),
    do: to_datetime(dt) |> Timex.add(Timex.Duration.from_days(days)) |> to_ymd

  @doc """
  List dates in yyyy/mm/dd format

  ## Examples
    iex> Dt.list_ymd(~D[2018-01-03], ~D[2017-12-30])
    ["2018/01/03", "2018/01/02", "2018/01/01", "2017/12/31", "2017/12/30"]
    iex> Dt.list_ymd(~N[2018-01-03 12:34:56], ~N[2017-12-30 12:34:56])
    ["2018/01/03", "2018/01/02", "2018/01/01", "2017/12/31", "2017/12/30"]
    iex> Dt.list_ymd(~D[2017-12-30], ~D[2018-01-05])
    []
    iex> Dt.list_ymd(~N[2017-12-30 12:34:56], ~N[2018-01-05 12:34:56])
    []
    iex> Dt.list_ymd(~N[2018-01-01 01:23:45], ~N[2018-01-01 12:34:56])
    []
  """
  def list_ymd(to, from) do
    [date_to, date_from] = [to, from] |> Enum.map(&Timex.to_datetime(&1))

    if(DateTime.compare(date_to, date_from) == :lt,
      do: [],
      else: 0..diff_ymd_string(to, from, :days) |> Enum.map(&add_days(to, -&1))
    )
  end

  @doc """
  Datetime to string

  ## Examples
      iex> Dt.to_string( ~N[2018-01-02 23:44:09.005], "%Y/%m/%d %H:%M:%S" )
      "2018/01/02 23:44:09"
      iex> Dt.to_string( ~N[2018-01-02 23:44:09.005], "%Y/%m/%d %H:%M:%S.%L" )
      "2018/01/02 23:44:09.005"
      iex> Dt.to_string( ~N[2018-01-02 23:44:09.005], "%Y/%m/%d %H:%M:%S", :with_status )
      { :ok, "2018/01/02 23:44:09" }
  """
  def to_string(dt, format_str, with_status \\ :no_status) do
    ms_treated_format_str =
      if String.contains?(format_str, "%L") do
        ms = dt |> Timex.format("{ss}") |> Tpl.ok() |> String.replace(".", "")
        format_str |> String.replace("%L", ms)
      else
        format_str
      end

    result = Timex.format(dt, ms_treated_format_str, :strftime)

    if with_status == :no_status do
      {:ok, return} = result
      return
    else
      result
    end
  end

  @doc """
  Datetime from string

  ## Examples
      iex> Dt.from_string( "2018/01/02 23:44:09", "%Y/%m/%d %H:%M:%S" )
      ~N[2018-01-02 23:44:09]
      iex> Dt.from_string( "2018/01/02 23:44:09", "%Y/%m/%d %H:%M:%S", :with_status )
      { :ok, ~N[2018-01-02 23:44:09] }
  """
  def from_string(dt_str, format_str, with_status \\ :no_status) do
    result = Timex.parse(dt_str, format_str, :strftime)

    if with_status == :no_status do
      {:ok, return} = result
      return
    else
      result
    end
  end

  @doc """
  Get datetime from string/tuple

  ## Examples
      iex> Dt.to_datetime( "2018/1" )
      ~N[2018-01-01 00:00:00]
      iex> Dt.to_datetime( "2018/ 1" )
      ~N[2018-01-01 00:00:00]
      iex> Dt.to_datetime( "2018/01" )
      ~N[2018-01-01 00:00:00]
      iex> Dt.to_datetime( "2018/1/2" )
      ~N[2018-01-02 00:00:00]
      iex> Dt.to_datetime( "2018/1/2 3:4" )
      ~N[2018-01-02 03:04:00]
      iex> Dt.to_datetime( "2018/1/2 3:4:5" )
      ~N[2018-01-02 03:04:05]
      iex> Dt.to_datetime( "2018/1/2 03:04" )
      ~N[2018-01-02 03:04:00]
      iex> Dt.to_datetime( "2018/1/2 03:04:05" )
      ~N[2018-01-02 03:04:05]
      iex> Dt.to_datetime( "2018/ 1/ 2" )
      ~N[2018-01-02 00:00:00]
      iex> Dt.to_datetime( "2018/1/ 2" )
      ~N[2018-01-02 00:00:00]
      iex> Dt.to_datetime( "2018/01/ 2" )
      ~N[2018-01-02 00:00:00]
      iex> Dt.to_datetime( "2018/01/02" )
      ~N[2018-01-02 00:00:00]
      iex> Dt.to_datetime( "2018/01/02 23:44" )
      ~N[2018-01-02 23:44:00]
      iex> Dt.to_datetime( "2018/01/02 23:44:09" )
      ~N[2018-01-02 23:44:09]
      iex> Dt.to_datetime( "2018/01/02 23:44:09.005" )
      ~N[2018-01-02 23:44:09.005]
      iex> Dt.to_datetime( "2018-01-02" )
      ~N[2018-01-02 00:00:00]
      iex> Dt.to_datetime( "2018-01-02 23:44" )
      ~N[2018-01-02 23:44:00]
      iex> Dt.to_datetime( "2018-01-02 23:44:09" )
      ~N[2018-01-02 23:44:09]
      iex> Dt.to_datetime( "2018-01-02 23:44:09.005" )
      ~N[2018-01-02 23:44:09.005]
      iex> Dt.to_datetime( "Jan-02-2018" )
      ~N[2018-01-02 00:00:00]
      iex> Dt.to_datetime( "Jan-02-2018 23:44" )
      ~N[2018-01-02 23:44:00]
      iex> Dt.to_datetime( "Jan-02-2018 23:44:09" )
      ~N[2018-01-02 23:44:09]
      iex> Dt.to_datetime( "Jan-02-2018 23:44:09.005" )
      ~N[2018-01-02 23:44:09.005]
      iex> Dt.to_datetime( "Jan-02-18" )
      ~N[2018-01-02 00:00:00]
      iex> Dt.to_datetime( "Jan-02-18 23:44" )
      ~N[2018-01-02 23:44:00]
      iex> Dt.to_datetime( "Jan-02-18 23:44:09" )
      ~N[2018-01-02 23:44:09]
      iex> Dt.to_datetime( "Jan-02-18 23:44:09.005" )
      ~N[2018-01-02 23:44:09.005]
      #iex> Dt.to_datetime( "Jan-02-98" )
      #~N[1998-01-02 00:00:00]
      #iex> Dt.to_datetime( "Jan-02-98 23:44" )
      #~N[1998-01-02 23:44:00]
      #iex> Dt.to_datetime( "Jan-02-98 23:44:09" )
      #~N[1998-01-02 23:44:09]
      #iex> Dt.to_datetime( "Jan-02-98 23:44:09.005" )
      #~N[1998-01-02 23:44:09.005]
      iex> Dt.to_datetime( "January-02-2018" )
      ~N[2018-01-02 00:00:00]
      iex> Dt.to_datetime( "January-02-2018 23:44" )
      ~N[2018-01-02 23:44:00]
      iex> Dt.to_datetime( "January-02-2018 23:44:09" )
      ~N[2018-01-02 23:44:09]
      iex> Dt.to_datetime( "January-02-2018 23:44:09.005" )
      ~N[2018-01-02 23:44:09.005]
      iex> Dt.to_datetime( "2018-01-02 23:44:09Z" )
      ~N[2018-01-02 23:44:09]
      iex> Dt.to_datetime( "2018-01-02T23:44:09Z" )
      ~N[2018-01-02 23:44:09]
      iex> Dt.to_datetime( { 2018, 1, 2 } )
      ~N[2018-01-02 00:00:00]
      iex> Dt.to_datetime( { { 2018, 1, 2 }, { 23, 44, 9 } } )
      ~N[2018-01-02 23:44:09]
      iex> Dt.to_datetime( ~D[2018-01-02] )
      ~N[2018-01-02 00:00:00]
      iex> Dt.to_datetime( ~N[2018-01-02 23:10:07] )
      ~N[2018-01-02 23:10:07]
  """
  def to_datetime(str) when is_binary(str) do
    [
      "%Y/%_m",
      "%Y/%_m/%_d",
      "%Y/%_m/%_d %_H:%_M",
      "%Y/%_m/%_d %_H:%_M:%_S",
      "%Y/%_m/%_d %_H:%_M:%_S.%_L",
      "%Y-%_m-%_d",
      "%Y-%_m-%_d %_H:%_M",
      "%Y-%_m-%_d %_H:%_M:%_S",
      "%Y-%_m-%_d %_H:%_M:%_S.%_L",
      "%b-%_d-%Y",
      "%b-%_d-%Y %_H:%_M",
      "%b-%_d-%Y %_H:%_M:%_S",
      "%b-%_d-%Y %_H:%_M:%_S.%_L",
      "%b-%_d-%y",
      "%b-%_d-%y %_H:%_M",
      "%b-%_d-%y %_H:%_M:%_S",
      "%b-%_d-%y %_H:%_M:%_S.%_L",
      "%B-%_d-%Y",
      "%B-%_d-%Y %_H:%_M",
      "%B-%_d-%Y %_H:%_M:%_S",
      "%B-%_d-%Y %_H:%_M:%_S.%_L",
      "%Y-%_m-%_d %_H:%_M:%_SZ",
      "%Y-%_m-%_d %_H:%_M:%_S.%_LZ",
      "%Y-%_m-%_dT%_H:%_M:%_SZ",
      "%Y-%_m-%_dT%_H:%_M:%_S.%_LZ"
    ]
    |> Enum.map(&(str |> from_string(&1, :with_status)))
    |> Enum.filter(&(elem(&1, 0) == :ok))
    |> List.first()
    |> Tpl.ok()
  end

  def to_datetime(value) do
    value
    |> Timex.to_datetime()
    |> DateTime.to_string()
    |> to_datetime
  end

  @doc """
  To JST string from UTC

  ## Examples
      iex> Dt.to_jst( "2018/1/2 10:23:45" )
      "2018/01/02 19:23"
      iex> Dt.to_jst( "2018/1/2 15:23:45" )
      "2018/01/03 00:23"
  """
  def to_jst(utc, cut_second \\ :cut_second) do
    utc
    |> to_datetime
    |> Timex.Timezone.convert("Asia/Tokyo")
    |> DateTime.to_string()
    |> String.replace("+09:00 JST Asia/Tokyo", "")
    |> hyphen_to_slash
    |> cut_second(cut_second)
  end

  @doc """
  Hyphen to slash

  ## Examples
      iex> Dt.hyphen_to_slash( "2018-01-02 03:04:05" )
      "2018/01/02 03:04:05"
      iex> Dt.hyphen_to_slash( "2018/01/02 03:04:05" )
      "2018/01/02 03:04:05"
  """
  def hyphen_to_slash(str), do: str |> String.replace("-", "/")

  @doc """
  Slash to hyphen

  ## Examples
      iex> Dt.slash_to_hyphen( "2018/01/02 03:04:05" )
      "2018-01-02 03:04:05"
      iex> Dt.slash_to_hyphen( "2018-01-02 03:04:05" )
      "2018-01-02 03:04:05"
  """
  def slash_to_hyphen(str), do: str |> String.replace("/", "-")

  def cut_second(str, cut_second \\ :cut_second),
    do: if(cut_second == :cut_second, do: str |> String.slice(0, 16), else: str)
end
