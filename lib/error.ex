defmodule ShopifyPlug.Errors do
  require Logger

  def failed_connection(conn, who) do
    case Application.get_env(:map_rewire, :rule) do
      # We allow dev enviorment failing silently
      :allow ->
        allow_action(conn, who)

      _ ->
        block_action(conn, who)
    end
  end

  defp allow_action(conn, who) do
    Logger.warn(fn ->
        "[ShopifyPlug##{who}: ]: Failed. " <>
        "Doing this from a production enviroment will fail with the error code 400."
    end)

    conn
    |> Plug.Conn.put_resp_header("x-spap-#{who}", "softfail")
  end

  def block_action(conn, who) do
    Logger.warn(fn ->
      "[ShopifyPlug##{who}]: Failed. Connection refused, sent error 400."
    end)

    conn
    |> Plug.Conn.put_resp_header("x-spap-#{who}", "fail")
    |> Plug.Conn.send_resp(400, "Bad Request\n")
    |> Plug.Conn.halt()
  end
end
