defmodule(Jaeger.Thrift.Generated.ZipkinCollector.Handler) do
  @moduledoc false
  @callback submit_zipkin_batch(spans :: [%Jaeger.Thrift.Generated.Span{}]) :: [
              %Jaeger.Thrift.Generated.Response{}
            ]
end
