defmodule ShopifyPlug.StampScale do
  @behaviour Plug

  def init(), do: []
  def init(default), do: default

  def call(diff, %Plug.Conn{} = conn) when diff < 30 do
    conn
    |> Plug.Conn.put_req_header("x-spap-stampscale", "pass")
  end

  def call(diff, %Plug.Conn{} = conn) when diff > 30 do
    ShopifyPlug.Errors.failed_connection(conn, :stampscale)
  end

  def call(%Plug.Conn{params: %{"timestamp" => timestamp}} = conn, _default) do
    {:ok, shopify_timestamp} = DateTime.from_unix(String.to_integer(timestamp), :millisecond)

    DateTime.utc_now()
    |> DateTime.diff(shopify_timestamp)
    |> call(conn)
  end

  def call(conn, _default) do
    ShopifyPlug.Errors.failed_connection(conn, :stampscale)
  end

  def call(conn) do
    ShopifyPlug.Errors.failed_connection(conn, :stampscale)
  end
end
