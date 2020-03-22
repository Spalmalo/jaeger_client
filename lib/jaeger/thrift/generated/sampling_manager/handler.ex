defmodule(Jaeger.Thrift.Generated.SamplingManager.Handler) do
  @moduledoc(false)
  @callback(get_sampling_strategy(service_name :: String.t()) :: %Jaeger.Thrift.Generated.SamplingStrategyResponse{})
end