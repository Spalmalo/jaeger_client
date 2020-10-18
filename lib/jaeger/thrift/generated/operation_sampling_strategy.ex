defmodule(Jaeger.Thrift.Generated.OperationSamplingStrategy) do
  @moduledoc false
  _ = "Auto-generated Thrift struct sampling.OperationSamplingStrategy"
  _ = "1: string operation"
  _ = "2: sampling.ProbabilisticSamplingStrategy probabilistic_sampling"
  defstruct(operation: nil, probabilistic_sampling: nil)
  @type t :: %__MODULE__{}
  def(new) do
    %__MODULE__{}
  end

  defmodule(BinaryProtocol) do
    @moduledoc false
    def(deserialize(binary)) do
      deserialize(binary, %Jaeger.Thrift.Generated.OperationSamplingStrategy{})
    end

    defp(
      deserialize(<<0, rest::binary>>, %Jaeger.Thrift.Generated.OperationSamplingStrategy{} = acc)
    ) do
      {acc, rest}
    end

    defp(
      deserialize(
        <<11, 1::16-signed, string_size::32-signed, value::binary-size(string_size),
          rest::binary>>,
        acc
      )
    ) do
      deserialize(rest, %{acc | operation: value})
    end

    defp(deserialize(<<12, 2::16-signed, rest::binary>>, acc)) do
      case(
        Elixir.Jaeger.Thrift.Generated.ProbabilisticSamplingStrategy.BinaryProtocol.deserialize(
          rest
        )
      ) do
        {value, rest} ->
          deserialize(rest, %{acc | probabilistic_sampling: value})

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

    def(
      serialize(%Jaeger.Thrift.Generated.OperationSamplingStrategy{
        operation: operation,
        probabilistic_sampling: probabilistic_sampling
      })
    ) do
      [
        case(operation) do
          nil ->
            raise(
              Thrift.InvalidValueError,
              "Required field :operation on Jaeger.Thrift.Generated.OperationSamplingStrategy must not be nil"
            )

          _ ->
            [<<11, 1::16-signed, byte_size(operation)::32-signed>> | operation]
        end,
        case(probabilistic_sampling) do
          nil ->
            raise(
              Thrift.InvalidValueError,
              "Required field :probabilistic_sampling on Jaeger.Thrift.Generated.OperationSamplingStrategy must not be nil"
            )

          _ ->
            [
              <<12, 2::16-signed>>
              | Jaeger.Thrift.Generated.ProbabilisticSamplingStrategy.serialize(
                  probabilistic_sampling
                )
            ]
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
