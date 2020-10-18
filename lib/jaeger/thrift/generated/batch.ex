defmodule(Jaeger.Thrift.Generated.Batch) do
  @moduledoc false
  _ = "Auto-generated Thrift struct jaeger.Batch"
  _ = "1: jaeger.Process process"
  _ = "2: list<jaeger.Span> spans"
  _ = "3: i64 seq_no"
  _ = "4: jaeger.ClientStats stats"
  defstruct(process: nil, spans: nil, seq_no: nil, stats: nil)
  @type t :: %__MODULE__{}
  def(new) do
    %__MODULE__{}
  end

  defmodule(BinaryProtocol) do
    @moduledoc false
    def(deserialize(binary)) do
      deserialize(binary, %Jaeger.Thrift.Generated.Batch{})
    end

    defp(deserialize(<<0, rest::binary>>, %Jaeger.Thrift.Generated.Batch{} = acc)) do
      {acc, rest}
    end

    defp(deserialize(<<12, 1::16-signed, rest::binary>>, acc)) do
      case(Elixir.Jaeger.Thrift.Generated.Process.BinaryProtocol.deserialize(rest)) do
        {value, rest} ->
          deserialize(rest, %{acc | process: value})

        :error ->
          :error
      end
    end

    defp(deserialize(<<15, 2::16-signed, 12, remaining::32-signed, rest::binary>>, struct)) do
      deserialize__spans(rest, [[], remaining, struct])
    end

    defp(deserialize(<<10, 3::16-signed, value::64-signed, rest::binary>>, acc)) do
      deserialize(rest, %{acc | seq_no: value})
    end

    defp(deserialize(<<12, 4::16-signed, rest::binary>>, acc)) do
      case(Elixir.Jaeger.Thrift.Generated.ClientStats.BinaryProtocol.deserialize(rest)) do
        {value, rest} ->
          deserialize(rest, %{acc | stats: value})

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

    defp(deserialize__spans(<<rest::binary>>, [list, 0, struct])) do
      deserialize(rest, %{struct | spans: Enum.reverse(list)})
    end

    defp(deserialize__spans(<<rest::binary>>, [list, remaining | stack])) do
      case(Elixir.Jaeger.Thrift.Generated.Span.BinaryProtocol.deserialize(rest)) do
        {element, rest} ->
          deserialize__spans(rest, [[element | list], remaining - 1 | stack])

        :error ->
          :error
      end
    end

    defp(deserialize__spans(_, _)) do
      :error
    end

    def(
      serialize(%Jaeger.Thrift.Generated.Batch{
        process: process,
        spans: spans,
        seq_no: seq_no,
        stats: stats
      })
    ) do
      [
        case(process) do
          nil ->
            raise(
              Thrift.InvalidValueError,
              "Required field :process on Jaeger.Thrift.Generated.Batch must not be nil"
            )

          _ ->
            [<<12, 1::16-signed>> | Jaeger.Thrift.Generated.Process.serialize(process)]
        end,
        case(spans) do
          nil ->
            raise(
              Thrift.InvalidValueError,
              "Required field :spans on Jaeger.Thrift.Generated.Batch must not be nil"
            )

          _ ->
            [
              <<15, 2::16-signed, 12, length(spans)::32-signed>>
              | for(e <- spans) do
                  Jaeger.Thrift.Generated.Span.serialize(e)
                end
            ]
        end,
        case(seq_no) do
          nil ->
            <<>>

          _ ->
            <<10, 3::16-signed, seq_no::64-signed>>
        end,
        case(stats) do
          nil ->
            <<>>

          _ ->
            [<<12, 4::16-signed>> | Jaeger.Thrift.Generated.ClientStats.serialize(stats)]
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
