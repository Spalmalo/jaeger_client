defmodule(Jaeger.Thrift.Generated.AggregationValidator) do
  @moduledoc false
  defmodule(ValidateTraceArgs) do
    @moduledoc false
    _ = "Auto-generated Thrift struct Elixir.ValidateTraceArgs"
    _ = "1: string trace_id"
    defstruct(trace_id: nil)
    @type t :: %__MODULE__{}
    def(new) do
      %__MODULE__{}
    end

    defmodule(BinaryProtocol) do
      @moduledoc false
      def(deserialize(binary)) do
        deserialize(binary, %ValidateTraceArgs{})
      end

      defp(deserialize(<<0, rest::binary>>, %ValidateTraceArgs{} = acc)) do
        {acc, rest}
      end

      defp(
        deserialize(
          <<11, 1::16-signed, string_size::32-signed, value::binary-size(string_size),
            rest::binary>>,
          acc
        )
      ) do
        deserialize(rest, %{acc | trace_id: value})
      end

      defp(deserialize(<<field_type, _id::16-signed, rest::binary>>, acc)) do
        rest |> Thrift.Protocol.Binary.skip_field(field_type) |> deserialize(acc)
      end

      defp(deserialize(_, _)) do
        :error
      end

      def(serialize(%ValidateTraceArgs{trace_id: trace_id})) do
        [
          case(trace_id) do
            nil ->
              raise(
                Thrift.InvalidValueError,
                "Required field :trace_id on ValidateTraceArgs must not be nil"
              )

            _ ->
              [<<11, 1::16-signed, byte_size(trace_id)::32-signed>> | trace_id]
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

  defmodule(ValidateTraceResponse) do
    @moduledoc false
    _ = "Auto-generated Thrift struct Elixir.ValidateTraceResponse"
    _ = "0: aggregation_validator.ValidateTraceResponse success"
    defstruct(success: nil)
    @type t :: %__MODULE__{}
    def(new) do
      %__MODULE__{}
    end

    defmodule(BinaryProtocol) do
      @moduledoc false
      def(deserialize(binary)) do
        deserialize(binary, %ValidateTraceResponse{})
      end

      defp(deserialize(<<0, rest::binary>>, %ValidateTraceResponse{} = acc)) do
        {acc, rest}
      end

      defp(deserialize(<<12, 0::16-signed, rest::binary>>, acc)) do
        case(
          Elixir.Jaeger.Thrift.Generated.ValidateTraceResponse.BinaryProtocol.deserialize(rest)
        ) do
          {value, rest} ->
            deserialize(rest, %{acc | success: value})

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

      def(serialize(%ValidateTraceResponse{success: success})) do
        [
          case(success) do
            nil ->
              <<>>

            _ ->
              [
                <<12, 0::16-signed>>
                | Jaeger.Thrift.Generated.ValidateTraceResponse.serialize(success)
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

  defmodule(Binary.Framed.Client) do
    @moduledoc false
    alias(Thrift.Binary.Framed.Client, as: ClientImpl)
    defdelegate(close(conn), to: ClientImpl)
    defdelegate(connect(conn, opts), to: ClientImpl)
    defdelegate(start_link(host, port, opts \\ []), to: ClientImpl)

    def(unquote(:validate_trace)(client, trace_id, rpc_opts \\ [])) do
      args = %ValidateTraceArgs{trace_id: trace_id}
      serialized_args = ValidateTraceArgs.BinaryProtocol.serialize(args)

      ClientImpl.call(
        client,
        "validateTrace",
        serialized_args,
        ValidateTraceResponse.BinaryProtocol,
        rpc_opts
      )
    end

    def(unquote(:validate_trace!)(client, trace_id, rpc_opts \\ [])) do
      case(unquote(:validate_trace)(client, trace_id, rpc_opts)) do
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

    def(handle_thrift("validateTrace", binary_data, handler_module)) do
      case(
        Elixir.Jaeger.Thrift.Generated.AggregationValidator.ValidateTraceArgs.BinaryProtocol.deserialize(
          binary_data
        )
      ) do
        {%Jaeger.Thrift.Generated.AggregationValidator.ValidateTraceArgs{trace_id: trace_id}, ""} ->
          try do
            rsp = handler_module.validate_trace(trace_id)

            (
              response = %Jaeger.Thrift.Generated.AggregationValidator.ValidateTraceResponse{
                success: rsp
              }

              {:reply,
               Elixir.Jaeger.Thrift.Generated.AggregationValidator.ValidateTraceResponse.BinaryProtocol.serialize(
                 response
               )}
            )
          rescue
            []
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
