defmodule(Jaeger.Thrift.Generated.ThrottlingResponse) do
  @moduledoc(false)
  _ = "Auto-generated Thrift struct throttling.ThrottlingResponse"
  _ = "1: throttling.ThrottlingConfig default_config"
  _ = "2: list<throttling.ServiceThrottlingConfig> service_configs"
  defstruct(default_config: nil, service_configs: nil)
  @type(t :: %__MODULE__{})
  def(new) do
    %__MODULE__{}
  end
  defmodule(BinaryProtocol) do
    @moduledoc(false)
    def(deserialize(binary)) do
      deserialize(binary, %Jaeger.Thrift.Generated.ThrottlingResponse{})
    end
    defp(deserialize(<<0, rest::binary>>, %Jaeger.Thrift.Generated.ThrottlingResponse{} = acc)) do
      {acc, rest}
    end
    defp(deserialize(<<12, 1::16-signed, rest::binary>>, acc)) do
      case(Elixir.Jaeger.Thrift.Generated.ThrottlingConfig.BinaryProtocol.deserialize(rest)) do
        {value, rest} ->
          deserialize(rest, %{acc | default_config: value})
        :error ->
          :error
      end
    end
    defp(deserialize(<<15, 2::16-signed, 12, remaining::32-signed, rest::binary>>, struct)) do
      deserialize__service_configs(rest, [[], remaining, struct])
    end
    defp(deserialize(<<field_type, _id::16-signed, rest::binary>>, acc)) do
      rest |> Thrift.Protocol.Binary.skip_field(field_type) |> deserialize(acc)
    end
    defp(deserialize(_, _)) do
      :error
    end
    defp(deserialize__service_configs(<<rest::binary>>, [list, 0, struct])) do
      deserialize(rest, %{struct | service_configs: Enum.reverse(list)})
    end
    defp(deserialize__service_configs(<<rest::binary>>, [list, remaining | stack])) do
      case(Elixir.Jaeger.Thrift.Generated.ServiceThrottlingConfig.BinaryProtocol.deserialize(rest)) do
        {element, rest} ->
          deserialize__service_configs(rest, [[element | list], remaining - 1 | stack])
        :error ->
          :error
      end
    end
    defp(deserialize__service_configs(_, _)) do
      :error
    end
    def(serialize(%Jaeger.Thrift.Generated.ThrottlingResponse{default_config: default_config, service_configs: service_configs})) do
      [case(default_config) do
        nil ->
          raise(Thrift.InvalidValueError, "Required field :default_config on Jaeger.Thrift.Generated.ThrottlingResponse must not be nil")
        _ ->
          [<<12, 1::16-signed>> | Jaeger.Thrift.Generated.ThrottlingConfig.serialize(default_config)]
      end, case(service_configs) do
        nil ->
          raise(Thrift.InvalidValueError, "Required field :service_configs on Jaeger.Thrift.Generated.ThrottlingResponse must not be nil")
        _ ->
          [<<15, 2::16-signed, 12, length(service_configs)::32-signed>> | for(e <- service_configs) do
            Jaeger.Thrift.Generated.ServiceThrottlingConfig.serialize(e)
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