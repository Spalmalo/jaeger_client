defmodule(Jaeger.Thrift.Generated.PerOperationSamplingStrategies) do
  @moduledoc(false)
  _ = "Auto-generated Thrift struct sampling.PerOperationSamplingStrategies"
  _ = "1: double default_sampling_probability"
  _ = "2: double default_lower_bound_traces_per_second"
  _ = "3: list<sampling.OperationSamplingStrategy> per_operation_strategies"
  _ = "4: double default_upper_bound_traces_per_second"
  defstruct(default_sampling_probability: nil, default_lower_bound_traces_per_second: nil, per_operation_strategies: nil, default_upper_bound_traces_per_second: nil)
  @type(t :: %__MODULE__{})
  def(new) do
    %__MODULE__{}
  end
  defmodule(BinaryProtocol) do
    @moduledoc(false)
    def(deserialize(binary)) do
      deserialize(binary, %Jaeger.Thrift.Generated.PerOperationSamplingStrategies{})
    end
    defp(deserialize(<<0, rest::binary>>, %Jaeger.Thrift.Generated.PerOperationSamplingStrategies{} = acc)) do
      {acc, rest}
    end
    defp(deserialize(<<4, 1::16-signed, 0::1, 2047::11, 0::52, rest::binary>>, acc)) do
      deserialize(rest, %{acc | default_sampling_probability: :inf})
    end
    defp(deserialize(<<4, 1::16-signed, 1::1, 2047::11, 0::52, rest::binary>>, acc)) do
      deserialize(rest, %{acc | default_sampling_probability: :"-inf"})
    end
    defp(deserialize(<<4, 1::16-signed, sign::1, 2047::11, frac::52, rest::binary>>, acc)) do
      deserialize(rest, %{acc | default_sampling_probability: %Thrift.NaN{sign: sign, fraction: frac}})
    end
    defp(deserialize(<<4, 1::16-signed, value::float-signed, rest::binary>>, acc)) do
      deserialize(rest, %{acc | default_sampling_probability: value})
    end
    defp(deserialize(<<4, 2::16-signed, 0::1, 2047::11, 0::52, rest::binary>>, acc)) do
      deserialize(rest, %{acc | default_lower_bound_traces_per_second: :inf})
    end
    defp(deserialize(<<4, 2::16-signed, 1::1, 2047::11, 0::52, rest::binary>>, acc)) do
      deserialize(rest, %{acc | default_lower_bound_traces_per_second: :"-inf"})
    end
    defp(deserialize(<<4, 2::16-signed, sign::1, 2047::11, frac::52, rest::binary>>, acc)) do
      deserialize(rest, %{acc | default_lower_bound_traces_per_second: %Thrift.NaN{sign: sign, fraction: frac}})
    end
    defp(deserialize(<<4, 2::16-signed, value::float-signed, rest::binary>>, acc)) do
      deserialize(rest, %{acc | default_lower_bound_traces_per_second: value})
    end
    defp(deserialize(<<15, 3::16-signed, 12, remaining::32-signed, rest::binary>>, struct)) do
      deserialize__per_operation_strategies(rest, [[], remaining, struct])
    end
    defp(deserialize(<<4, 4::16-signed, 0::1, 2047::11, 0::52, rest::binary>>, acc)) do
      deserialize(rest, %{acc | default_upper_bound_traces_per_second: :inf})
    end
    defp(deserialize(<<4, 4::16-signed, 1::1, 2047::11, 0::52, rest::binary>>, acc)) do
      deserialize(rest, %{acc | default_upper_bound_traces_per_second: :"-inf"})
    end
    defp(deserialize(<<4, 4::16-signed, sign::1, 2047::11, frac::52, rest::binary>>, acc)) do
      deserialize(rest, %{acc | default_upper_bound_traces_per_second: %Thrift.NaN{sign: sign, fraction: frac}})
    end
    defp(deserialize(<<4, 4::16-signed, value::float-signed, rest::binary>>, acc)) do
      deserialize(rest, %{acc | default_upper_bound_traces_per_second: value})
    end
    defp(deserialize(<<field_type, _id::16-signed, rest::binary>>, acc)) do
      rest |> Thrift.Protocol.Binary.skip_field(field_type) |> deserialize(acc)
    end
    defp(deserialize(_, _)) do
      :error
    end
    defp(deserialize__per_operation_strategies(<<rest::binary>>, [list, 0, struct])) do
      deserialize(rest, %{struct | per_operation_strategies: Enum.reverse(list)})
    end
    defp(deserialize__per_operation_strategies(<<rest::binary>>, [list, remaining | stack])) do
      case(Elixir.Jaeger.Thrift.Generated.OperationSamplingStrategy.BinaryProtocol.deserialize(rest)) do
        {element, rest} ->
          deserialize__per_operation_strategies(rest, [[element | list], remaining - 1 | stack])
        :error ->
          :error
      end
    end
    defp(deserialize__per_operation_strategies(_, _)) do
      :error
    end
    def(serialize(%Jaeger.Thrift.Generated.PerOperationSamplingStrategies{default_sampling_probability: default_sampling_probability, default_lower_bound_traces_per_second: default_lower_bound_traces_per_second, per_operation_strategies: per_operation_strategies, default_upper_bound_traces_per_second: default_upper_bound_traces_per_second})) do
      [case(default_sampling_probability) do
        nil ->
          raise(Thrift.InvalidValueError, "Required field :default_sampling_probability on Jaeger.Thrift.Generated.PerOperationSamplingStrategies must not be nil")
        _ ->
          [<<4, 1::16-signed>> | case(default_sampling_probability) do
            :inf ->
              <<0::1, 2047::11, 0::52>>
            :"-inf" ->
              <<1::1, 2047::11, 0::52>>
            %Thrift.NaN{sign: sign, fraction: frac} ->
              <<sign::1, 2047::11, frac::52>>
            _ ->
              <<default_sampling_probability::float-signed>>
          end]
      end, case(default_lower_bound_traces_per_second) do
        nil ->
          raise(Thrift.InvalidValueError, "Required field :default_lower_bound_traces_per_second on Jaeger.Thrift.Generated.PerOperationSamplingStrategies must not be nil")
        _ ->
          [<<4, 2::16-signed>> | case(default_lower_bound_traces_per_second) do
            :inf ->
              <<0::1, 2047::11, 0::52>>
            :"-inf" ->
              <<1::1, 2047::11, 0::52>>
            %Thrift.NaN{sign: sign, fraction: frac} ->
              <<sign::1, 2047::11, frac::52>>
            _ ->
              <<default_lower_bound_traces_per_second::float-signed>>
          end]
      end, case(per_operation_strategies) do
        nil ->
          raise(Thrift.InvalidValueError, "Required field :per_operation_strategies on Jaeger.Thrift.Generated.PerOperationSamplingStrategies must not be nil")
        _ ->
          [<<15, 3::16-signed, 12, length(per_operation_strategies)::32-signed>> | for(e <- per_operation_strategies) do
            Jaeger.Thrift.Generated.OperationSamplingStrategy.serialize(e)
          end]
      end, case(default_upper_bound_traces_per_second) do
        nil ->
          <<>>
        _ ->
          [<<4, 4::16-signed>> | case(default_upper_bound_traces_per_second) do
            :inf ->
              <<0::1, 2047::11, 0::52>>
            :"-inf" ->
              <<1::1, 2047::11, 0::52>>
            %Thrift.NaN{sign: sign, fraction: frac} ->
              <<sign::1, 2047::11, frac::52>>
            _ ->
              <<default_upper_bound_traces_per_second::float-signed>>
          end]
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