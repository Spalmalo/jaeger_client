defmodule(Jaeger.Thrift.Generated.Agent) do
  @moduledoc false
  defmodule(EmitBatchArgs) do
    @moduledoc false
    _ = "Auto-generated Thrift struct Elixir.EmitBatchArgs"
    _ = "1: jaeger.Batch batch"
    defstruct(batch: nil)
    @type t :: %__MODULE__{}
    def(new) do
      %__MODULE__{}
    end

    defmodule(BinaryProtocol) do
      @moduledoc false
      def(deserialize(binary)) do
        deserialize(binary, %EmitBatchArgs{})
      end

      defp(deserialize(<<0, rest::binary>>, %EmitBatchArgs{} = acc)) do
        {acc, rest}
      end

      defp(deserialize(<<12, 1::16-signed, rest::binary>>, acc)) do
        case(Elixir.Jaeger.Thrift.Generated.Batch.BinaryProtocol.deserialize(rest)) do
          {value, rest} ->
            deserialize(rest, %{acc | batch: value})

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

      def(serialize(%EmitBatchArgs{batch: batch})) do
        [
          case(batch) do
            nil ->
              <<>>

            _ ->
              [<<12, 1::16-signed>> | Jaeger.Thrift.Generated.Batch.serialize(batch)]
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

  defmodule(Binary.Framed.Client) do
    @moduledoc false
    alias(Thrift.Binary.Framed.Client, as: ClientImpl)
    defdelegate(close(conn), to: ClientImpl)
    defdelegate(connect(conn, opts), to: ClientImpl)
    defdelegate(start_link(host, port, opts \\ []), to: ClientImpl)

    def(unquote(:emit_batch)(client, batch, rpc_opts \\ [])) do
      args = %EmitBatchArgs{batch: batch}
      serialized_args = EmitBatchArgs.BinaryProtocol.serialize(args)

      (
        :ok = ClientImpl.oneway(client, "emitBatch", serialized_args, rpc_opts)
        {:ok, nil}
      )
    end

    def(unquote(:emit_batch!)(client, batch, rpc_opts \\ [])) do
      case(unquote(:emit_batch)(client, batch, rpc_opts)) do
        {:ok, rsp} ->
          rsp

        {:error, {:exception, ex}} ->
          raise(ex)

        {:error, reason} ->
          raise(Thrift.ConnectionError, reason: reason)
      end
    end
  end

  defmodule(Binary.Framed.Server) do
    @moduledoc false
    require(Logger)
    alias(Thrift.Binary.Framed.Server, as: ServerImpl)
    defdelegate(stop(name), to: ServerImpl)

    def(start_link(handler_module, port, opts \\ [])) do
      ServerImpl.start_link(__MODULE__, port, handler_module, opts)
    end

    def(handle_thrift("emitBatch", binary_data, handler_module)) do
      case(
        Elixir.Jaeger.Thrift.Generated.Agent.EmitBatchArgs.BinaryProtocol.deserialize(binary_data)
      ) do
        {%Jaeger.Thrift.Generated.Agent.EmitBatchArgs{batch: batch}, ""} ->
          try do
            rsp = handler_module.emit_batch(batch)

            (
              _ = rsp
              :noreply
            )
          catch
            kind, reason ->
              formatted_exception = Exception.format(kind, reason, System.stacktrace())

              Logger.error(
                "Exception not defined in thrift spec was thrown: #{formatted_exception}"
              )

              error =
                Thrift.TApplicationException.exception(
                  type: :internal_error,
                  message: "Server error: #{formatted_exception}"
                )

              {:server_error, error}
          end

        {_, extra} ->
          raise(Thrift.TApplicationException,
            type: :protocol_error,
            message: "Could not decode #{inspect(extra)}"
          )
      end
    end
  end
end
