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
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps()
    ]
  end

  # This makes sure your factory and any other modules in test/support are compiled
  # when in the test environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_), do: ["lib", "web"]

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:thrift, github: "pinterest/elixir-thrift"},
      {:faker, "~> 0.13", only: :test}
    ]
  end
end
