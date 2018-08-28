defmodule ShopifyPlug.Sigv do
  @moduledoc """
    When Shopify receives an HTTP request for a proxied path, it will forward that request to the specified Proxy URL.
    Cookies are not supported for the application proxy, since the application is accessed through the shop's domain.
    Shopify will strip the Cookie header from the request and Set-Cookie from the response.
    For example, when the following HTTP request is sent from the client user agent:
    ```GET /apps/awesome_reviews/extra/path/components?extra=1&extra=2 HTTP/1.1
      Host: Cogn.myshopify.com
      Cookie: csrftoken=01234456789abcdef0123456789abcde;
      _session_id=1234456789abcdef0123456789abcdef;
      _secure_session_id=234456789abcdef0123456789abcdef0```
    Given that the Proxy URL is set to https://genie.cogcloud.net/proxy,
    the client's IP address is 123.123.123.123 and the applications shared secret is hush,
    the forwarded request will look like the following:
    ```GET /proxy/extra/path/components?extra=1&extra=2&shop=Cogn.myshopify.com&path_prefix=%2Fapps%2Fawesome_reviews&timestamp=1317327555&signature=a9718877bea71c2484f91608a7eaea1532bdf71f5c56825065fa4ccabe549ef3 HTTP/1.1
      Host: genie.cogcloud.net
      X-Forwarded-For: 123.123.123.123```
    Shopify: How proxy requests work: https://help.shopify.com/api/tutorials/application-proxies#proxy-request
    Shopify Security: Calculate a digital signature: https://help.shopify.com/api/tutorials/application-proxies#security
  """

  @behaviour Plug
  use Plug.ErrorHandler

  def init(), do: raise(ArgumentError, message: "missing require options")

  def init(opts) do
    unless opts[:signature],
      do: raise(ArgumentError, message: "missing require argument 'signature'")

    opts
  end

  @doc """
    Knowing that all requests will come with a signature from Shopify. Generated with our Shared Secret and the `params`.
    If we compute a version of the request signature and it matches the one Shopify sent us, it must be Shopify. (or a hax0r).
  """
  def call(conn, opts) do
    fetched = Plug.Conn.fetch_query_params(conn)

    %Plug.Conn{params: params} = fetched
    %{"signature" => signature} = params

    calculated_signature =
      fetched.query_string
      |> create_param_object()
      |> Enum.sort()
      |> Enum.map(fn {k, v} -> stringify(k, v) end)
      |> Enum.join("")
      |> hash(opts)
      |> Base.encode16()
      |> String.downcase()

    case SecureCompare.compare(signature, calculated_signature) do
      true ->
        conn

      false ->
        ShopifyPlug.Errors.failed_connection(conn, :Sigv)
    end
  end

  @doc """
    hash/1 proxies to :crypto.hmac/3
  """
  def hash(query_hash, opts), do: :crypto.hmac(:sha256, opts[:secret], query_hash)

  def create_param_object(params) do
    # Split on the & Char
    # Split each on the = char
    # Make `v` URI decoded
    # Create list of k,v
    # Group same keys
    # pop the signature

    params
    |> String.split("&")
    |> Enum.map(fn v -> String.split(v, "=") end)
    |> Enum.map(fn [k, v] -> [k, URI.decode(v)] end)
    |> Enum.flat_map(fn [k, v] -> ["#{k}": v] end)
    |> Enum.group_by(fn {k, _} -> k end, fn {_, v} -> v end)
    |> Map.delete(:signature)
  end

  defp stringify(key, value) when is_list(value) or is_map(value) do
    csv = Enum.join(value, ",")
    "#{key}=#{csv}"
  end

  defp stringify(key, value) do
    "#{key}=#{value}"
  end
end
