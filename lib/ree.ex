defmodule Ree do
  def main(args) do
    case parse_args(args) do
      {:error, reason} ->
        IO.puts(reason)

      {:ok, {script, script_args, name_type, remote_nodes}} ->
        :net_kernel.start([:ree, name_type])
        modules = Code.compile_file(script)

        remote_nodes
        |> Enum.each(fn node ->
          modules
          |> Enum.each(fn {module, bin} ->
            :rpc.call(node, :code, :load_binary, [module, module, bin])
          end)
        end)

        remote_nodes
        |> Enum.map(fn node ->
          :rpc.call(node, :__Main__, :main, [script_args])
        end)
        |> Enum.zip(remote_nodes)
        |> Enum.each(fn {res, node} ->
          :io.format("~p:\t~p\n", [node, res])
        end)

        remote_nodes
        |> Enum.each(fn node ->
          modules
          |> Enum.each(fn {module, _} ->
            :rpc.call(node, :code, :purge, [module])
            :rpc.call(node, :code, :delete, [module])
          end)
        end)
    end
  end

  defp parse_args(args) do
    case args do
      [script, name, "-t" | targets] when name in ["-s", "-l"] ->
        {:ok, {script, [], get_name_type(name), get_remote_nodes(targets)}}

      [script | t] ->
        script_args = extract_script_args(t)

        case t -- script_args do
          [name, "-t" | targets] ->
            {:ok, {script, script_args, get_name_type(name), get_remote_nodes(targets)}}

          _ ->
            {:error, "invalid arguments"}
        end
    end
  end

  defp get_name_type("-s"), do: :shortnames
  defp get_name_type("-l"), do: :longnames

  defp get_remote_nodes(targets), do: targets |> Enum.map(fn t -> String.to_atom(t) end)

  defp extract_script_args(args), do: extract_script_args(args, [])

  defp extract_script_args([], acc), do: acc |> Enum.reverse()
  defp extract_script_args(["-s" | _], acc), do: acc |> Enum.reverse()
  defp extract_script_args(["-l" | _], acc), do: acc |> Enum.reverse()
  defp extract_script_args([arg | t], acc), do: extract_script_args(t, [arg | acc])
end
