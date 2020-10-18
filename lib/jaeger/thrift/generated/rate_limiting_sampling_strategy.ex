defmodule(Jaeger.Thrift.Generated.RateLimitingSamplingStrategy) do
  @moduledoc false
  _ = "Auto-generated Thrift struct sampling.RateLimitingSamplingStrategy"
  _ = "1: i16 max_traces_per_second"
  defstruct(max_traces_per_second: nil)
  @type t :: %__MODULE__{}
  def(new) do
    %__MODULE__{}
  end

  defmodule(BinaryProtocol) do
    @moduledoc false
    def(deserialize(binary)) do
      deserialize(binary, %Jaeger.Thrift.Generated.RateLimitingSamplingStrategy{})
    end

    defp(
      deserialize(
        <<0, rest::binary>>,
        %Jaeger.Thrift.Generated.RateLimitingSamplingStrategy{} = acc
      )
    ) do
      {acc, rest}
    end

    defp(deserialize(<<6, 1::16-signed, value::16-signed, rest::binary>>, acc)) do
      deserialize(rest, %{acc | max_traces_per_second: value})
    end

    defp(deserialize(<<field_type, _id::16-signed, rest::binary>>, acc)) do
      rest |> Thrift.Protocol.Binary.skip_field(field_type) |> deserialize(acc)
    end

    defp(deserialize(_, _)) do
      :error
    end

    def(
      serialize(%Jaeger.Thrift.Generated.RateLimitingSamplingStrategy{
        max_traces_per_second: max_traces_per_second
      })
    ) do
      [
        case(max_traces_per_second) do
          nil ->
            raise(
              Thrift.InvalidValueError,
              "Required field :max_traces_per_second on Jaeger.Thrift.Generated.RateLimitingSamplingStrategy must not be nil"
            )

          _ ->
            <<6, 1::16-signed, max_traces_per_second::16-signed>>
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
