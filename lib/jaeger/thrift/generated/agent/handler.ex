defmodule(Jaeger.Thrift.Generated.Agent.Handler) do
  @moduledoc(false)
  @callback(emit_batch(batch :: %Jaeger.Thrift.Generated.Batch{}) :: no_return())
end