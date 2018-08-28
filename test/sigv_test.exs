defmodule ShopifyPlug.ParamvTest do
  use ExUnit.Case
  use Plug.Test

  @secret "hush"
  @query "extra=1&" <>
           "extra=2&" <>
           "shop=shop-name.myshopify.com&" <>
           "path_prefix=%2Fapps%2Fawesome_reviews" <>
           "&timestamp=1317327555&" <>
           "signature=a9718877bea71c2484f91608a7eaea1532bdf71f5c56825065fa4ccabe549ef3"

  defp assert_unauthorized(conn) do
    assert conn.status == 400
    assert conn.halted
  end

  defp assert_authorized(conn) do
    assert conn.status != 403
    refute conn.halted
  end

  # make_request(%{url: "/", query: @query, secret: @secret})
  defp make_request(%{url: url, query: query, secret: secret}) do
    endpoint = url <> "?" <> query

    conn(:post, endpoint, "")
    |> ShopifyPlug.Sigv.call(secret: secret)
  end

  @tag :urlencoded_valid_request
  test "urlencoded request with valid hmac" do
    %{url: "/", query: @query, secret: @secret}
    |> make_request()
    |> assert_authorized()
  end

  @tag :urlencoded_valid_request
  test "urlencoded request with invalid hmac" do
    %{url: "/", query: @query, secret: "1234"}
    |> make_request()
    |> assert_unauthorized()
  end
end
