defmodule(Jaeger.Thrift.Generated.SamplingStrategyResponse) do
  @moduledoc(false)
  _ = "Auto-generated Thrift struct sampling.SamplingStrategyResponse"
  _ = "1: sampling.SamplingStrategyType strategy_type"
  _ = "2: sampling.ProbabilisticSamplingStrategy probabilistic_sampling"
  _ = "3: sampling.RateLimitingSamplingStrategy rate_limiting_sampling"
  _ = "4: sampling.PerOperationSamplingStrategies operation_sampling"
  defstruct(strategy_type: nil, probabilistic_sampling: nil, rate_limiting_sampling: nil, operation_sampling: nil)
  @type(t :: %__MODULE__{})
  def(new) do
    %__MODULE__{}
  end
  defmodule(BinaryProtocol) do
    @moduledoc(false)
    def(deserialize(binary)) do
      deserialize(binary, %Jaeger.Thrift.Generated.SamplingStrategyResponse{})
    end
    defp(deserialize(<<0, rest::binary>>, %Jaeger.Thrift.Generated.SamplingStrategyResponse{} = acc)) do
      {acc, rest}
    end
    defp(deserialize(<<8, 1::16-signed, value::32-signed, rest::binary>>, acc)) do
      deserialize(rest, %{acc | strategy_type: value})
    end
    defp(deserialize(<<12, 2::16-signed, rest::binary>>, acc)) do
      case(Elixir.Jaeger.Thrift.Generated.ProbabilisticSamplingStrategy.BinaryProtocol.deserialize(rest)) do
        {value, rest} ->
          deserialize(rest, %{acc | probabilistic_sampling: value})
        :error ->
          :error
      end
    end
    defp(deserialize(<<12, 3::16-signed, rest::binary>>, acc)) do
      case(Elixir.Jaeger.Thrift.Generated.RateLimitingSamplingStrategy.BinaryProtocol.deserialize(rest)) do
        {value, rest} ->
          deserialize(rest, %{acc | rate_limiting_sampling: value})
        :error ->
          :error
      end
    end
    defp(deserialize(<<12, 4::16-signed, rest::binary>>, acc)) do
      case(Elixir.Jaeger.Thrift.Generated.PerOperationSamplingStrategies.BinaryProtocol.deserialize(rest)) do
        {value, rest} ->
          deserialize(rest, %{acc | operation_sampling: value})
        :error ->
          :error
      end
    end
    defp(deserialize(<<field_type, _id::16-signed, rest::binary>>, acc)) do
      rest |> Thrift.Protocol.Binary.skip_field(field_type) |> deserialize(acc)
    end
    defp(deserialize(_, _)) do
      :error
    end
    def(serialize(%Jaeger.Thrift.Generated.SamplingStrategyResponse{strategy_type: strategy_type, probabilistic_sampling: probabilistic_sampling, rate_limiting_sampling: rate_limiting_sampling, operation_sampling: operation_sampling})) do
      [case(strategy_type) do
        nil ->
          raise(Thrift.InvalidValueError, "Required field :strategy_type on Jaeger.Thrift.Generated.SamplingStrategyResponse must not be nil")
        _ ->
          <<8, 1::16-signed, strategy_type::32-signed>>
      end, case(probabilistic_sampling) do
        nil ->
          <<>>
        _ ->
          [<<12, 2::16-signed>> | Jaeger.Thrift.Generated.ProbabilisticSamplingStrategy.serialize(probabilistic_sampling)]
      end, case(rate_limiting_sampling) do
        nil ->
          <<>>
        _ ->
          [<<12, 3::16-signed>> | Jaeger.Thrift.Generated.RateLimitingSamplingStrategy.serialize(rate_limiting_sampling)]
      end, case(operation_sampling) do
        nil ->
          <<>>
        _ ->
          [<<12, 4::16-signed>> | Jaeger.Thrift.Generated.PerOperationSamplingStrategies.serialize(operation_sampling)]
      end | <<0>>]
    end
  end
  def(serialize(struct)) do
    BinaryProtocol.serialize(struct)
  end
  def(serialize(struct, :binary)) do
    BinaryProtocol.serialize(struct)
  end
  def(deserialize(binary)) do
    BinaryProtocol.deserialize(binary)
  end
end