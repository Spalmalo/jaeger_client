defmodule JaegerClient.MixProject do
  use Mix.Project

  def project do
    [
      app: :jaeger_client,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      compilers: [:thrift | Mix.compilers()],
      thrift: [
        files: Path.wildcard("jaeger-idl/thrift/*.thrift"),
        output_path: "lib/",
        namespace: "Jaeger.Thrift.Generated"
      ],
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:thrift, github: "pinterest/elixir-thrift"}
    ]
  end
end
