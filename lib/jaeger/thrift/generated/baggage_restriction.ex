defmodule(Jaeger.Thrift.Generated.BaggageRestriction) do
  @moduledoc false
  _ = "Auto-generated Thrift struct baggage.BaggageRestriction"
  _ = "1: string baggage_key"
  _ = "2: i32 max_value_length"
  defstruct(baggage_key: nil, max_value_length: nil)
  @type t :: %__MODULE__{}
  def(new) do
    %__MODULE__{}
  end

  defmodule(BinaryProtocol) do
    @moduledoc false
    def(deserialize(binary)) do
      deserialize(binary, %Jaeger.Thrift.Generated.BaggageRestriction{})
    end

    defp(deserialize(<<0, rest::binary>>, %Jaeger.Thrift.Generated.BaggageRestriction{} = acc)) do
      {acc, rest}
    end

    defp(
      deserialize(
        <<11, 1::16-signed, string_size::32-signed, value::binary-size(string_size),
          rest::binary>>,
        acc
      )
    ) do
      deserialize(rest, %{acc | baggage_key: value})
    end

    defp(deserialize(<<8, 2::16-signed, value::32-signed, rest::binary>>, acc)) do
      deserialize(rest, %{acc | max_value_length: value})
    end

    defp(deserialize(<<field_type, _id::16-signed, rest::binary>>, acc)) do
      rest |> Thrift.Protocol.Binary.skip_field(field_type) |> deserialize(acc)
    end

    defp(deserialize(_, _)) do
      :error
    end

    def(
      serialize(%Jaeger.Thrift.Generated.BaggageRestriction{
        baggage_key: baggage_key,
        max_value_length: max_value_length
      })
    ) do
      [
        case(baggage_key) do
          nil ->
            raise(
              Thrift.InvalidValueError,
              "Required field :baggage_key on Jaeger.Thrift.Generated.BaggageRestriction must not be nil"
            )

          _ ->
            [<<11, 1::16-signed, byte_size(baggage_key)::32-signed>> | baggage_key]
        end,
        case(max_value_length) do
          nil ->
            raise(
              Thrift.InvalidValueError,
              "Required field :max_value_length on Jaeger.Thrift.Generated.BaggageRestriction must not be nil"
            )

          _ ->
            <<8, 2::16-signed, max_value_length::32-signed>>
        end
        | <<0>>
      ]
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
