defmodule ShopifyPlug.Paramv do
  @behaviour Plug

  def init(), do: []
  def init(default), do: default

  @doc """
  Check that all the parameters we need are set in the connection.
  """
  def call(
        %Plug.Conn{
          params: %{
            "shop" => _shop,
            "signature" => _signature,
            "timestamp" => _timestamp,
            "path_prefix" => _path_prefix
          }
        } = conn,
        _default
      ) do
    conn
    |> Plug.Conn.put_req_header("x-spap-paramv", "pass")
  end

  @doc """
  If the parameters are not set we'll render an error and halt the pipeline
  """
  def call(conn, _default) do
    ShopifyPlug.Errors.failed_connection(conn, :paramv)
  end
end
