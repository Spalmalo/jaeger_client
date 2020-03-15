# JaegerClient

Base span usage:

1. Get span from HTTP Headers and do somthing under new span
2. Get span from string representation and do something with a child/followed span
3. Start new root span and send it as part of something futher

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `jaeger_client` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:jaeger_client, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/jaeger_client](https://hexdocs.pm/jaeger_client).

