defmodule(Jaeger.Thrift.Generated.Collector.Handler) do
  @moduledoc(false)
  @callback(submit_batches(batches :: [%Jaeger.Thrift.Generated.Batch{}]) :: [%Jaeger.Thrift.Generated.BatchSubmitResponse{}])
end