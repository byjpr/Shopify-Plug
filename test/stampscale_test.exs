defmodule ShopifyPlug.StampscaleTest do
  use ExUnit.Case
  import PlugHelper

  test "Expired timestamp" do
    %{url: "/stampscale", query: "extra=1&extra=2&shop=shop-name.myshopify.com&path_prefix=%2Fapps%2Fawesome_reviews&timestamp=1317327555&signature=a9718877bea71c2484f91608a7eaea1532bdf71f5c56825065fa4ccabe549ef3"}
    |> make_request()
    |> fetch_all()
    |> ShopifyPlug.StampScale.call([])
    |> assert_unauthorized()
  end
end
