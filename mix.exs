defmodule ShopifyPlug.Mixfile do
  use Mix.Project

  def project do
    [
      app: :shopify_plug,
      version: "0.1.0",
      elixir: "~> 1.4",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test],
      description: description(),
      package: package(),
      deps: deps()
    ]
  end

  def application do
    [applications: [:logger]]
  end

  defp description do
    """
    A plug for verifying webhooks are truely from Shopify
    """
  end

  defp deps do
    [
      {:plug, "~> 1.0"},
      {:secure_compare, "~> 0.1.0"},
      {:phoenix, "~> 1.3", only: [:dev, :test]},
      {:excoveralls, "~> 0.9", only: :test},
      {:ex_doc, "~> 0.19", only: :dev}
    ]
  end

  defp package do
    [
      maintainers: ["Jordan Parker"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/byjord/Shopify-Plug"}
    ]
  end
end
