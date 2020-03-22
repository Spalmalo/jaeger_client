defmodule(Jaeger.Thrift.Generated.ThrottlingService.Handler) do
  @moduledoc(false)
  @callback(get_throttling_configs(service_names :: [String.t()]) :: %Jaeger.Thrift.Generated.ThrottlingResponse{})
end