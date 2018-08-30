defmodule ShopifyPlug.SigvTest do
  use ExUnit.Case
  import PlugHelper

  test "Correct signature" do
    %{url: "/sigv", query: "extra=1&extra=2&shop=shop-name.myshopify.com&path_prefix=%2Fapps%2Fawesome_reviews&timestamp=1317327555&signature=a9718877bea71c2484f91608a7eaea1532bdf71f5c56825065fa4ccabe549ef3"}
    |> make_request()
    |> fetch_all()
    |> ShopifyPlug.Sigv.call([signature: "hush"])
    |> assert_authorized()
  end

  test "Incorrect signature" do
    %{url: "/sigv", query: "extra=1&extra=2&shop=shop-name.myshopify.com&path_prefix=%2Fapps%2Fawesome_reviews&timestamp=1317327555&signature=QWxsIGNvbW11bmljYXRpb25zIHdpdGggb3VyIHNlcnZlcnMgYXJlIG1hZGUgdGhyb3"}
    |> make_request()
    |> fetch_all()
    |> ShopifyPlug.Sigv.call([signature: "hush"])
    |> assert_unauthorized()
  end
end
