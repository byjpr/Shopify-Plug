defmodule ShopifyPlug.ParamvTest do
  use ExUnit.Case
  import PlugHelper

  @query "extra=1&" <>
           "extra=2&" <>
           "shop=shop-name.myshopify.com&" <>
           "path_prefix=%2Fapps%2Fawesome_reviews&" <>
           "timestamp=1317327555&" <>
           "signature=a9718877bea71c2484f91608a7eaea1532bdf71f5c56825065fa4ccabe549ef3"

  @missing_timestamp "extra=1&" <>
          "extra=2&" <>
          "shop=shop-name.myshopify.com&" <>
          "path_prefix=%2Fapps%2Fawesome_reviews&" <>
          "signature=a9718877bea71c2484f91608a7eaea1532bdf71f5c56825065fa4ccabe549ef3"

  describe "plug" do
    test "Paramv" do
      %{url: "/paramv", query: @query}
      |> make_request()
      |> fetch_all()
      |> ShopifyPlug.Paramv.call([])
      |> assert_authorized()
    end

    test "missing_timestamp" do
      %{url: "/paramv", query: @missing_timestamp}
      |> make_request()
      |> fetch_all()
      |> ShopifyPlug.Paramv.call([])
      |> assert_unauthorized()
    end

    test "No init options" do
      init = ShopifyPlug.Paramv.init()
      assert init == []
    end

    test "init options" do
      init = ShopifyPlug.Paramv.init([sample: "options"])
      assert init == [sample: "options"]
    end
  end
end
