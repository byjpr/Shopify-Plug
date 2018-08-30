defmodule SPWeb.Router do
  use SP, :router

  pipeline :stamp, do: plug ShopifyPlug.StampScale
  pipeline :sig, do: plug ShopifyPlug.Sigv, signature: "hush"
  pipeline :param, do: plug ShopifyPlug.Paramv

  scope "/stampscale", ExAppWeb do
    pipe_through :stamp

    post "/" do
      send_resp(conn, 200, "ok")
    end

    post "/400" do
      send_resp(conn, 400, "400")
    end

    post "/500" do
      send_resp(conn, 500, "500")
    end
  end

  scope "/sigv", ExAppWeb do
    pipe_through :sig

    post "/" do
      send_resp(conn, 200, "ok")
    end

    post "/400" do
      send_resp(conn, 400, "400")
    end

    post "/500" do
      send_resp(conn, 500, "500")
    end
  end

  scope "/paramv", ExAppWeb do
    pipe_through :param

    post "/" do
      send_resp(conn, 200, "ok")
    end

    post "/400" do
      send_resp(conn, 400, "400")
    end

    post "/500" do
      send_resp(conn, 500, "500")
    end
  end
end
