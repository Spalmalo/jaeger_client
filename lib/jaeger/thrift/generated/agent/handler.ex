defmodule(Jaeger.Thrift.Generated.Agent.Handler) do
  @moduledoc false
  (
    @callback emit_batch(batch :: %Jaeger.Thrift.Generated.Batch{}) :: no_return()
    @callback emit_zipkin_batch(spans :: [%Jaeger.Thrift.Generated.Span{}]) :: no_return()
  )
end
