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

  test "No timestamp param" do
    %{url: "/stampscale", query: "extra=1&extra=2&shop=shop-name.myshopify.com&path_prefix=%2Fapps%2Fawesome_reviews"}
    |> make_request()
    |> fetch_all()
    |> ShopifyPlug.StampScale.call([])
    |> assert_unauthorized()
  end

  test "No params" do
    %{url: "/stampscale", query: ""}
    |> make_request()
    |> fetch_all()
    |> ShopifyPlug.StampScale.call([])
    |> assert_unauthorized()
  end

  test "No call/init options" do
    %{url: "/stampscale", query: "extra=1&extra=2&shop=shop-name.myshopify.com&path_prefix=%2Fapps%2Fawesome_reviews&timestamp=1317327555&signature=a9718877bea71c2484f91608a7eaea1532bdf71f5c56825065fa4ccabe549ef3"}
    |> make_request()
    |> fetch_all()
    |> ShopifyPlug.StampScale.call()
    |> assert_unauthorized()
  end

  test "No init options" do
    init = ShopifyPlug.StampScale.init()
    assert init == []
  end

  test "init options" do
    init = ShopifyPlug.StampScale.init([sample: "options"])
    assert init == [sample: "options"]
  end

  test "Time now" do
    timestamp = DateTime.utc_now()
    |> DateTime.to_unix(:millisecond)

    %{url: "/stampscale", query: "extra=1&extra=2&shop=shop-name.myshopify.com&path_prefix=%2Fapps%2Fawesome_reviews&timestamp=#{timestamp}&signature=a9718877bea71c2484f91608a7eaea1532bdf71f5c56825065fa4ccabe549ef3"}
    |> make_request()
    |> fetch_all()
    |> ShopifyPlug.StampScale.call([])
    |> assert_authorized()
  end
end
