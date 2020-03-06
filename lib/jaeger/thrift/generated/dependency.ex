defmodule(Jaeger.Thrift.Generated.Dependency) do
  @moduledoc false
  defmodule(GetDependenciesForTraceArgs) do
    @moduledoc false
    _ = "Auto-generated Thrift struct Elixir.GetDependenciesForTraceArgs"
    _ = "1: string trace_id"
    defstruct(trace_id: nil)
    @type t :: %__MODULE__{}
    def(new) do
      %__MODULE__{}
    end

    defmodule(BinaryProtocol) do
      @moduledoc false
      def(deserialize(binary)) do
        deserialize(binary, %GetDependenciesForTraceArgs{})
      end

      defp(deserialize(<<0, rest::binary>>, %GetDependenciesForTraceArgs{} = acc)) do
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

      def(serialize(%GetDependenciesForTraceArgs{trace_id: trace_id})) do
        [
          case(trace_id) do
            nil ->
              raise(
                Thrift.InvalidValueError,
                "Required field :trace_id on GetDependenciesForTraceArgs must not be nil"
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

  defmodule(SaveDependenciesArgs) do
    @moduledoc false
    _ = "Auto-generated Thrift struct Elixir.SaveDependenciesArgs"
    _ = "1: dependency.Dependencies dependencies"
    defstruct(dependencies: nil)
    @type t :: %__MODULE__{}
    def(new) do
      %__MODULE__{}
    end

    defmodule(BinaryProtocol) do
      @moduledoc false
      def(deserialize(binary)) do
        deserialize(binary, %SaveDependenciesArgs{})
      end

      defp(deserialize(<<0, rest::binary>>, %SaveDependenciesArgs{} = acc)) do
        {acc, rest}
      end

      defp(deserialize(<<12, 1::16-signed, rest::binary>>, acc)) do
        case(Elixir.Jaeger.Thrift.Generated.Dependencies.BinaryProtocol.deserialize(rest)) do
          {value, rest} ->
            deserialize(rest, %{acc | dependencies: value})

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

      def(serialize(%SaveDependenciesArgs{dependencies: dependencies})) do
        [
          case(dependencies) do
            nil ->
              <<>>

            _ ->
              [
                <<12, 1::16-signed>>
                | Jaeger.Thrift.Generated.Dependencies.serialize(dependencies)
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

  defmodule(GetDependenciesForTraceResponse) do
    @moduledoc false
    _ = "Auto-generated Thrift struct Elixir.GetDependenciesForTraceResponse"
    _ = "0: dependency.Dependencies success"
    defstruct(success: nil)
    @type t :: %__MODULE__{}
    def(new) do
      %__MODULE__{}
    end

    defmodule(BinaryProtocol) do
      @moduledoc false
      def(deserialize(binary)) do
        deserialize(binary, %GetDependenciesForTraceResponse{})
      end

      defp(deserialize(<<0, rest::binary>>, %GetDependenciesForTraceResponse{} = acc)) do
        {acc, rest}
      end

      defp(deserialize(<<12, 0::16-signed, rest::binary>>, acc)) do
        case(Elixir.Jaeger.Thrift.Generated.Dependencies.BinaryProtocol.deserialize(rest)) do
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

      def(serialize(%GetDependenciesForTraceResponse{success: success})) do
        [
          case(success) do
            nil ->
              <<>>

            _ ->
              [<<12, 0::16-signed>> | Jaeger.Thrift.Generated.Dependencies.serialize(success)]
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

    def(unquote(:get_dependencies_for_trace)(client, trace_id, rpc_opts \\ [])) do
      args = %GetDependenciesForTraceArgs{trace_id: trace_id}
      serialized_args = GetDependenciesForTraceArgs.BinaryProtocol.serialize(args)

      ClientImpl.call(
        client,
        "getDependenciesForTrace",
        serialized_args,
        GetDependenciesForTraceResponse.BinaryProtocol,
        rpc_opts
      )
    end

    def(unquote(:get_dependencies_for_trace!)(client, trace_id, rpc_opts \\ [])) do
      case(unquote(:get_dependencies_for_trace)(client, trace_id, rpc_opts)) do
        {:ok, rsp} ->
          rsp

        {:error, {:exception, ex}} ->
          raise(ex)

        {:error, reason} ->
          raise(Thrift.ConnectionError, reason: reason)
      end
    end

    def(unquote(:save_dependencies)(client, dependencies, rpc_opts \\ [])) do
      args = %SaveDependenciesArgs{dependencies: dependencies}
      serialized_args = SaveDependenciesArgs.BinaryProtocol.serialize(args)

      (
        :ok = ClientImpl.oneway(client, "saveDependencies", serialized_args, rpc_opts)
        {:ok, nil}
      )
    end

    def(unquote(:save_dependencies!)(client, dependencies, rpc_opts \\ [])) do
      case(unquote(:save_dependencies)(client, dependencies, rpc_opts)) do
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

    def(handle_thrift("getDependenciesForTrace", binary_data, handler_module)) do
      case(
        Elixir.Jaeger.Thrift.Generated.Dependency.GetDependenciesForTraceArgs.BinaryProtocol.deserialize(
          binary_data
        )
      ) do
        {%Jaeger.Thrift.Generated.Dependency.GetDependenciesForTraceArgs{trace_id: trace_id}, ""} ->
          try do
            rsp = handler_module.get_dependencies_for_trace(trace_id)

            (
              response = %Jaeger.Thrift.Generated.Dependency.GetDependenciesForTraceResponse{
                success: rsp
              }

              {:reply,
               Elixir.Jaeger.Thrift.Generated.Dependency.GetDependenciesForTraceResponse.BinaryProtocol.serialize(
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

    def(handle_thrift("saveDependencies", binary_data, handler_module)) do
      case(
        Elixir.Jaeger.Thrift.Generated.Dependency.SaveDependenciesArgs.BinaryProtocol.deserialize(
          binary_data
        )
      ) do
        {%Jaeger.Thrift.Generated.Dependency.SaveDependenciesArgs{dependencies: dependencies}, ""} ->
          try do
            rsp = handler_module.save_dependencies(dependencies)

            (
              _ = rsp
              :noreply
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
