ExUnit.start()

defmodule PlugHelper do
  use ExUnit.Case

  def build_conn(method, path, params_or_body \\ nil) do
    Plug.Adapters.Test.Conn.conn(%Plug.Conn{}, method, path, params_or_body)
  end

  def make_request(%{url: url, query: query}) do
    build_conn(:get, url <> "?" <> query, query)
  end

  def assert_unauthorized(conn) do
    assert conn.status == 400
    assert conn.halted
  end

  def assert_authorized(conn) do
    # authorized connections will have a status of nil
    assert conn.status == nil
    refute conn.halted
  end

  def fetch_all(conn) do
    conn
    |> Plug.Conn.fetch_cookies()
    |> Plug.Conn.fetch_query_params()
  end
end
